defmodule DashyWeb.UILive do
  use Surface.LiveView

  alias DashyWeb.Components.Card
  alias DashyWeb.Components.CardContent
  alias DashyWeb.Components.CardTitle

  alias DashyWeb.Components.Button

  alias DashyWeb.Components.Charts.LastRuns

  @impl true
  def mount(_params, _session, socket) do
    Process.send_after(self(), :load, 1000)
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl p-4 mx-auto">
      <h1>Components</h1>
      <div>
        <LastRuns title="Last Runs" />
      </div>
      <div class="mt-6">
        <h2>Card</h2>
        <Card>
          <CardTitle title="Title" subtitle="Subtitle" />
          <CardContent>
            <h2>Card content</h2>
          </CardContent>
        </Card>
      </div>
      <div class="mt-6">
        <h2>Buttons</h2>
        <div>
          <Button click="update-chart" value="1">Primary Button</Button>
          <Button click="button-event" value="1" color="warning">Warning Button</Button>
          <Button click="button-event" value="1" color="alert">Alert Button</Button>
        </div>
        <div class="mt-4">
          <Button click="button-event" value="1" background="secondary">Primary Button</Button>
          <Button click="button-event" value="1" color="warning" background="secondary">Warning Button</Button>
          <Button click="button-event" value="1" color="alert" background="secondary">Alert Button</Button>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("button-event", %{"val" => val}, socket) do
    require Logger
    Logger.debug(val)
    {:noreply, socket}
  end

  def handle_event("update-chart", _, socket) do
    data = build_labels(fake_data(DateTime.now!("Etc/UTC"), [], 50))
    {:noreply, socket |> push_event("load", %{data: data})}
  end

  @impl true
  def handle_info(:load, socket) do
    data = build_labels(fake_data(DateTime.now!("Etc/UTC"), [], 50))
    {:noreply, socket |> push_event("load", %{data: data})}
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

  defp fake_data(_last_run_date, data, 0), do: data

  defp fake_data(last_run_date, data, n) do
    time = DateTime.add(last_run_date, -:rand.uniform(1_000_000), :second)
    seconds = :rand.normal(180, 30) |> Float.round()

    run = %{
      time: time,
      seconds: seconds,
      minutes: seconds / 60,
      link: "https://github.com/decidim/decidim/commit/d3b88afe90e5643848e94ef13ee1e850bbc01e2d",
      status: set_status()
    }

    fake_data(time, [run | data], n - 1)
  end

  defp set_status() do
    case :rand.uniform(100) do
      x when x < 20.0 -> "cancelled"
      x when x < 50.0 -> "error"
      _ -> "success"
    end
  end
end
