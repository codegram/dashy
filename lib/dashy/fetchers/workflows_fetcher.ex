defmodule Dashy.Fetchers.WorkflowsFetcher do
  @behaviour GitHubWorkflowsFetcher

  @expected_fields ~w(
    id node_id name path state created_at updated_at
  )

  @impl GitHubWorkflowsFetcher
  def get(repo) do
    case GitHubClient.get(url(repo)) do
      {:ok, response} -> process(response.body)
      {:error, _} = err -> err
    end
  end

  defp process(body) do
    body
    |> Jason.decode!()
    |> Map.get("workflows")
    |> parse()
  end

  defp parse(nil), do: []

  defp parse(workflows) do
    workflows
    |> Enum.map(fn workflow ->
      workflow
      |> Map.take(@expected_fields)
      |> Map.new(fn {k, v} -> {String.to_atom(rename_key(k)), v} end)
    end)
  end

  defp rename_key("id"), do: "external_id"
  defp rename_key(key), do: key

  defp url(repo) do
    "https://api.github.com/repos/#{repo}/actions/workflows?per_page=100"
  end
end
