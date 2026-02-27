// src/addons/v4l-controls/useV4LControls.ts
import { ref } from "vue"
import { moonraker } from "@/api/moonraker"

export interface V4LControl {
  name: string
  type: string
  min?: number
  max?: number
  step?: number
  value: number | boolean
}

export function useV4LControls(device = "/dev/video0") {
  const controls = ref<V4LControl[]>([])
  const loading = ref(false)

  async function exec(cmd: string) {
    await moonraker.machine.exec_command({ command: cmd })
  }

  async function loadControls() {
    loading.value = true

    await exec(
      "~/printer_data/scripts/get_v4l_ctrls.sh > /tmp/v4l.json"
    )

    const res = await fetch("/server/files/roots/tmp/v4l.json")
    const json = await res.json()

    controls.value = Object.entries(json.controls).map(
      ([name, c]: any) => ({
        name,
        type: c.type,
        min: c.min,
        max: c.max,
        step: c.step,
        value: c.value
      })
    )

    loading.value = false
  }

  async function setControl(name: string, value: number | boolean) {
    await exec(
      `v4l2-ctl --device=${device} --set-ctrl=${name}=${value}`
    )
  }

  return {
    controls,
    loading,
    loadControls,
    setControl
  }
}