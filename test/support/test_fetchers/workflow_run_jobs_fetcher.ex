defmodule Dashy.TestFetchers.WorkflowRunJobsFetcher do
  @behaviour GitHubWorkflowRunJobsFetcher

  import Dashy.Factory

  @impl GitHubWorkflowRunJobsFetcher
  def get(_repo, _workflow_run) do
    workflow_run_jobs = [
      params_for(:workflow_run_job),
      params_for(:workflow_run_job)
    ]

    %{body: workflow_run_jobs}
  end
end
