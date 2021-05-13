defmodule Dashy.WorkflowRunFactory do
  @moduledoc """
    This module contains the workflow run factories.
  """

  use ExMachina.Ecto, repo: Dashy.Repo

  defmacro __using__(_opts) do
    quote do
      def workflow_run_factory do
        %Dashy.WorkflowRuns.WorkflowRun{
          workflow_id: insert(:workflow).external_id,
          name: "My workflow run",
          conclusion: "completed",
          status: "completed",
          node_id: sequence(:node_id, &"node-id-#{&1}"),
          external_id: sequence(:workflow_external_id, fn id -> id end)
        }
      end
    end
  end
end
