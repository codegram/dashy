defmodule Dashy.TestFetchers.WorkflowRunsFetcher do
  @behaviour GitHubWorkflowRunsFetcher

  import Dashy.Factory

  @impl GitHubWorkflowRunsFetcher
  def get(_repo, _branch, 1) do
    workflow_runs = [
      params_for(:workflow_run),
      params_for(:workflow_run)
    ]

    %{body: workflow_runs}
  end

  @impl GitHubWorkflowRunsFetcher
  def get(_repo, _branch, _page), do: %{body: []}
end
