defmodule Dashy.Fetchers.WorkflowsFetcher do
  @behaviour GitHubFetcher

  @expected_fields ~w(
    id node_id name path state created_at updated_at
  )

  @impl GitHubFetcher
  def get(repo) do
    case HTTPoison.get(url(repo)) do
      {:ok, %{status_code: 404} = response} -> {:error, response}
      {:ok, %{status_code: 200} = response} -> process(response.body)
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
