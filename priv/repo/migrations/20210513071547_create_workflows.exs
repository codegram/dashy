defmodule Dashy.Repo.Migrations.CreateWorkflows do
  use Ecto.Migration

  def change do
    create table(:workflows) do
      add :external_id, :bigint, null: false
      add :name, :string, null: false
      add :node_id, :string, null: false
      add :path, :string, null: false
      add :state, :string, null: false

      timestamps(inserted_at: :created_at)
    end

    create unique_index(:workflows, [:external_id])
  end
end
