import toTime from "../utils.js"

const COLORS = {
  pending: "#FBBF24CC",
  success: "#28A745CC",
  error: "#FF3333CC",
  cancelled: "#999999CC",
}
function colorize(ctx) {
  return COLORS[ctx?.raw?.status]
}

function visitRun(_event, array){
  if (array[0]) {
    window.open(array[0].element.$context.raw.link);
  }
}

export function buildLabels(data) {
  return {
    labels: data.map((run) => run.time),
    datasets: [
      {
        data: data,
        borderRadius: 2,
      },
    ],
  }
}

export const config = {
  type: "bar",
  data: buildLabels([]),
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
