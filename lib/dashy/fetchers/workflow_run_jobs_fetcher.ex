defmodule Dashy.Fetchers.WorkflowRunJobsFetcher do
  @doc """
  This module fetches the all the workflow run jobs for the given workflow run.
  """
  @behaviour GitHubWorkflowRunJobsFetcher

  @expected_fields ~w(
    id node_id name conclusion status started_at completed_at
  )

  @impl GitHubWorkflowRunJobsFetcher
  def get(repo_name, workflow_run_external_id) do
    url = build_url(repo_name, workflow_run_external_id)

    case GitHubClient.get(url) do
      {:ok, response} -> %{body: process(response.body, workflow_run_external_id)}
      {:error, _} = err -> err
    end
  end

  defp process(body, workflow_run_id) do
    body
    |> Jason.decode!()
    |> Map.get("jobs")
    |> parse_body(workflow_run_id)
  end

  defp parse_body(nil, _), do: []

  defp parse_body(workflow_run_jobs, workflow_run_id) do
    workflow_run_jobs
    |> Enum.map(fn workflow_run_job ->
      parse_workflow_run_job(workflow_run_job, workflow_run_id)
    end)
  end

  defp parse_workflow_run_job(workflow_run_job, workflow_run_id) do
    workflow_run_job
    |> Map.take(@expected_fields)
    |> Map.new(fn {k, v} -> {String.to_atom(rename_key(k)), v} end)
    |> Map.merge(%{metadata: workflow_run_job, workflow_run_id: workflow_run_id})
  end

  defp rename_key("id"), do: "external_id"
  defp rename_key(key), do: key

  defp build_url(repo, run_id) do
    "https://api.github.com/repos/#{repo}/actions/runs/#{run_id}/jobs"
  end
end
