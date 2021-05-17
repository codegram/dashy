defmodule Dashy.TestFetchers.ErroredFetcher do
  @behaviour GitHubWorkflowsFetcher
  @behaviour GitHubWorkflowRunsFetcher

  @impl GitHubWorkflowsFetcher
  def get(repo) do
    {:error, "whoops in #{repo}"}
  end

  @impl GitHubWorkflowRunsFetcher
  def get(repo, branch, page) do
    {:error, "whoops in #{page} of #{repo}, branch #{branch}"}
  end
end
