defmodule Dashy.DevSeeder do
  @moduledoc """
  Module to create fake data to use in development environment
  """

  alias Dashy.Repositories
  alias Dashy.Repositories.Repository
  alias Dashy.Workflows.Workflow
  alias Dashy.WorkflowRuns.WorkflowRun
  alias Dashy.WorkflowRunJobs.WorkflowRunJob

  alias Dashy.Repo


  def create_repo(user, name, branch) do
    {:ok, repo} = Repositories.create_repository(%{user: user, name: name, branch: branch})
    Dashy.Fetcher.update_workflows(repo)
    Dashy.Fetcher.update_workflow_runs(repo)
    Dashy.Fetcher.update_all_workflow_run_jobs(repo)
  end

  def delete_data do
    Repo.delete_all(WorkflowRunJob)
    Repo.delete_all(WorkflowRun)
    Repo.delete_all(Workflow)
    Repo.delete_all(Repository)
  end

end

Dashy.DevSeeder.delete_data()
Dashy.DevSeeder.create_repo("decidim", "decidim-bulletin-board", "develop")
Dashy.DevSeeder.create_repo("ether", "etherpad-lite", "develop")
Dashy.DevSeeder.create_repo("discourse", "discourse", "master")
