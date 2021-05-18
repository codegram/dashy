defmodule Dashy.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :name, :string
      add :user, :string

      timestamps()
    end

    create unique_index(:repositories, [:user, :name], name: :unique_index_repo)
  end
end
