defmodule Dashy.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :name, :string, null: false
      add :user, :string, null: false
      add :branch, :string, null: false

      timestamps()
    end

    create unique_index(:repositories, [:user, :name], name: :unique_index_repo)
  end
end
