<!-- src/addons/v4l-controls/V4LPanel.vue -->
<script setup lang="ts">
import { onMounted } from "vue"
import { useV4LControls } from "./useV4LControls"
import V4LControl from "./V4LControl.vue"

const {
  controls,
  loading,
  loadControls,
  setControl
} = useV4LControls("/dev/video0")

onMounted(loadControls)
</script>

<template>
  <div class="v4l-panel">
    <header>
      <span>Camera Controls</span>
      <button @click="loadControls">↻</button>
    </header>

    <div v-if="loading">Loading controls…</div>

    <V4LControl
      v-for="c in controls"
      :key="c.name"
      :control="c"
      @update="val => setControl(c.name, val)"
    />
  </div>
</template>

<style scoped>
.v4l-panel header {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
}
button {
  background: none;
  border: none;
  cursor: pointer;
}
</style>