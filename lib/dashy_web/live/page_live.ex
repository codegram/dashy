defmodule DashyWeb.PageLive do
  use Surface.LiveView

  alias DashyWeb.Router.Helpers, as: Routes

  alias Dashy.Repositories

  alias DashyWeb.Components.Layout
  alias DashyWeb.Components.Card
  alias DashyWeb.Components.CardContent
  alias DashyWeb.Components.CardTitle

  @impl true
  def mount(_params, _session, socket) do
    repos = Repositories.list_repositories() |> Enum.take(10)
    {:ok, assign(socket, repos: repos)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <Layout id="header">
      <div class="max-w-6xl p-4 mx-auto">
        <Card>
          <CardTitle title="Repos" subtitle="Here you can see some awesome repos" />
          <CardContent>
            <ul>
              <li :for={{ repo <- @repos }} class="mb-4">
                <a href="{{Routes.repo_path(@socket, :index, repo.user, repo.name)}}">
                  <span class="inline-block bg-gray-300-500 rounded">{{repo.user}}/{{repo.name}}</span>
                  <span class="text-blue-500 bg-blue-200 inline-block px-2 rounded-md text-sm">{{repo.branch}}</span>
                </a>
              </li>
            </ul>
          </CardContent>
        </Card>
      </div>
    </Layout>
    """
  end
end
