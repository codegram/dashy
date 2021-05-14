defmodule Dashy.Fetcher do
  alias Dashy.Workflows
  alias Dashy.WorkflowRuns
  alias Dashy.Fetchers.WorkflowsFetcher
  alias Dashy.Fetchers.WorkflowRunsFetcher

  @minimum_results_number 200
  @starting_page 1
  @default_branch "develop"

  def update_workflows(repo_name, opts \\ []) do
    fetcher_module = Keyword.get(opts, :with, WorkflowsFetcher)
    save_function = &Workflows.create_or_update/1

    save_results(fetcher_module.get(repo_name), save_function)
  end

  def update_workflow_runs(repo_name, opts \\ []) do
    fetcher_module = Keyword.get(opts, :with, WorkflowRunsFetcher)
    save_function = &WorkflowRuns.create_or_update/1

    fetch_workflow_runs_and_save(
      repo_name,
      fetcher_module,
      save_function,
      @default_branch,
      @starting_page,
      @minimum_results_number
    )
  end


  defp save_results(results, save_function) do
    case results do
      {:error, _} ->
        false

      %{body: results} ->
        results
        |> Enum.each(fn workflow ->
          save_function.(workflow)
        end)

        true
    end
  end

  defp fetch_workflow_runs_and_save(
         _repo_name,
         _fetcher_module,
         _save_function,
         _branch,
         _page,
         minimum
       )
       when minimum <= 0 do
  end

  defp fetch_workflow_runs_and_save(
         repo_name,
         fetcher_module,
         save_function,
         branch,
         page,
         minimum
       ) do
    results = fetcher_module.get(repo_name, branch, page)

    save_results(results, save_function) &&
      fetch_workflow_runs_and_save(
        repo_name,
        fetcher_module,
        save_function,
        "develop",
        page + 1,
        minimum - (results.body |> Enum.count())
      )
  end
end
