defmodule Dashy.WorkflowRuns do
  alias Dashy.Repo
  alias Dashy.WorkflowRuns.WorkflowRun
  alias Dashy.WorkflowRunJobs.WorkflowRunJob

  import Ecto.Query

  def get_by_external_id(id), do: Repo.get_by(WorkflowRun, external_id: id)

  def create_or_update(attrs) do
    case get_by_external_id(attrs.external_id) do
      nil -> %WorkflowRun{}
      workflow_run -> workflow_run
    end
    |> WorkflowRun.changeset(attrs)
    |> Repo.insert_or_update()
  end

  def update_from_jobs(external_id) do
    attrs =
      from(
        j in WorkflowRunJob,
        select: %{
          started_at: min(j.started_at),
          completed_at: max(j.completed_at)
        },
        where: j.workflow_run_id == ^external_id,
        group_by: j.workflow_run_id
      )
      |> Repo.one()

    get_by_external_id(external_id)
    |> WorkflowRun.changeset(attrs)
    |> Repo.update()
  end
end
