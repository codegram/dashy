defmodule Dashy.TestFetchers.WorkflowRunsFetcher do
  @behaviour GitHubWorkflowRunsFetcher

  import Dashy.Factory

  @impl GitHubWorkflowRunsFetcher
  def get(_repo, _branch, _page) do
    workflows = [
      params_for(:workflow_run),
      params_for(:workflow_run)
    ]

    %{body: workflows}
  end
end
