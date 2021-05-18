defmodule Dashy.FetcherTest do
  use Dashy.DataCase

  alias Dashy.Fetcher
  alias Dashy.Repo
  alias Dashy.Workflows.Workflow
  alias Dashy.WorkflowRuns.WorkflowRun
  alias Dashy.WorkflowRunJobs.WorkflowRunJob

  describe "update_workflows/2" do
    test "fetches workflows from the API and saves them to the DB" do
      assert [] == Repo.all(Workflow)

      Fetcher.update_workflows("my/repo", with: Dashy.TestFetchers.WorkflowsFetcher)

      assert 3 == Repo.all(Workflow) |> Enum.count()
    end

    test "handles errors" do
      assert [{:fetch_error, "whoops in my/repo"}] =
               Fetcher.update_workflows("my/repo", with: Dashy.TestFetchers.ErroredFetcher)
    end
  end

  describe "update_workflow_runs/2" do
    test "fetches workflow_runs from the API and saves them to the DB" do
      assert [] == Repo.all(WorkflowRun)

      Fetcher.update_workflow_runs("my/repo", "my_branch",
        with: Dashy.TestFetchers.WorkflowRunsFetcher
      )

      [workflow_run | _] = workflow_runs = Repo.all(WorkflowRun)
      assert 2 == workflow_runs |> Enum.count()

      assert %Workflow{} = workflow_run |> Repo.preload(:workflow) |> Map.get(:workflow)
      assert %{"foo" => 1} = workflow_run.metadata
      assert workflow_run.head_sha
    end

    test "handles errors" do
      assert [{:fetch_error, "whoops in 1 of my/repo, branch my_branch"}] =
               Fetcher.update_workflow_runs("my/repo", "my_branch",
                 with: Dashy.TestFetchers.ErroredFetcher
               )
    end
  end

  describe "update_workflows_run_jobs/2" do
    test "fetches workflow run jobs from the API and saves them to the DB" do
      assert [] == Repo.all(WorkflowRunJob)

      workflow_run = insert(:workflow_run)

      Fetcher.update_workflow_run_jobs("my/repo", workflow_run,
        with: Dashy.TestFetchers.WorkflowRunJobsFetcher
      )

      assert 2 == Repo.all(WorkflowRunJob) |> Enum.count()
    end

    test "handles errors" do
      assert [{:fetch_error, "whoops in my/repo"}] =
               Fetcher.update_workflows("my/repo", with: Dashy.TestFetchers.ErroredFetcher)
    end
  end
end
