defmodule Dashy.WorkflowRuns.WorkflowRun do
  use Dashy.Schema
  import Ecto.Changeset

  schema "workflow_runs" do
    field :external_id, :integer
    field :name, :string
    field :node_id, :string
    field :status, :string
    field :conclusion, :string
    field :metadata, :map
    field :head_sha, :string

    belongs_to :workflow, Dashy.Workflows.Workflow, references: :external_id
    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(workflow, attrs) do
    workflow
    |> cast(attrs, [
      :created_at,
      :updated_at,
      :external_id,
      :name,
      :node_id,
      :status,
      :conclusion,
      :workflow_id,
      :metadata,
      :head_sha
    ])
    |> validate_required([
      :external_id,
      :name,
      :node_id,
      :status,
      :conclusion,
      :workflow_id,
      :metadata,
      :head_sha
    ])
    |> unique_constraint(:external_id)
  end
end
