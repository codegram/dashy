defmodule Dashy.Charts.WorkflowPartsFake do
  alias Dashy.Charts.Helpers

  def parts(opts \\ []) do
    count = Keyword.get(opts, :count, 50)
    fake_parts(DateTime.now!("Etc/UTC"), [], count)
  end

  defp fake_parts(_last_run_date, times, 0) do
    parts = list_parts()
    colors = Helpers.generate_colors(parts |> Enum.count())
    %{data: fake_parts_data(times, parts, colors, []), colors: colors, parts: parts}
  end

  defp fake_parts(last_run_date, data, n) do
    time = DateTime.add(last_run_date, -:rand.uniform(12 * 60 * 60), :second)

    fake_parts(time, [time | data], n - 1)
  end

  defp fake_parts_data(_times, [], _colors, data), do: data

  defp fake_parts_data(times, [part | parts], [color | colors], data) do
    initial = %{
      seconds: :rand.normal(120, 30) |> Float.round(),
      data: []
    }

    %{data: part_data} =
      times
      |> Enum.reduce(initial, fn time, acc ->
        seconds = acc.seconds + :rand.normal(0, 5)
        part_time = DateTime.add(time, :rand.uniform(60), :second)

        %{
          seconds: seconds,
          data: [
            %{
              name: part,
              time: part_time,
              seconds: seconds,
              minutes: seconds / 60,
              link: 'https://github.com/decidim/decidim/actions/runs/834489205'
            }
            | acc.data
          ]
        }
      end)

    part_data = build_part(part, part_data, color)

    fake_parts_data(times, parts, colors, [part_data | data])
  end

  def build_part(part, part_data, color) do
    %{
      label: part,
      data: part_data,
      color: Helpers.build_style_color(color)
    }
  end

  def list_parts do
    [
      "[CI] Accountability",
      "[CI] Admin",
      "[CI] Api",
      "[CI] Assemblies",
      "[CI] Blogs",
      "[CI] Budgets",
      "[CI] Comments",
      "[CI] Conferences",
      "[CI] Consultations",
      "[CI] Core",
      "[CI] Core (system specs)",
      "[CI] Core (unit tests)",
      "[CI] Debates",
      "[CI] Dev (system specs)",
      "[CI] Elections",
      "[CI] Elections (system admin)",
      "[CI] Elections (system public)",
      "[CI] Elections (unit tests)",
      "[CI] Forms",
      "[CI] Generators",
      "[CI] Initiatives",
      "[CI] Lint",
      "[CI] Main folder",
      "[CI] Meetings",
      "[CI] Meetings (system admin)",
      "[CI] Meetings (system public)",
      "[CI] Meetings (unit tests)",
      "[CI] Pages",
      "[CI] Participatory processes",
      "[CI] Proposals (system admin)",
      "[CI] Proposals (system public 1)",
      "[CI] Proposals (system public)",
      "[CI] Proposals (system public2)",
      "[CI] Proposals (unit tests)",
      "[CI] Security",
      "[CI] Sortitions",
      "[CI] Surveys",
      "[CI] System",
      "[CI] Templates",
      "[CI] Test",
      "[CI] Verifications"
    ]
  end
end
