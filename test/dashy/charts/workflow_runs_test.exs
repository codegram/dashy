defmodule Dashy.Charts.WorkflowRunsTest do
  use Dashy.DataCase

  describe "runs/1" do
    test "lists all runs" do
      sha = "1"
      repo = insert(:repository)
      workflow = insert(:workflow, repository: repo)

      insert(:workflow_run,
        head_sha: sha,
        created_at: ~U[2021-05-16 09:00:00Z],
        started_at: ~U[2021-05-16 09:00:00Z],
        completed_at: ~U[2021-05-16 10:00:00Z],
        status: "completed",
        conclusion: "success",
        workflow: workflow
      )

      insert(:workflow_run,
        head_sha: sha,
        created_at: ~U[2021-05-16 09:00:00Z],
        started_at: ~U[2021-05-16 09:00:00Z],
        completed_at: ~U[2021-05-16 11:00:00Z],
        status: "completed",
        conclusion: "success",
        workflow: workflow
      )

      assert [%Dashy.Charts.Run{} = fetched_run] = Dashy.Charts.WorkflowRuns.runs(repo)

      # 2 hours
      assert fetched_run.minutes == 120
      assert fetched_run.seconds == 7200
      assert fetched_run.time == ~U[2021-05-16 09:00:00Z]
      assert fetched_run.status == "success"
      assert fetched_run.link == "https://github.com/#{repo.user}/#{repo.name}/commit/#{sha}"
    end

    test "handles the state correctly" do
      sha = "1"

      repo = insert(:repository)
      workflow = insert(:workflow, repository: repo)

      insert(:workflow_run,
        head_sha: sha,
        created_at: ~U[2021-05-16 09:00:00Z],
        started_at: ~U[2021-05-16 09:00:00Z],
        completed_at: ~U[2021-05-16 10:00:00Z],
        status: "completed",
        conclusion: "success",
        workflow: workflow
      )

      insert(:workflow_run,
        head_sha: sha,
        created_at: ~U[2021-05-16 09:00:00Z],
        started_at: ~U[2021-05-16 09:00:00Z],
        completed_at: ~U[2021-05-16 11:00:00Z],
        status: "completed",
        conclusion: "failure",
        workflow: workflow
      )

      assert [%Dashy.Charts.Run{} = fetched_run] = Dashy.Charts.WorkflowRuns.runs(repo)

      assert fetched_run.status == "error"
    end
  end
end
