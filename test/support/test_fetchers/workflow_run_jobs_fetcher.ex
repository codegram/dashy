defmodule Dashy.TestFetchers.WorkflowRunJobsFetcher do
  @behaviour GitHubWorkflowRunJobsFetcher

  import Dashy.Factory

  @impl GitHubWorkflowRunJobsFetcher
  def get(_repo, id) do
    workflow_run_jobs = [
      params_for(:workflow_run_job, workflow_run_id: id),
      params_for(:workflow_run_job, workflow_run_id: id)
    ]

    %{body: workflow_run_jobs}
  end
end
