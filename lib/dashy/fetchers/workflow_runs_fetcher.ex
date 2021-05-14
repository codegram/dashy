defmodule Dashy.Fetchers.WorkflowRunsFetcher do
  @doc """
  This module fetches the latest workflow runs for the `develop` branch. Since
  the API returns data from any branch matching the name (both `develop` and
  `chore/l10n/develop` results are returned), we need to keep iterating in pages
  until we find at least the number of results we want.

  The module will try to fetch *at least* 100 results.
  """
  @behaviour GitHubWorkflowRunsFetcher

  @minimum_results_number 100
  @starting_page 1
  @default_branch "develop"

  @expected_fields ~w(
    id node_id name conclusion status created_at updated_at workflow_id
  )

  @impl GitHubWorkflowRunsFetcher
  def get(repo) do
    get(repo, @default_branch, [], page: @starting_page, at_least: @minimum_results_number)
  end

  defp get(repo, branch, current_state, page: page, at_least: limit) do
    if Enum.count(current_state) >= limit do
      %{body: current_state}
    else
      url = build_url(repo, branch, page)

      case GitHubClient.get(url) do
        {:ok, response} ->
          fetched_runs = process(response.body, branch)
          new_state = current_state ++ fetched_runs
          get(repo, branch, new_state, page: page + 1, at_least: limit)

        {:error, result} ->
          {:error, result, current_state}
      end
    end
  end

  defp process(body, branch) do
    body
    |> Jason.decode!()
    |> Map.get("workflow_runs")
    |> parse_body(branch)
  end

  defp parse_body(nil, _), do: []

  defp parse_body(workflow_runs, branch) do
    workflow_runs
    |> Enum.map(fn workflow_run -> parse_workflow_run(workflow_run, branch) end)
    |> remove_nils()
  end

  defp parse_workflow_run(%{"head_branch" => branch} = workflow_run, branch) do
    workflow_run
    |> Map.take(@expected_fields)
    |> Map.new(fn {k, v} -> {String.to_atom(rename_key(k)), v} end)
    |> Map.merge(%{raw_data: workflow_run})
  end

  defp parse_workflow_run(_workflow_run, _branch), do: nil

  defp rename_key("id"), do: "external_id"
  defp rename_key(key), do: key

  defp build_url(repo, branch, page) do
    "https://api.github.com/repos/#{repo}/actions/runs?per_page=100&branch=#{branch}&page=#{page}"
  end

  defp remove_nils(list) do
    list |> Enum.reject(&is_nil/1)
  end
end
