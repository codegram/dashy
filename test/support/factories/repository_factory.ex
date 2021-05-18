defmodule Dashy.RepositoryFactory do
  @moduledoc """
    This module contains the repository factories.
  """

  use ExMachina.Ecto, repo: Dashy.Repo

  defmacro __using__(_opts) do
    quote do
      def repository_factory do
        %Dashy.Repositories.Repository{
          user: sequence(:user, &"user-#{&1}"),
          name: "repo",
          branch: "branch"
        }
      end
    end
  end
end
