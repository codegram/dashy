import Chart from "chart.js/auto"
import { config } from "./config"

const LastRunsHooks = {
  mounted() {
    var chart = new Chart(this.el, config)

    this.handleEvent("load-runs", ({ data }) => {
      chart.data = data
      chart.update()
    })
  },
}

export default LastRunsHooks
