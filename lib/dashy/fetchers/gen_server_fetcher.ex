defmodule Dashy.Fetchers.GenServerFetcher do
  use GenServer

  alias Dashy.Fetcher

  def start_link(options) do
    GenServer.start_link(__MODULE__, %{}, options)
  end

  def fetch(pid, repo) do
    GenServer.cast(pid, {:fetch, repo})
  end

  @impl true
  def init(_) do
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:fetch, repo}, _) do
    Fetcher.update_workflows(repo)
    Fetcher.update_workflow_runs(repo)
    Fetcher.update_all_workflow_run_jobs(repo)
    {:noreply, repo}
  end
end
