defmodule Dashy.TestFetchers.ErroredFetcher do
  @behaviour GitHubFetcher

  @impl GitHubFetcher
  def get(_repo) do
    {:error, "whoops"}
  end
end
