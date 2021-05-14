defmodule GitHubWorkflowsFetcher do
  @callback get(String.t()) :: %{body: any() | [any(), ...]} | {:error, any()}
end

defmodule GitHubWorkflowRunsFetcher do
  @callback get(String.t(), String.t(), Integer.t()) ::
              %{body: any() | [any(), ...]} | {:error, any(), any()}
end

defmodule GitHubWorkflowRunJobsFetcher do
  @callback get(String.t(), Integer.t()) ::
              %{body: any() | [any(), ...]} | {:error, any(), any()}
end
