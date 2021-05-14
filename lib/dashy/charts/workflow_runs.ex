defmodule Dashy.Charts.WorkflowRuns do
  alias Dashy.Charts.Run
  alias Dashy.WorkflowRuns.WorkflowRun

  alias Dashy.Repo
  import Ecto.Query

  def runs(_opts \\ []) do
    from(
      r in WorkflowRun,
      select: %{head_sha: r.head_sha, start: min(r.created_at), end: max(r.updated_at)},
      group_by: r.head_sha,
      order_by: min(r.created_at)
    )
    |> Repo.all()
    |> Enum.map(fn data ->
      seconds = DateTime.diff(data.end, data.start)

      %Run{
        time: data.start,
        seconds: seconds,
        minutes: seconds / 60,
        link: link_from(data),
        status: "success"
      }
    end)
  end

  defp link_from(%{head_sha: sha}),
    do: "https://github.com/decidim/decidim/commit/#{sha}"
end
