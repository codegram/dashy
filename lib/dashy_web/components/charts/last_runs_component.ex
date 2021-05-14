defmodule DashyWeb.Components.Charts.LastRuns do
  use Surface.Component

  @doc "The title of the chart"
  prop title, :string, required: false

  def render(assigns) do
    ~H"""
    <div phx-update="ignore">
        <h2>{{ @title }}</h2>
      <canvas id="last-runs" phx-hook="LastRunsChart"></canvas>
    </div>
    """
  end
end
