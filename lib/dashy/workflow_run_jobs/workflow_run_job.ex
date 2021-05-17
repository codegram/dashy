defmodule Dashy.WorkflowRunJobs.WorkflowRunJob do
  use Dashy.Schema
  import Ecto.Changeset

  schema "workflow_run_jobs" do
    field :external_id, :integer
    field :name, :string
    field :node_id, :string
    field :status, :string
    field :conclusion, :string
    field :started_at, :utc_datetime
    field :completed_at, :utc_datetime
    field :metadata, :map

    belongs_to :workflow_run, Dashy.WorkflowRuns.WorkflowRun, references: :external_id
    timestamps(inserted_at: :created_at)
  end

  @doc false
  def changeset(workflow, attrs) do
    workflow
    |> cast(attrs, [
      :external_id,
      :name,
      :node_id,
      :status,
      :conclusion,
      :started_at,
      :completed_at,
      :workflow_run_id,
      :metadata
    ])
    |> validate_required([
      :external_id,
      :name,
      :node_id,
      :status,
      :conclusion,
      :started_at,
      :workflow_run_id,
      :metadata
    ])
    |> unique_constraint(:external_id)
  end
end
