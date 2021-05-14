defmodule Dashy.Repo.Migrations.AddHeadShaToWorkflowRuns do
  use Ecto.Migration

  def up do
    alter table("workflow_runs") do
      add :head_sha, :string
    end

    execute """
    UPDATE workflow_runs SET head_sha = metadata->'head_sha';
    """

    alter table(:workflow_runs) do
      modify :head_sha, :string, null: false
    end
  end

  def down do
    alter table(:workflow_runs) do
      remove :head_sha, :string, null: false
    end
  end
end
