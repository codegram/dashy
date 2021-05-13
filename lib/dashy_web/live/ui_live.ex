defmodule DashyWeb.UILive do
  use Surface.LiveView

  alias DashyWeb.Components.Card
  alias DashyWeb.Components.CardContent
  alias DashyWeb.Components.CardTitle

  alias DashyWeb.Components.Button

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="max-w-4xl p-4 mx-auto">
      <h1>Components</h1>
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
          <Button click="button-event" value="1">Primary Button</Button>
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
end
