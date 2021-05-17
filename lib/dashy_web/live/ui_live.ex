defmodule DashyWeb.UILive do
  use Surface.LiveView

  alias DashyWeb.Components.Card
  alias DashyWeb.Components.CardContent
  alias DashyWeb.Components.CardTitle

  alias DashyWeb.Components.Button

  alias DashyWeb.Components.Charts.LastRuns
  alias DashyWeb.Components.Charts.Parts
  alias Dashy.Charts.Helpers

  @impl true
  def mount(_params, _session, socket) do
    Process.send_after(self(), :load_runs, 1000)
    Process.send_after(self(), :load_parts, 1000)
    {:ok, socket |> assign(uses_fake_data: true, parts: [], colors: [])}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl p-4 mx-auto">
      <h1>Components</h1>
      <div class="mt-6">
        <h2>Buttons</h2>
        <div>
          <Button click="update-runs" value="1">Primary Button</Button>
          <Button click="update-parts" value="1" color="warning">Warning Button</Button>
          <Button click="button-event" value="1" color="alert">Alert Button</Button>
        </div>
        <div class="mt-4">
          <Button click="toggle-source" background="secondary">Primary Button (toggle source)</Button>
          <Button click="button-event" value="1" color="warning" background="secondary">Warning Button</Button>
          <Button click="button-event" value="1" color="alert" background="secondary">Alert Button</Button>
        </div>
      </div>
      <div>
        <LastRuns title="Last Runs" />
      </div>
      <div>
        <div class="grid grid-cols-12 gap-4">
          <div class="col-span-9">
            <Parts title="Parts" list="parts_list" />
          </div>
          <div class="col-span-3">
            <ul class="h-96 overflow-scroll" id="parts_list">
              <li class="part_name" data-slug="{{part}}" style="color: {{Helpers.build_style_color(@colors |> Enum.at(index))}}" :for={{ {part, index} <- @parts |> Enum.with_index()}}>{{part}}</li>
            </ul>
          </div>
        </div>
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
    </div>
    """
  end

  @impl true
  def handle_event("button-event", %{"val" => val}, socket) do
    require Logger
    Logger.debug(val)
    {:noreply, socket}
  end

  def handle_event("toggle-source", _, socket) do
    uses_fake_data = socket.assigns.uses_fake_data

    with socket <- assign(socket, uses_fake_data: !uses_fake_data),
         {:noreply, socket} <- handle_event("update-runs", %{}, socket),
         {:noreply, socket} <- handle_event("update-parts", %{}, socket) do
      {:noreply, socket}
    else
      _ -> {:noreply, socket}
    end
  end

  def handle_event("update-runs", _, socket) do
    runs = get_runs_module(socket).runs()
    {:noreply, socket |> push_event("load-runs", %{data: runs})}
  end

  def handle_event("update-parts", _, socket) do
    %{parts: parts, data: data, colors: colors} = get_parts_module(socket).parts

    {:noreply,
     socket |> assign(parts: parts, colors: colors) |> push_event("load-parts", %{data: data})}
  end

  @impl true
  def handle_info(:load_runs, socket) do
    runs = get_runs_module(socket).runs()
    {:noreply, socket |> push_event("load-runs", %{data: runs})}
  end

  @impl true
  def handle_info(:load_parts, socket) do
    %{parts: parts, data: data, colors: colors} = get_parts_module(socket).parts

    {:noreply,
     socket |> assign(parts: parts, colors: colors) |> push_event("load-parts", %{data: data})}
  end

  defp get_runs_module(%{assigns: %{uses_fake_data: true}} = _socket),
    do: Dashy.Charts.WorkflowRunsFake

  defp get_runs_module(%{assigns: %{uses_fake_data: false}} = _socket),
    do: Dashy.Charts.WorkflowRuns

  defp get_parts_module(%{assigns: %{uses_fake_data: true}} = _socket),
    do: Dashy.Charts.WorkflowPartsFake

  defp get_parts_module(%{assigns: %{uses_fake_data: false}} = _socket),
    do: Dashy.Charts.WorkflowPartsFake
end
