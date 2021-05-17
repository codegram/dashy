defmodule Dashy.Repo.Migrations.AddHeadShaToJobs do
  use Ecto.Migration

  def up do
    alter table("workflow_run_jobs") do
      add :head_sha, :string
    end

    execute """
    UPDATE workflow_run_jobs SET head_sha = metadata->'head_sha'::text;
    """

    execute """
    UPDATE workflow_run_jobs SET head_sha = REPLACE(head_sha, '"', '');
    """

    alter table(:workflow_run_jobs) do
      modify :head_sha, :string, null: false
    end
  end

  def down do
    alter table(:workflow_run_jobs) do
      remove :head_sha, :string, null: false
    end
  end
end
