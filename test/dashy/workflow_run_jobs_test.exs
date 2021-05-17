defmodule Dashy.WorkflowRunJobsTest do
  use Dashy.DataCase

  alias Dashy.WorkflowRunJobs

  describe "get_by_external_id/1" do
    test "finds the workflow_run_job" do
      workflow_run_job = insert(:workflow_run_job)

      assert workflow_run_job == WorkflowRunJobs.get_by_external_id(workflow_run_job.external_id)
    end
  end

  describe "create_or_update/1" do
    test "creates a workflow_run_job" do
      attrs = params_for(:workflow_run_job)

      assert {:ok, _workflow_run_job} = WorkflowRunJobs.create_or_update(attrs)
    end

    test "updates the record when external_id is existing in the DB" do
      workflow_run_job = insert(:workflow_run_job, status: "active")

      attrs =
        params_for(:workflow_run_job)
        |> Map.merge(%{external_id: workflow_run_job.external_id, status: "cancelled"})

      assert {:ok, workflow_run_job} = WorkflowRunJobs.create_or_update(attrs)
      assert workflow_run_job.status == "cancelled"
    end
  end
end
