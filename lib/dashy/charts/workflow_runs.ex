defmodule Dashy.Charts.WorkflowRuns do
  alias Dashy.Charts.Run
  alias Dashy.WorkflowRuns.WorkflowRun
  alias Dashy.WorkflowRunJobs.WorkflowRunJob

  alias Dashy.Repo
  import Ecto.Query

  def runs(_opts \\ []) do
    from(
      r in WorkflowRun,
      select: %{head_sha: r.head_sha},
      group_by: r.head_sha,
      order_by: min(r.created_at)
    )
    |> Repo.all()
    |> fetch_times()
    |> Enum.map(fn data ->
      seconds = DateTime.diff(data.end, data.start)

      %Run{
        time: data.start,
        seconds: seconds,
        minutes: seconds / 60,
        link: link_from(data),
        status: data.status
      }
    end)
  end

  defp link_from(%{head_sha: sha}),
    do: "https://github.com/decidim/decidim/commit/#{sha}"

  defp fetch_times(runs) do
    jobs =
      from(
        j in WorkflowRunJob,
        where: j.head_sha in ^head_shas(runs),
        select: %{
          head_sha: j.head_sha,
          start: min(j.started_at),
          end: max(j.completed_at),
          conclusion: fragment("array_agg(?)", j.conclusion)
        },
        group_by: j.head_sha,
        order_by: min(j.started_at)
      )
      |> Repo.all()

    runs
    |> Enum.map(fn run ->
      job = jobs |> Enum.find(fn job -> job.head_sha == run.head_sha end)

      run
      |> Map.merge(%{start: job.start, end: job.end, status: status_from(job.conclusion)})
    end)
  end

  defp head_shas(list) do
    list
    |> Enum.map(fn element -> Map.get(element, :head_sha) end)
    |> Enum.uniq()
  end

  defp status_from(list) do
    cond do
      Enum.any?(list, fn e -> e == "pending" end) ->
        "pending"

      Enum.any?(list, fn e -> e == "failure" end) ->
        "error"

      Enum.any?(list, fn e -> e == "cancelled" end) ->
        "cancelled"

      list |> Enum.uniq() == ["success"] ->
        "success"

      true ->
        "pending"
    end
  end
end
