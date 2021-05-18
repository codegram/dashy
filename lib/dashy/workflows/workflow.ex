defmodule Dashy.Workflows.Workflow do
  use Dashy.Schema
  import Ecto.Changeset

  alias Dashy.Repositories.Repository

  schema "workflows" do
    field :external_id, :integer
    field :name, :string
    field :node_id, :string
    field :path, :string
    field :state, :string

    belongs_to :repository, Repository

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(workflow, attrs) do
    workflow
    |> cast(attrs, [:external_id, :name, :path, :node_id, :state, :repository_id])
    |> validate_required([:external_id, :name, :node_id, :path, :state, :repository_id])
    |> unique_constraint(:external_id)
  end
end
