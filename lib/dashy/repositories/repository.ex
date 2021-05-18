defmodule Dashy.Repositories.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  schema "repositories" do
    field :name, :string
    field :user, :string

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:name, :user])
    |> validate_required([:name, :user])
    |> unique_constraint(:unique_repo, name: :unique_index_repo)
  end
end
