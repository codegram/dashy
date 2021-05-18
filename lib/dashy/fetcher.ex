defmodule Dashy.Fetcher do
  alias Dashy.Workflows
  alias Dashy.WorkflowRuns
  alias Dashy.WorkflowRunJobs
  alias Dashy.Fetchers.WorkflowsFetcher
  alias Dashy.Fetchers.WorkflowRunsFetcher
  alias Dashy.Fetchers.WorkflowRunJobsFetcher

  import Ecto.Query

  alias Dashy.Repo

  @starting_page 1
  @minimum_results_number 1000

  def update_workflows(repo, opts \\ []) do
    fetcher_module = Keyword.get(opts, :with, WorkflowsFetcher)
    save_function = &Workflows.create_or_update/1
    repo_name = repo_name(repo)
    attrs = %{repository_id: repo.id}

    save_results(fetcher_module.get(repo_name), save_function, attrs)
  end

  def update_workflow_runs(repo, opts \\ []) do
    fetcher_module = Keyword.get(opts, :with, WorkflowRunsFetcher)
    save_function = &WorkflowRuns.create_or_update/1
    repo_name = repo_name(repo)

    fetch_workflow_runs_and_save(
      repo_name,
      fetcher_module,
      save_function,
      %{branch: repo.branch, page: @starting_page},
      @minimum_results_number
    )
  end

  def update_all_workflow_run_jobs(repo) do
    repo_name = repo_name(repo)

    from(
      r in WorkflowRuns.WorkflowRun,
      select: [:external_id]
    )
    |> Repo.all()
    |> Enum.each(fn workflow_run ->
      Dashy.Fetcher.update_workflow_run_jobs(repo_name, workflow_run)
    end)
  end

  def update_workflow_run_jobs(repo_name, workflow_run, opts \\ []) do
    fetcher_module = Keyword.get(opts, :with, WorkflowRunJobsFetcher)
    save_function = &WorkflowRunJobs.create_or_update/1

    save_results(fetcher_module.get(repo_name, workflow_run.external_id), save_function)
  end

  defp save_results(results, save_function, attrs \\ %{}) do
    case results do
      {:error, error} ->
        [{:fetch_error, error}]

      %{body: results} ->
        results
        |> Enum.map(fn result ->
          save_function.(Map.merge(result, attrs))
        end)
    end
  end

  defp fetch_workflow_runs_and_save(
         _repo_name,
         _fetcher_module,
         _save_function,
         _opts,
         minimum
       )
       when minimum <= 0,
       do: []

  defp fetch_workflow_runs_and_save(
         repo_name,
         fetcher_module,
         save_function,
         %{branch: branch, page: page},
         minimum
       ) do
    results = fetcher_module.get(repo_name, branch, page)

    runs = save_results(results, save_function)

    case runs do
      [{:fetch_error, _}] ->
        runs

      [] ->
        []

      _ ->
        runs ++
          fetch_workflow_runs_and_save(
            repo_name,
            fetcher_module,
            save_function,
            %{branch: branch, page: page + 1},
            minimum - (results.body |> Enum.count())
          )
    end
  end

  defp repo_name(repo), do: "#{repo.user}/#{repo.name}"
end
