defmodule Dashy.WorkflowRunFactory do
  @moduledoc """
    This module contains the workflow run factories.
  """

  use ExMachina.Ecto, repo: Dashy.Repo

  defmacro __using__(_opts) do
    quote do
      def workflow_run_factory do
        %Dashy.WorkflowRuns.WorkflowRun{
          workflow: build(:workflow),
          name: "My workflow run",
          conclusion: "completed",
          status: "completed",
          node_id: sequence(:node_id, &"node-id-#{&1}"),
          external_id: sequence(:workflow_run_external_id, fn id -> id end),
          head_sha: "2345678sdf5678dfs67543dsfgdrs",
          metadata: %{"foo" => 1}
        }
      end

      def workflow_run_with_workflow_id_factory do
        %Dashy.WorkflowRuns.WorkflowRun{
          workflow_id: insert(:workflow).external_id,
          name: "My workflow run",
          conclusion: "completed",
          status: "completed",
          node_id: sequence(:node_id, &"node-id-#{&1}"),
          external_id: sequence(:workflow_run_external_id, fn id -> id end),
          head_sha: "2345678sdf5678dfs67543dsfgdrs",
          metadata: %{"foo" => 1}
        }
      end
    end
  end
end
