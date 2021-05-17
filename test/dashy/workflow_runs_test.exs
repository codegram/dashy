defmodule Dashy.WorkflowRunsTest do
  use Dashy.DataCase

  alias Dashy.WorkflowRuns

  describe "get_by_external_id/1" do
    test "finds the workflow_run" do
      workflow_run = insert(:workflow_run)

      assert workflow_run.id == WorkflowRuns.get_by_external_id(workflow_run.external_id).id
    end
  end

  describe "create_or_update/1" do
    test "creates a workflow_run" do
      workflow = insert(:workflow)
      attrs = params_for(:workflow_run) |> Map.merge(%{workflow_id: workflow.external_id})

      assert {:ok, _workflow_run} = WorkflowRuns.create_or_update(attrs)
    end

    test "updates the record when external_id is existing in the DB" do
      workflow_run = insert(:workflow_run, status: "active")

      attrs =
        params_for(:workflow_run)
        |> Map.merge(%{external_id: workflow_run.external_id, status: "cancelled"})

      assert {:ok, workflow_run} = WorkflowRuns.create_or_update(attrs)
      assert workflow_run.status == "cancelled"
    end
  end
end
