import toTime from "../utils.js"

export const config = {
  type: "line",
  data: {},
  options: {
    animation: false,
    scales: {
      x: {
        type: "time",
        time: {
          tooltipFormat: "DD T",
        },
        title: {
          display: true,
          text: "Date",
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
          beforeTitle: (ctx) => ctx[0].raw.name.toUpperCase(),
          label: toTime,
        },
      },
    },
    parsing: {
      xAxisKey: "time",
      yAxisKey: "minutes",
    },
  },
}

export function showPartColor(label, color) {
  return () => {
    if (window.partNameFocus && label != window.partNameFocus) {
      return "#CCC"
    } else {
      return color
    }
  }
}

export function showPartBorderWidth(label) {
  return () => {
    if (label == window.partNameFocus) {
      return 2
    } else {
      return 1
    }
  }
}

export function buildDatasets(data) {
  console.log(data)
  return data.map(({ label, data, color }) => {
    return {
      label: label,
      data: data,
      cubicInterpolationMode: "monotone",
      pointBackgroundColor: showPartColor(label, color),
      borderColor: showPartColor(label, color),
      borderWidth: showPartBorderWidth(label),
      tension: 0.2,
      pointStyle: "circle",
      pointBorderWidth: 0,
      pointRadius: 2,
    }
  })
}
