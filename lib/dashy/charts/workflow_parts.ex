defmodule Dashy.Charts.WorkflowParts do
  alias Dashy.Charts.Part
  alias Dashy.WorkflowRuns.WorkflowRun

  alias Dashy.Repo
  import Ecto.Query

  alias Dashy.Charts.Helpers

  def parts(opts \\ []) do
    last = Repo.one(from r in WorkflowRun, order_by: [desc: r.created_at], limit: 1)

    days = Keyword.get(opts, :days, 30)
    minimum_start_time = last.created_at |> DateTime.add(-days * 60 * 60 * 24, :second)

    grouped_runs =
      from(
        r in WorkflowRun,
        select: %{
          name: r.name,
          started_at: r.started_at,
          completed_at: r.completed_at,
          external_id: r.external_id
        },
        where: r.created_at > ^minimum_start_time,
        order_by: [r.workflow_id, r.created_at]
      )
      |> Repo.all()
      |> Enum.group_by(fn data -> data.name end)
      |> Enum.to_list()
      |> Enum.sort_by(fn {_, runs} ->
        recent = runs |> List.last()
        -DateTime.diff(recent.completed_at, recent.started_at)
      end)

    parts =
      grouped_runs
      |> Enum.map(fn {name, _} -> name end)

    colors = Helpers.generate_colors(parts |> Enum.count())

    %{data: build_data(grouped_runs, colors), colors: colors, parts: parts}
  end

  def build_data([], []), do: []

  def build_data([{part_name, run} | grouped_runs], [color | colors]) do
    [
      %{
        label: part_name,
        color: Helpers.build_style_color(color),
        data:
          run
          |> Enum.map(fn run ->
            seconds = DateTime.diff(run.completed_at, run.started_at)

            %Part{
              name: part_name,
              time: run.started_at,
              seconds: seconds,
              minutes: seconds / 60,
              link: link_from(run)
            }
          end)
      }
      | build_data(grouped_runs, colors)
    ]
  end

  defp link_from(%{external_id: id}),
    do: "https://github.com/decidim/decidim/actions/runs/#{id}"
end
