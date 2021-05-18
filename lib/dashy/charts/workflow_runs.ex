defmodule Dashy.Charts.WorkflowRuns do
  alias Dashy.Charts.Run
  alias Dashy.WorkflowRuns.WorkflowRun

  alias Dashy.Repo
  import Ecto.Query

  def runs(_opts \\ []) do
    from(
      r in WorkflowRun,
      select: %{
        started_at: min(r.started_at),
        completed_at: max(r.completed_at),
        conclusion: fragment("array_agg(?)", r.conclusion),
        head_sha: r.head_sha
      },
      where: not is_nil(r.started_at),
      where: not is_nil(r.completed_at),
      group_by: r.head_sha,
      order_by: min(r.started_at)
    )
    |> Repo.all()
    |> Enum.map(fn data ->
      seconds = DateTime.diff(data.completed_at, data.started_at)

      %Run{
        time: data.started_at,
        seconds: seconds,
        minutes: seconds / 60,
        link: link_from(data),
        status: status_from(data.conclusion)
      }
    end)
  end

  defp link_from(%{head_sha: sha}),
    do: "https://github.com/decidim/decidim/commit/#{sha}"

  defp status_from(list) do
    cond do
      Enum.any?(list, fn e -> e == nil || e == "pending" end) ->
        "pending"

      Enum.any?(list, fn e -> e == "failure" end) ->
        "error"

      Enum.any?(list, fn e -> e == "cancelled" end) ->
        "cancelled"

      (list |> Enum.uniq()) -- ["skipped", "success"] == [] ->
        "success"

      true ->
        "other"
    end
  end
end
