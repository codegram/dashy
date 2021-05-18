defmodule Dashy.Fetchers.WorkflowRunsFetcher do
  @doc """
  This module fetches the latest workflow runs for the given branch and the
  given page.
  """
  @behaviour GitHubWorkflowRunsFetcher

  @expected_fields ~w(
    id node_id name conclusion status created_at updated_at workflow_id head_sha
  )

  @impl GitHubWorkflowRunsFetcher
  def get(repo_name, branch, page) do
    url = build_url(repo_name, branch, page)

    case GitHubClient.get(url) do
      {:ok, response} -> %{body: process(response.body, branch)}
      {:error, _} = err -> err
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
    |> uniq_sha_for_scheduled_runs()
    |> Map.take(@expected_fields)
    |> Map.new(fn {k, v} -> {String.to_atom(rename_key(k)), v} end)
    |> Map.merge(%{metadata: workflow_run})
  end

  defp parse_workflow_run(_workflow_run, _branch), do: nil

  defp uniq_sha_for_scheduled_runs(
         %{"event" => "schedule", "head_sha" => head_sha, "id" => external_id} = workflow_run
       ) do
    workflow_run
    |> Map.merge(%{"head_sha" => "#{head_sha}-#{external_id}"})
  end

  defp uniq_sha_for_scheduled_runs(workflow_run), do: workflow_run

  defp rename_key("id"), do: "external_id"
  defp rename_key(key), do: key

  defp build_url(repo, branch, page) do
    "https://api.github.com/repos/#{repo}/actions/runs?per_page=100&branch=#{branch}&page=#{page}"
  end

  defp remove_nils(list) do
    list |> Enum.reject(&is_nil/1)
  end
end
