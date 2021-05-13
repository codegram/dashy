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
          <Button text="Primary Button" click="button-event" value="1" />
          <Button text="Warning Button" click="button-event" value="1" color="warning" />
          <Button text="Alert Button" click="button-event" value="1" color="alert" />
        </div>
        <div class="mt-4">
          <Button text="Primary Button" click="button-event" value="1" class="secondary" />
          <Button text="Warning Button" click="button-event" value="1" color="warning" class="secondary" />
          <Button text="Alert Button" click="button-event" value="1" color="alert" class="secondary" />
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("button-event", params, socket) do
    IO.inspect(params)
    {:noreply, socket}
  end
end
