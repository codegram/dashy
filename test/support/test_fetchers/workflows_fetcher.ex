defmodule Dashy.TestFetchers.WorkflowsFetcher do
  @behaviour GitHubFetcher

  import Dashy.Factory

  def get(_repo) do
    workflows = [
      params_for(:workflow),
      params_for(:workflow),
      params_for(:workflow)
    ]

    %{body: workflows}
  end
end
