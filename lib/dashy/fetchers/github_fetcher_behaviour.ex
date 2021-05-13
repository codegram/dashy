defmodule GitHubFetcher do
  @callback get(String.t()) :: {:ok, %{body: any()}} | {:error, any()}
end
