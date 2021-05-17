defmodule DashyWeb.Components.Charts.LastRuns do
  use Surface.Component

  def render(assigns) do
    ~H"""
    <div phx-update="ignore">
      <canvas id="last-runs" phx-hook="LastRunsChart"></canvas>
    </div>
    """
  end
end
