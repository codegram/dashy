defmodule Dashy.Workflows do
  alias Dashy.Repo
  alias Dashy.Workflows.Workflow

  def get_by_external_id(id), do: Repo.get_by(Workflow, external_id: id)

  def create_or_update(attrs) do
    case get_by_external_id(attrs.external_id) do
      nil -> %Workflow{}
      workflow -> workflow
    end
    |> Workflow.changeset(attrs)
    |> Repo.insert_or_update()
  end
end
