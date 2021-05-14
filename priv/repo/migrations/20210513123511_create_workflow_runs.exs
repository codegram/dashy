defmodule Dashy.Repo.Migrations.CreateWorkflowRuns do
  use Ecto.Migration

  def change do
    create table("workflow_runs") do
      add :external_id, :integer, null: false
      add :name, :string, null: false
      add :node_id, :string, null: false
      add :conclusion, :string, null: false
      add :status, :string, null: false
      add :workflow_id, references(:workflows, column: :external_id, type: :integer), null: false
      add :metadata, :jsonb

      timestamps(inserted_at: :created_at)
    end

    create unique_index(:workflow_runs, [:external_id])
  end
end
