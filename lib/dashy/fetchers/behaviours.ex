defmodule GitHubWorkflowsFetcher do
  @callback get(String.t()) :: %{body: any() | [any(), ...]} | {:error, any()}
end

defmodule GitHubWorkflowRunsFetcher do
  @callback get(String.t(), String.t(), integer()) ::
              %{body: any() | [any(), ...]} | {:error, any(), any()}
end

defmodule GitHubWorkflowRunJobsFetcher do
  @callback get(String.t(), integer()) ::
              %{body: any() | [any(), ...]} | {:error, any(), any()}
end
