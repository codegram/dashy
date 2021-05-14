import Chart from "chart.js/auto"
import toTime from "./utils.js"

const LastRunsHooks = {
  mounted() {
    this.lastRuns = []
    // LAST RUNS GRAPH
    const COLORS = {
      success: "#3333FFCC",
      error: "#FF3333CC",
      cancelled: "#999999CC",
    }
    function colorize(ctx) {
      return COLORS[ctx?.raw?.status]
    }
    const data = {
      labels: this.lastRuns.map((run) => run.time),
      datasets: [
        {
          data: this.lastRuns,
          borderRadius: 2,
        },
      ],
    }
    const config = {
      type: "bar",
      data: data,
      options: {
        scales: {
          x: {
            title: {
              display: true,
              text: "Run",
            },
          },
          y: {
            title: {
              display: true,
              text: "Minutes",
            },
          },
        },
        plugins: {
          legend: false,
          tooltip: {
            callbacks: {
              beforeTitle: (ctx) => ctx[0].raw.status.toUpperCase(),
              label: toTime,
            },
          },
        },
        elements: {
          bar: {
            backgroundColor: colorize,
          },
        },
        parsing: {
          xAxisKey: "minutes",
          yAxisKey: "minutes",
        },
      },
    }
    var chart = new Chart(this.el, config)

    this.handleEvent("load-runs", ({ data }) => {
      chart.data = data
      chart.update()
    })
  },
}

export default LastRunsHooks