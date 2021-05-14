import Chart from "chart.js/auto"
import "chartjs-adapter-luxon"
import toTime from "./utils.js"

const PartsHooks = {
  mounted() {
    const config = {
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

    var chart = new Chart(this.el, config)

    function generateColors(total) {
      const result = []
      for (var i = 0; i < total; i++) {
        result[i] = `hsla(${(360 / total) * i}, ${50 + 25 * (i % 3)}%, ${
          75 - 25 * (i % 3)
        }%, `
      }
      return result
    }

    this.handleEvent("load-parts", ({ data }) => {
      console.log(data)
      const partNames = Object.keys(data)
      const LINE_COLORS = generateColors(partNames.length)

      function showPartColor(colorIndex) {
        return () => {
          if (
            window.partNameFocus &&
            partNames[colorIndex] != window.partNameFocus
          ) {
            return LINE_COLORS[colorIndex] + "10%)"
          } else {
            return LINE_COLORS[colorIndex] + "100%)"
          }
        }
      }

      function showPartBorderWidth(colorIndex) {
        return () => {
          if (partNames[colorIndex] == window.partNameFocus) {
            return 2
          } else {
            return 1
          }
        }
      }

      var colorIndex = 0
      const partsDatasets = partNames.map((partName) => {
        return {
          label: partName,
          data: data[partName],
          cubicInterpolationMode: "monotone",
          pointBackgroundColor: showPartColor(colorIndex),
          borderColor: showPartColor(colorIndex),
          borderWidth: showPartBorderWidth(colorIndex++),
          tension: 0.2,
          pointStyle: "circle",
          pointBorderWidth: 0,
          pointRadius: 2,
        }
      })

      chart.data = {
        datasets: partsDatasets,
      }
      chart.update()

      const $partsList = document.getElementById("parts_list")
      $partsList.innerHTML = "<ul>"
      for (var index in partNames) {
        const partName = partNames[index]
        $partsList.innerHTML += `<li class="part_name" data-slug="${partName}" style="color: ${LINE_COLORS[index]}100%)"><span>${partName}</span> <a href="#${partName}">&gt;&gt;</a></li>`
      }
      $partsList.innerHTML += "</ul>"

      Object.values(document.getElementsByClassName("part_name")).forEach(
        (part) => {
          part.addEventListener("mouseover", (e) => {
            window.partNameFocus = e.currentTarget.dataset.slug
            chart.update()
          })
        }
      )
      $partsList.addEventListener("mouseout", (_) => {
        window.partNameFocus = null
        chart.update()
      })
    })
  },
}

export default PartsHooks
