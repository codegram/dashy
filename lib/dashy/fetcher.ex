defmodule Dashy.Fetcher do
  alias Dashy.Workflows
  alias Dashy.Fetchers.WorkflowsFetcher

  def update_workflows(repo, opts \\ []) do
    fetcher_module = Keyword.get(opts, :with, WorkflowsFetcher)

    case fetcher_module.get(repo) do
      {:error, _} = error ->
        error

      result ->
        result
        |> Map.get(:body)
        |> Enum.each(fn workflow ->
          Workflows.create_or_update(workflow)
        end)
    end
  end
end
