defmodule Dashy.Repo.Migrations.CreateWorkflowRunJobs do
  use Ecto.Migration

  def change do
    create table("workflow_run_jobs") do
      add :external_id, :bigint, null: false
      add :name, :string, null: false
      add :node_id, :string, null: false
      add :conclusion, :string, null: false
      add :status, :string, null: false
      add :started_at, :utc_datetime, null: false
      add :completed_at, :utc_datetime, null: true

      add :workflow_run_id, references(:workflow_runs, column: :external_id, type: :integer),
        null: false

      add :metadata, :jsonb

      timestamps(inserted_at: :created_at)
    end

    create unique_index(:workflow_run_jobs, [:external_id])
  end
end
