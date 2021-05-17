import toTime from "../utils.js"

const lastRuns = []
// LAST RUNS GRAPH
const COLORS = {
  pending: "#FBBF24CC",
  success: "#3333FFCC",
  error: "#FF3333CC",
  cancelled: "#999999CC",
}
function colorize(ctx) {
  return COLORS[ctx?.raw?.status]
}
const data = {
  labels: lastRuns.map((run) => run.time),
  datasets: [
    {
      data: lastRuns,
      borderRadius: 2,
    },
  ],
}
export const config = {
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
