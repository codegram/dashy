defmodule DashyWeb.Components.Charts.Parts do
  use Surface.Component

  @doc "The title of the chart"
  prop title, :string, required: false

  def render(assigns) do
    ~H"""
    <div phx-update="ignore">
      <h2>{{ @title }}</h2>
      <canvas id="parts" phx-hook="PartsChart"></canvas>
      <div id="parts_list"></div>
    </div>
    """
  end
end
