defmodule Dashy.DevSeeder do
  @moduledoc """
  Module to create fake data to use in development environment
  """

  alias Dashy.Repositories
  alias Dashy.Repositories.Repository

  alias Dashy.Repo


  def create_repo do
    {:ok, repo} = Repositories.create_repository(%{user: "decidim", name: "decidim-bulletin-board", branch: "develop"})
    Dashy.Fetcher.update_workflows(repo)
    Dashy.Fetcher.update_workflow_runs(repo)
    Dashy.Fetcher.update_all_workflow_run_jobs(repo)
  end
  def delete_data do
    Repo.delete_all(Repository)
  end

end

Dashy.DevSeeder.delete_data()
Dashy.DevSeeder.create_repo()
