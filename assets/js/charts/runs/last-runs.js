import Chart from "chart.js/auto"
import { config, buildLabels } from "./config"

const LastRunsHooks = {
  mounted() {
    var chart = new Chart(this.el, config)

    this.handleEvent("load-runs", ({ data }) => {
      chart.data = buildLabels(data)
      chart.update()
    })
  },
}

export default LastRunsHooks
