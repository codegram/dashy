defmodule Dashy.Charts.WorkflowRunsTest do
  use Dashy.DataCase

  describe "runs/1" do
    test "lists all runs" do
      sha = "1"
      run = insert(:workflow_run, head_sha: sha, created_at: ~U[2021-05-16 09:00:00Z])
      run2 = insert(:workflow_run, head_sha: sha, created_at: ~U[2021-05-16 09:00:00Z])

      insert(:workflow_run_job,
        workflow_run: run,
        head_sha: sha,
        started_at: ~U[2021-05-16 09:00:00Z],
        completed_at: ~U[2021-05-16 10:00:00Z],
        status: "completed",
        conclusion: "success"
      )

      insert(:workflow_run_job,
        workflow_run: run2,
        head_sha: sha,
        started_at: ~U[2021-05-16 09:00:00Z],
        completed_at: ~U[2021-05-16 11:00:00Z],
        status: "completed",
        conclusion: "success"
      )

      assert [%Dashy.Charts.Run{} = fetched_run] = Dashy.Charts.WorkflowRuns.runs()

      # 2 hours
      assert fetched_run.minutes == 120
      assert fetched_run.seconds == 7200
      assert fetched_run.time == ~U[2021-05-16 09:00:00Z]
      assert fetched_run.status == "success"
      assert fetched_run.link == "https://github.com/decidim/decidim/commit/#{sha}"
    end

    test "handles the state correctly" do
      sha = "1"
      run = insert(:workflow_run, head_sha: sha, created_at: ~U[2021-05-16 09:00:00Z])
      run2 = insert(:workflow_run, head_sha: sha, created_at: ~U[2021-05-16 09:00:00Z])

      insert(:workflow_run_job,
        workflow_run: run,
        head_sha: sha,
        started_at: ~U[2021-05-16 09:00:00Z],
        completed_at: ~U[2021-05-16 10:00:00Z],
        status: "completed",
        conclusion: "success"
      )

      insert(:workflow_run_job,
        workflow_run: run2,
        head_sha: sha,
        started_at: ~U[2021-05-16 09:00:00Z],
        completed_at: ~U[2021-05-16 11:00:00Z],
        status: "completed",
        conclusion: "failure"
      )

      assert [%Dashy.Charts.Run{} = fetched_run] = Dashy.Charts.WorkflowRuns.runs()

      assert fetched_run.status == "error"
    end
  end
end
