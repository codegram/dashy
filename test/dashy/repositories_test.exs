defmodule Dashy.RepositoriesTest do
  use Dashy.DataCase

  alias Dashy.Repositories

  describe "repositories" do
    alias Dashy.Repositories.Repository

    @valid_attrs %{name: "some_name", user: "some_user", branch: "some_branch"}
    @update_attrs %{
      name: "some_updated_name",
      user: "some_updated_user",
      branch: "some_updated_branch"
    }
    @invalid_attrs %{name: nil, user: nil, branch: nil}

    def repository_fixture(attrs \\ %{}) do
      {:ok, repository} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Repositories.create_repository()

      repository
    end

    test "list_repositories/0 returns all repositories" do
      repository = repository_fixture()
      assert Repositories.list_repositories() == [repository]
    end

    test "get_repository!/1 returns the repository with given id" do
      repository = repository_fixture()
      assert Repositories.get_repository!(repository.id) == repository
    end

    test "create_repository/1 with valid data creates a repository" do
      assert {:ok, %Repository{} = repository} = Repositories.create_repository(@valid_attrs)

      assert repository.name == "some_name"
      assert repository.user == "some_user"
      assert repository.branch == "some_branch"
    end

    test "create_repository/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Repositories.create_repository(@invalid_attrs)
    end

    test "update_repository/2 with valid data updates the repository" do
      repository = repository_fixture()

      assert {:ok, %Repository{} = repository} =
               Repositories.update_repository(repository, @update_attrs)

      assert repository.name == "some_updated_name"
      assert repository.user == "some_updated_user"
      assert repository.branch == "some_updated_branch"
    end

    test "update_repository/2 with invalid data returns error changeset" do
      repository = repository_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Repositories.update_repository(repository, @invalid_attrs)

      assert repository == Repositories.get_repository!(repository.id)
    end

    test "delete_repository/1 deletes the repository" do
      repository = repository_fixture()
      assert {:ok, %Repository{}} = Repositories.delete_repository(repository)
      assert_raise Ecto.NoResultsError, fn -> Repositories.get_repository!(repository.id) end
    end

    test "change_repository/1 returns a repository changeset" do
      repository = repository_fixture()
      assert %Ecto.Changeset{} = Repositories.change_repository(repository)
    end
  end
end
