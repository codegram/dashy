defmodule Dashy.WorkflowFactory do
  @moduledoc """
    This module contains the workflow factories.
  """

  use ExMachina.Ecto, repo: Dashy.Repo

  defmacro __using__(_opts) do
    quote do
      def workflow_factory do
        %Dashy.Workflows.Workflow{
          name: "My workflow",
          path: ".github/workflows/my_workflow.yml",
          state: "active",
          node_id: sequence(:node_id, &"node-id-#{&1}"),
          external_id: sequence(:workflow_external_id, fn id -> id end)
        }
      end
    end
  end
end
