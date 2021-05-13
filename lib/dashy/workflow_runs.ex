defmodule Dashy.WorkflowRuns do
  alias Dashy.Repo
  alias Dashy.WorkflowRuns.WorkflowRun

  def get_by_external_id(id), do: Repo.get_by(WorkflowRun, external_id: id)

  def create_or_update(attrs) do
    case get_by_external_id(attrs.external_id) do
      nil -> %WorkflowRun{}
      workflow -> workflow
    end
    |> WorkflowRun.changeset(attrs)
    |> Repo.insert_or_update()
  end
end
