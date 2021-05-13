defmodule Dashy.FetcherTest do
  use Dashy.DataCase

  alias Dashy.Fetcher
  alias Dashy.Repo
  alias Dashy.Workflows.Workflow

  describe "update_workflows/2" do
    test "fetches workflows from the API and saves them to the DB" do
      assert [] == Repo.all(Workflow)

      Fetcher.update_workflows("my/repo", with: Dashy.TestFetchers.WorkflowsFetcher)

      assert 3 == Repo.all(Workflow) |> Enum.count()
    end
  end
end
