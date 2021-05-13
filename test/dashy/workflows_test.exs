defmodule Dashy.WorkflowsTest do
  use Dashy.DataCase

  alias Dashy.Workflows

  describe "get_by_external_id/1" do
    test "finds the workflow" do
      workflow = insert(:workflow)

      assert workflow == Workflows.get_by_external_id(workflow.external_id)
    end
  end

  describe "create/1" do
    test "creates a workflow" do
      attrs = params_for(:workflow)

      assert {:ok, _workflow} = Workflows.create(attrs)
    end

    test "fails when external_id is duplicated" do
      workflow = insert(:workflow)
      attrs = params_for(:workflow) |> Map.merge(%{external_id: workflow.external_id})

      assert {:error, changeset} = Workflows.create(attrs)
      assert errors_on(changeset).external_id == ["has already been taken"]
    end
  end
end
