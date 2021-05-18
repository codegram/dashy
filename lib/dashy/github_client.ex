defmodule GitHubClient do
  def get(url) do
    headers = [
      Authorization: "token #{Application.get_env(:dashy, Dashy.Fetcher)[:token]}"
    ]

    options = [recv_timeout: 30_000]

    case HTTPoison.get(url, headers, options) do
      {:ok, %{status_code: 404} = response} -> {:error, response}
      {:ok, %{status_code: 200} = response} -> {:ok, response}
      {:error, _} = err -> err
    end
  end
end
