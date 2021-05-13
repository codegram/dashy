defmodule Dashy.Workflows.Workflow do
  use Dashy.Schema
  import Ecto.Changeset

  schema "workflows" do
    field :external_id, :integer
    field :name, :string
    field :node_id, :string
    field :path, :string
    field :state, :string

    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(workflow, attrs) do
    workflow
    |> cast(attrs, [:external_id, :name, :path, :node_id, :state])
    |> validate_required([:external_id, :name, :node_id, :path, :state])
    |> unique_constraint(:external_id)
  end
end
