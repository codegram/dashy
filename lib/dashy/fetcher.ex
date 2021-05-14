defmodule Dashy.Fetcher do
  alias Dashy.Workflows
  alias Dashy.WorkflowRuns
  alias Dashy.Fetchers.WorkflowsFetcher

  def update_workflows(repo, opts \\ []) do
    fetcher_module = Keyword.get(opts, :with, WorkflowsFetcher)
    create_function = &Workflows.create_or_update/1

    fetch_and_update(repo, fetcher_module, create_function)
  end

  def update_workflow_runs(repo, opts \\ []) do
    fetcher_module = Keyword.get(opts, :with, WorkflowRunsFetcher)
    create_function = &WorkflowRuns.create_or_update/1

    fetch_and_update(repo, fetcher_module, create_function)
  end

  defp fetch_and_update(repo_name, fetcher_module, create_function) do
    case fetcher_module.get(repo_name) do
      {:error, _} = error ->
        error

      result ->
        result
        |> Map.get(:body)
        |> Enum.each(fn workflow ->
          create_function.(workflow)
        end)
    end
  end
end
