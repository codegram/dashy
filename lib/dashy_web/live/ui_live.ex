defmodule DashyWeb.UILive do
  use Surface.LiveView

  alias DashyWeb.Components.Card
  alias DashyWeb.Components.CardContent
  alias DashyWeb.Components.CardTitle

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl p-4 mx-auto">
      <h1>Components</h1>
      <h2>Card</h2>
      <Card>
        <CardTitle title="Title" subtitle="Subtitle" />
        <CardContent>
          <h2>Card content</h2>
        </CardContent>
      </Card>
    </div>
    """
  end
end
