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
      repo = insert(:repository)

      Fetcher.update_workflows(repo, with: Dashy.TestFetchers.WorkflowsFetcher)

      assert 3 == Repo.all(Workflow) |> Enum.count()
    end

    test "handles errors" do
      repo = insert(:repository)

      assert [{:fetch_error, "whoops in #{repo.user}/#{repo.name}"}] ==
               Fetcher.update_workflows(repo, with: Dashy.TestFetchers.ErroredFetcher)
    end
  end

  describe "update_workflow_runs/2" do
    test "fetches workflow_runs from the API and saves them to the DB" do
      assert [] == Repo.all(WorkflowRun)
      repo = insert(:repository)

      Fetcher.update_workflow_runs(repo,
        with: Dashy.TestFetchers.WorkflowRunsFetcher
      )

      [workflow_run | _] = workflow_runs = Repo.all(WorkflowRun)
      assert 2 == workflow_runs |> Enum.count()

      assert %Workflow{} = workflow_run |> Repo.preload(:workflow) |> Map.get(:workflow)
      assert %{"foo" => 1} = workflow_run.metadata
      assert workflow_run.head_sha
    end

    test "handles errors" do
      repo = insert(:repository)

      assert [{:fetch_error, "whoops in 1 of #{repo.user}/#{repo.name}, branch #{repo.branch}"}] ==
               Fetcher.update_workflow_runs(repo,
                 with: Dashy.TestFetchers.ErroredFetcher
               )
    end
  end

  describe "update_workflows_run_jobs/2" do
    test "fetches workflow run jobs from the API and saves them to the DB" do
      assert [] == Repo.all(WorkflowRunJob)
      repo = insert(:repository)
      workflow_run = insert(:workflow_run)

      Fetcher.update_workflow_run_jobs(repo, workflow_run,
        with: Dashy.TestFetchers.WorkflowRunJobsFetcher
      )

      assert 2 == Repo.all(WorkflowRunJob) |> Enum.count()
    end

    test "handles errors" do
      repo = insert(:repository)

      assert [{:fetch_error, "whoops in #{repo.user}/#{repo.name}"}] ==
               Fetcher.update_workflows(repo, with: Dashy.TestFetchers.ErroredFetcher)
    end
  end
end
