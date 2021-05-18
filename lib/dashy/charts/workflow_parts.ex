defmodule Dashy.Charts.WorkflowParts do
  alias Dashy.Charts.Part
  alias Dashy.WorkflowRuns.WorkflowRun
  alias Dashy.WorkflowRunJobs.WorkflowRunJob

  alias Dashy.Repo
  import Ecto.Query

  alias Dashy.Charts.Helpers

  def parts(opts \\ []) do
    last = Repo.one(from r in WorkflowRun, order_by: [desc: r.created_at], limit: 1)

    days = Keyword.get(opts, :days, 30)
    minimum_start_time = last.created_at |> DateTime.add(-days * 60 * 60 * 24, :second)

    grouped_run_jobs =
      from(
        j in WorkflowRunJob,
        join: r in WorkflowRun,
        on: r.external_id == j.workflow_run_id,
        select: %{
          name: fragment("array_agg(?)", r.name),
          started_at: min(j.started_at),
          completed_at: max(j.completed_at),
          external_id: r.external_id
        },
        group_by: r.external_id,
        where: r.created_at > ^minimum_start_time,
        order_by: [min(r.workflow_id), min(r.created_at)]
      )
      |> Repo.all()
      |> Enum.group_by(fn data -> data.name end)
      |> Enum.to_list()
      |> Enum.sort_by(fn {_, run_jobs} ->
        recent = run_jobs |> List.last()
        -DateTime.diff(recent.completed_at, recent.started_at)
      end)

    parts =
      grouped_run_jobs
      |> Enum.map(fn {name, _} -> List.last(name) end)

    colors = Helpers.generate_colors(parts |> Enum.count())

    %{data: build_data(grouped_run_jobs, colors), colors: colors, parts: parts}
  end

  def build_data([], []), do: []

  def build_data([{part_name, run_jobs} | grouped_run_jobs], [color | colors]) do
    [
      %{
        label: part_name,
        color: Helpers.build_style_color(color),
        data:
          run_jobs
          |> Enum.map(fn run_job ->
            seconds = DateTime.diff(run_job.completed_at, run_job.started_at)

            %Part{
              name: part_name,
              time: run_job.started_at,
              seconds: seconds,
              minutes: seconds / 60,
              link: link_from(run_job)
            }
          end)
      }
      | build_data(grouped_run_jobs, colors)
    ]
  end

  defp link_from(%{external_id: id}),
    do: "https://github.com/decidim/decidim/actions/runs/#{id}"
end
