defmodule GitHubFetcher do
  @callback get(String.t()) :: %{body: any() | [any(), ...]} | {:error, any()}
end
