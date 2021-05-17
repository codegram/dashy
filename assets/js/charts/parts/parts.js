import Chart from "chart.js/auto"
import "chartjs-adapter-luxon"

import { config, buildDatasets } from "./config"

const PartsHooks = {
  mounted() {
    var chart = new Chart(this.el, config)

    this.handleEvent("load-parts", ({ data }) => {
      chart.data = {
        datasets: buildDatasets(data),
      }
      chart.update()

      const $partsList = document.getElementById(this.el.dataset.listId)

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
