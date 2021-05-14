defmodule Dashy.TestFetchers.ErroredFetcher do
  @behaviour GitHubWorkflowsFetcher

  @impl GitHubWorkflowsFetcher
  def get(_repo) do
    {:error, "whoops"}
  end
end
