defmodule Dashy.WorkflowsTest do
  use Dashy.DataCase

  alias Dashy.Workflows

  describe "get_by_external_id/1" do
    test "finds the workflow" do
      workflow = insert(:workflow)

      assert workflow == Workflows.get_by_external_id(workflow.external_id)
    end
  end

  describe "create_or_update/1" do
    test "creates a workflow" do
      attrs = params_for(:workflow)

      assert {:ok, _workflow} = Workflows.create_or_update(attrs)
    end

    test "updates the record when external_id is existing in the DB" do
      workflow = insert(:workflow, state: "active")

      attrs =
        params_for(:workflow)
        |> Map.merge(%{external_id: workflow.external_id, state: "cancelled"})

      assert {:ok, workflow} = Workflows.create_or_update(attrs)
      assert workflow.state == "cancelled"
    end
  end
end
