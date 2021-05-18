defmodule DashyWeb.HeaderLive do
  use DashyWeb, :live_view

  def mount(params, session, socket) do
    # socket = assign(socket, key: value)
    IO.inspect(params, label: "params")
    IO.inspect(session, label: "session")
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
    <h1>hello</h1>
    """
  end
end
