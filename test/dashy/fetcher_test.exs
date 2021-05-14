defmodule Dashy.FetcherTest do
  use Dashy.DataCase

  alias Dashy.Fetcher
  alias Dashy.Repo
  alias Dashy.Workflows.Workflow
  alias Dashy.WorkflowRuns.WorkflowRun

  describe "update_workflows/2" do
    test "fetches workflows from the API and saves them to the DB" do
      assert [] == Repo.all(Workflow)

      Fetcher.update_workflows("my/repo", with: Dashy.TestFetchers.WorkflowsFetcher)

      assert 3 == Repo.all(Workflow) |> Enum.count()
    end

    test "handles errors" do
      assert {:error, _} =
               Fetcher.update_workflows("my/repo", with: Dashy.TestFetchers.ErroredFetcher)
    end
  end

  describe "update_workflow_runs/2" do
    test "fetches workflow_runs from the API and saves them to the DB" do
      assert [] == Repo.all(WorkflowRun)

      Fetcher.update_workflow_runs("my/repo", with: Dashy.TestFetchers.WorkflowRunsFetcher)

      [workflow_run, _] = workflow_runs = Repo.all(WorkflowRun)
      assert 2 == workflow_runs |> Enum.count()

      assert %Workflow{} = workflow_run |> Repo.preload(:workflow) |> Map.get(:workflow)
      assert %{"foo" => 1} = workflow_run.metadata
      assert workflow_run.head_sha
    end

    test "handles errors" do
      assert {:error, _} =
               Fetcher.update_workflow_runs("my/repo", with: Dashy.TestFetchers.ErroredFetcher)
    end
  end
end
