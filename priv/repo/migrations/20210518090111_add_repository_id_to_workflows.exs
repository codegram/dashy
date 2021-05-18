defmodule Dashy.Repo.Migrations.AddRepositoryIdToWorkflows do
  use Ecto.Migration

  def change do
    alter table("workflows") do
      add :repository_id, references(:repositories, on_delete: :delete_all), null: false
    end
  end
end
