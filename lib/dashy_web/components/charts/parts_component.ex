defmodule DashyWeb.Components.Charts.Parts do
  use Surface.Component

  @doc "The list of the card"
  prop list, :string, required: false

  def render(assigns) do
    ~H"""
    <div phx-update="ignore">
      <canvas id="parts" phx-hook="PartsChart" data-list-id="{{@list}}"></canvas>
    </div>
    """
  end
end
