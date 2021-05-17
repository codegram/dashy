defmodule Dashy.Charts.WorkflowRunsFake do
  alias Dashy.Charts.Run

  def runs(opts \\ []) do
    count = Keyword.get(opts, :count, 50)
    fake_runs(DateTime.now!("Etc/UTC"), [], count)
  end

  defp fake_runs(_last_run_date, data, 0), do: data

  defp fake_runs(last_run_date, data, n) do
    time = DateTime.add(last_run_date, -:rand.uniform(1_000_000), :second)
    seconds = :rand.normal(180, 30) |> Float.round()

    run = %Run{
      time: time,
      seconds: seconds,
      minutes: seconds / 60,
      link: "https://github.com/decidim/decidim/commit/d3b88afe90e5643848e94ef13ee1e850bbc01e2d",
      status: set_status()
    }

    fake_runs(time, [run | data], n - 1)
  end

  defp set_status() do
    case :rand.uniform(100) do
      x when x < 20.0 -> "cancelled"
      x when x < 40.0 -> "error"
      x when x < 60.0 -> "pending"
      _ -> "success"
    end
  end
end
