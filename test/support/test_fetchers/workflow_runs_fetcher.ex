defmodule Dashy.TestFetchers.WorkflowRunsFetcher do
  @behaviour GitHubWorkflowRunsFetcher

  import Dashy.Factory

  @impl GitHubWorkflowRunsFetcher
  def get(_repo, _branch, 1) do
    workflow_runs = [
      params_for(:workflow_run_with_workflow_id),
      params_for(:workflow_run_with_workflow_id)
    ]

    %{body: workflow_runs}
  end

  @impl GitHubWorkflowRunsFetcher
  def get(_repo, _branch, _page), do: %{body: []}
end
