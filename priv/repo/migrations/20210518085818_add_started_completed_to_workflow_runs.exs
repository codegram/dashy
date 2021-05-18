defmodule Dashy.Repo.Migrations.AddStartedCompletedToWorkflowRuns do
  use Ecto.Migration

  def change do
    alter table("workflow_runs") do
      add :started_at, :utc_datetime, null: true
      add :completed_at, :utc_datetime, null: true
    end
  end
end
