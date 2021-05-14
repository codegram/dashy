defmodule GitHubClient do
  def get(url) do
    headers = [
      Authorization: Application.get_env(:dashy, Dashy.Fetcher)[:token]
    ]

    case HTTPoison.get(url, headers) do
      {:ok, %{status_code: 404} = response} -> {:error, response}
      {:ok, %{status_code: 200} = response} -> {:ok, response}
      {:error, _} = err -> err
    end
  end
end
