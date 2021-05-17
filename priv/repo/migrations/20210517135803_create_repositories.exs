defmodule Dashy.Repo.Migrations.CreateRepositories do
  use Ecto.Migration

  def change do
    create table(:repositories) do
      add :name, :string
      add :url, :string

      timestamps()
    end

    create unique_index(:repositories, [:url])
  end
end
