defmodule Dashy.TestFetchers.WorkflowsFetcher do
  @behaviour GitHubWorkflowsFetcher

  import Dashy.Factory

  @impl GitHubWorkflowsFetcher
  def get(_repo) do
    workflows = [
      params_for(:workflow),
      params_for(:workflow),
      params_for(:workflow)
    ]

    %{body: workflows}
  end
end
