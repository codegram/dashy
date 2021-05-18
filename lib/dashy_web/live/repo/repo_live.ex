defmodule DashyWeb.RepoLive do
  use Surface.LiveView

  alias DashyWeb.Components.Layout
  alias DashyWeb.Components.Card
  alias DashyWeb.Components.CardContent
  alias DashyWeb.Components.CardTitle
  alias DashyWeb.Components.Charts.LastRuns
  alias DashyWeb.Components.Charts.Parts

  alias Dashy.Charts.Helpers

  @impl true
  def mount(%{"name" => name, "user" => user}, _session, socket) do
    Process.send_after(self(), :load_runs, 1000)
    Process.send_after(self(), :load_parts, 1000)
    parts = []
    colors = []
    repo = Dashy.Repositories.get_repository_by_user_and_name(user, name)

    {:ok, socket |> assign(repo: repo, parts: parts, colors: colors, uses_fake_data: false)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout id="header">
      <div class="max-w-6xl p-4 mx-auto">
        <h1>Repo: {{@repo.user}} / {{@repo.name}}</h1>
        <Card>
          <CardTitle title="Last runs" subtitle="The last runs of the tests suite for this repository." />
          <CardContent>
            <div>
              <LastRuns />
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardTitle title="Workflows" subtitle="The running time for each workflow of this tests suite." />
          <CardContent>
            <div class="grid grid-cols-12 gap-4">
              <div class="col-span-9">
                <Parts list="parts_list"/>
              </div>
              <div class="col-span-3">
                <ul class="h-96 overflow-auto" id="parts_list">
                  <li class="part_name" data-slug="{{part}}" style="color: {{Helpers.build_style_color(@colors |> Enum.at(index))}}" :for={{ {part, index} <- @parts |> Enum.with_index()}}>{{part}}</li>
                </ul>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </Layout>
    """
  end

  @impl true
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
    runs = get_runs_module(socket).runs(socket.assigns.repo)
    {:noreply, socket |> push_event("load-runs", %{data: runs})}
  end

  @impl true
  def handle_info(:load_parts, socket) do
    %{parts: parts, data: data, colors: colors} =
      get_parts_module(socket).parts(socket.assigns.repo)

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
    do: Dashy.Charts.WorkflowParts
end
