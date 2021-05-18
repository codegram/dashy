import { k8s, pulumi, docker, gcp } from "@codegram/pulumi-utils";

const host = "dashy.codegram.io";

/**
 * Get a reference to the stack that was used to create
 * the genesis Kubernetes cluster. In order to make it work you need to add
 * the `clusterStackRef` config value like this:
 *
 * $ pulumi config set clusterStackRef codegram/genesis-cluster/prod
 */
const stackReference = pulumi.getStackReference({
  name: pulumi.getValueFromConfig("clusterStackRef"),
});

/**
 * Create a Kubernetes provider that will be used by all resources. This function
 * uses the previous `stackReference` outputs to create the provider for the
 * Genesis Kubernetes cluster.
 */
const kubernetesProvider = k8s.buildProvider({
  name: "dashy",
  kubeconfig: stackReference.requireOutput("kubeconfig"),
  namespace: stackReference.requireOutput("appsNamespaceName"),
});

const passwordDb = pulumi.createRandomPassword({ name: "dashy-db" });
const { database, user } = gcp.createDatabase({
  name: "dashy",
  username: "dashy",
  password: passwordDb as any,
});

const databaseUrl = pulumi.interpolate`postgresql://${user.name}:${user.password}@${database.publicIpAddress}:5432/dashy`;
const secretKeyBase = pulumi.createRandomPassword({
  name: "dashy-secret-key-base",
  length: 128,
});

const githubToken = pulumi.getSecretFromConfig("githubToken");
const env = [
  { name: "DATABASE_URL", value: databaseUrl },
  { name: "SECRET_KEY_BASE", value: secretKeyBase },
  { name: "GITHUB_TOKEN", value: githubToken },
  { name: "HOST", value: host },
];

/**
 * Create a new docker image. Use the `context` option to specify where
 * the `Dockerfile`is located.
 *
 * NOTE: to make this code work you need to add the following config value:
 *
 * $ pulumi config set gcpProjectId labs-260007
 *
 * The reason for that is we are pushing the docker images to Google cloud right now.
 */
const dockerImage = docker.buildImage({
  name: "dashy",
  context: "..",
  args: {
    databaseUrl,
    secretKeyBase,
    githubToken,
    host,
  },
});

const createJob = k8s.createJob({
  name: "dashy-create-db",
  containerArgs: ["eval", '"Dashy.Release.db_create"'],
  env,
  provider: kubernetesProvider,
  dockerImageName: dockerImage.imageName,
});

const migrateJob = k8s.createJob({
  name: "dashy-migrate-db",
  containerArgs: ["eval", '"Dashy.Release.db_migrate"'],
  env,
  provider: kubernetesProvider,
  dockerImageName: dockerImage.imageName,
  dependsOn: [createJob],
});

/**
 * Create a Kubernetes application using the previous docker image. Change the `port` and
 * `replicas` to match your needs.
 *
 * This function creates a `Deployment`, `Service` and `Ingress` objects. The application
 * will be accessible in dashy.codegram.io"
 */
k8s.createApplication({
  name: "dashy",
  deploymentOptions: {
    host: host,
    port: 5000,
    replicas: 1,
    env,
  },
  dockerImageName: dockerImage.imageName,
  provider: kubernetesProvider,
  dependsOn: [migrateJob],
});
