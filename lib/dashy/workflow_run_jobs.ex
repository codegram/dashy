defmodule Dashy.WorkflowRunJobs do
  alias Dashy.Repo
  alias Dashy.WorkflowRunJobs.WorkflowRunJob

  def get_by_external_id(id), do: Repo.get_by(WorkflowRunJob, external_id: id)

  def create_or_update(attrs) do
    case get_by_external_id(attrs.external_id) do
      nil -> %WorkflowRunJob{}
      workflow_run_job -> workflow_run_job
    end
    |> WorkflowRunJob.changeset(attrs)
    |> Repo.insert_or_update()
  end
end
