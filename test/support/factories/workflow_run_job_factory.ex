defmodule Dashy.WorkflowRunJobFactory do
  @moduledoc """
    This module contains the workflow run job factories.
  """

  use ExMachina.Ecto, repo: Dashy.Repo

  defmacro __using__(_opts) do
    quote do
      def workflow_run_job_factory do
        %Dashy.WorkflowRunJobs.WorkflowRunJob{
          workflow_run_id: insert(:workflow_run).external_id,
          name: "My workflow run job",
          conclusion: "completed",
          status: "completed",
          node_id: sequence(:node_id, &"node-id-#{&1}"),
          external_id: sequence(:workflow_run_job_external_id, fn id -> id end),
          started_at: DateTime.utc_now(),
          completed_at: DateTime.utc_now(),
          head_sha: "i8twygrheiugnyeourytenvor8oyy",
          metadata: %{"foo" => 1}
        }
      end
    end
  end
end
