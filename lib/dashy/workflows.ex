defmodule Dashy.Workflows do
  alias Dashy.Repo
  alias Dashy.Workflows.Workflow

  def get_by_external_id(id), do: Repo.get_by(Workflow, external_id: id)

  def create(attrs) do
    %Workflow{}
    |> Workflow.changeset(attrs)
    |> Repo.insert()
  end
end
