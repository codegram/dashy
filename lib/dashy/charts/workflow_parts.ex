defmodule Dashy.Charts.WorkflowParts do
  alias Dashy.Charts.Part
  alias Dashy.Workflows.Workflow
  alias Dashy.WorkflowRuns.WorkflowRun

  alias Dashy.Repo
  import Ecto.Query

  alias Dashy.Charts.Helpers

  def parts(repo, opts \\ []) do
    last =
      from(
        r in WorkflowRun,
        join: w in Workflow,
        on: r.workflow_id == w.external_id,
        where: w.repository_id == ^repo.id,
        order_by: [desc: r.created_at],
        limit: 1
      )
      |> Repo.one()

    days = Keyword.get(opts, :days, 30)
    minimum_start_time = last.created_at |> DateTime.add(-days * 60 * 60 * 24, :second)

    grouped_runs =
      from(
        r in WorkflowRun,
        join: w in Workflow,
        on: r.workflow_id == w.external_id,
        select: %{
          name: r.name,
          started_at: r.started_at,
          completed_at: r.completed_at,
          external_id: r.external_id
        },
        where: not is_nil(r.started_at),
        where: not is_nil(r.completed_at),
        where: w.repository_id == ^repo.id,
        where: r.created_at > ^minimum_start_time,
        order_by: [r.workflow_id, r.created_at]
      )
      |> Repo.all()
      |> Enum.group_by(fn data -> data.name end)
      |> Enum.to_list()
      |> Enum.sort_by(fn {_, runs} ->
        recent = runs |> List.last()
        -calculate_seconds(recent.completed_at, recent.started_at)
      end)

    parts =
      grouped_runs
      |> Enum.map(fn {name, _} -> name end)

    colors = Helpers.generate_colors(parts |> Enum.count())

    %{data: build_data(grouped_runs, colors, repo), colors: colors, parts: parts}
  end

  def build_data([], [], _repo), do: []

  def build_data([{part_name, runs} | grouped_runs], [color | colors], repo) do
    [
      %{
        label: part_name,
        color: Helpers.build_style_color(color),
        data:
          runs
          |> Enum.map(fn run ->
            seconds = calculate_seconds(run.completed_at, run.started_at)

            %Part{
              name: part_name,
              time: run.started_at,
              seconds: seconds,
              minutes: seconds / 60,
              link: link_for(repo, run)
            }
          end)
      }
      | build_data(grouped_runs, colors, repo)
    ]
  end

  defp calculate_seconds(nil, _), do: 0
  defp calculate_seconds(_, nil), do: 0
  defp calculate_seconds(a, b), do: DateTime.diff(a, b)

  defp link_for(%{user: user, name: name}, %{external_id: id}),
    do: "https://github.com/#{user}/#{name}/actions/runs/#{id}"
end
