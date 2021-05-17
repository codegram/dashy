defmodule DashyWeb.RepoLive do
  use Surface.LiveView

  alias DashyWeb.Components.Card
  alias DashyWeb.Components.CardContent
  alias DashyWeb.Components.CardTitle

  alias DashyWeb.Components.Button

  alias DashyWeb.Components.Charts.LastRuns
  alias DashyWeb.Components.Charts.Parts

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    Process.send_after(self(), :load_runs, 1000)
    Process.send_after(self(), :load_parts, 1000)
    parts = list_parts()
    colors = generate_colors(parts |> Enum.count())

    {:ok, socket |> assign(repo: id, parts: parts, colors: colors)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-6xl p-4 mx-auto">
      <h1>Repo: {{@repo}}</h1>
      <Card>
        <CardTitle title="Last runs" subtitle="Here you can see the last runs" />
        <CardContent>
          <div>
            <LastRuns />
          </div>
        </CardContent>
      </Card>
      <Card>
        <CardTitle title="Parts" subtitle="Here you can see the Parts" />
        <CardContent>
          <div class="grid grid-cols-12 gap-4">
            <div class="col-span-9">
              <Parts title="Parts" list="parts_list" />
            </div>
            <div class="col-span-3">
              <ul class="h-96 overflow-scroll" id="parts_list">
                <li class="part_name" data-slug="{{part}}" style="color: {{build_style_color(@colors |> Enum.at(index))}}" :for={{ {part, index} <- @parts |> Enum.with_index()}}>{{part}}</li>
              </ul>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
    """
  end

  @impl true
  def handle_event("update-runs", _, socket) do
    data = build_labels(fake_runs(DateTime.now!("Etc/UTC"), [], 50))
    {:noreply, socket |> push_event("load-runs", %{data: data})}
  end

  def handle_event("update-parts", _, socket) do
    data = build_labels(fake_parts(DateTime.now!("Etc/UTC"), [], 50))
    {:noreply, socket |> push_event("load-parts", %{data: data})}
  end

  @impl true
  def handle_info(:load_runs, socket) do
    data = build_labels(fake_runs(DateTime.now!("Etc/UTC"), [], 50))
    {:noreply, socket |> push_event("load-runs", %{data: data})}
  end

  @impl true
  def handle_info(:load_parts, socket) do
    data = fake_parts(DateTime.now!("Etc/UTC"), [], 15)
    {:noreply, socket |> push_event("load-parts", %{data: data})}
  end

  defp build_labels(data) do
    %{
      labels: data |> Enum.map(& &1.time),
      datasets: [
        %{
          data: data,
          borderRadius: 2
        }
      ]
    }
  end

  defp generate_colors(total) do
    0..total
    |> Enum.map(fn index ->
      %{
        h: "#{360 / total * index}",
        s: "#{50 + 25 * rem(index, 3)}%",
        l: "#{75 - 25 * rem(index, 3)}%"
      }
    end)
  end

  def build_style_color(%{h: h, s: s, l: l}, a \\ "100%") do
    "hsla(#{h}, #{s}, #{l}, #{a})"
  end

  defp fake_runs(_last_run_date, data, 0), do: data

  defp fake_runs(last_run_date, data, n) do
    time = DateTime.add(last_run_date, -:rand.uniform(1_000_000), :second)
    seconds = :rand.normal(180, 30) |> Float.round()

    run = %{
      time: time,
      seconds: seconds,
      minutes: seconds / 60,
      link: "https://github.com/decidim/decidim/commit/d3b88afe90e5643848e94ef13ee1e850bbc01e2d",
      status: set_status()
    }

    fake_runs(time, [run | data], n - 1)
  end

  defp set_status() do
    case :rand.uniform(100) do
      x when x < 10.0 -> "cancelled"
      x when x < 20.0 -> "error"
      _ -> "success"
    end
  end

  defp fake_parts(_last_run_date, times, 0) do
    parts = list_parts()
    fake_parts_data(times, parts, generate_colors(parts |> Enum.count()), [])
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
      color: build_style_color(color)
    }
  end

  defp list_parts do
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
