defmodule Dashy.Repositories.Repository do
  use Ecto.Schema
  import Ecto.Changeset

  alias Dashy.Workflows.Workflow

  schema "repositories" do
    field :name, :string
    field :user, :string
    field :branch, :string

    has_many :workflows, Workflow

    timestamps()
  end

  @doc false
  def changeset(repository, attrs) do
    repository
    |> cast(attrs, [:name, :user, :branch])
    |> validate_required([:name, :user, :branch])
    |> unique_constraint(:unique_repo, name: :unique_index_repo)
  end
end
