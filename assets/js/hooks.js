import Chart from "chart.js/auto"

const Hooks = {}

Hooks.LastRunsChart = {
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
    function toTime(ctx) {
      return secondsToHms(ctx.parsed.y * 60)
    }
    function visitRun(event, array) {
      if (array[0]) {
        window.open(this.lastRuns[array[0].index].link)
      }
    }
    const runsData = {
      labels: this.lastRuns.map((run) => run.time),
      datasets: [
        {
          data: this.lastRuns,
          borderRadius: 2,
        },
      ],
    }
    function secondsToHms(d) {
      d = Number(d)
      var h = Math.floor(d / 3600)
      var m = Math.floor((d % 3600) / 60)
      var s = Math.floor((d % 3600) % 60)
      var hDisplay = h > 0 ? h + (h == 1 ? " hour, " : " hours, ") : ""
      var mDisplay = m > 0 ? m + (m == 1 ? " minute, " : " minutes, ") : ""
      var sDisplay = s > 0 ? s + (s == 1 ? " second" : " seconds") : ""
      return hDisplay + mDisplay + sDisplay
    }
    const runsConfig = {
      type: "bar",
      data: runsData,
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
        onClick: visitRun,
      },
    }
    var chart = new Chart(this.el, runsConfig)

    this.handleEvent("load", ({ data }) => {
      chart.data = data
      chart.update()
    })
  },
}

export default Hooks
