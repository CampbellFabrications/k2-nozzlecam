<!-- src/addons/v4l-controls/V4LControl.vue -->
<script setup lang="ts">
import { computed } from "vue"
import type { V4LControl } from "./useV4LControls"

const props = defineProps<{
  control: V4LControl
}>()

const emit = defineEmits<{
  (e: "update", value: number | boolean): void
}>()

const isSlider = computed(() => props.control.type === "integer")
const isToggle = computed(() => props.control.type === "boolean")
</script>

<template>
  <div class="v4l-control">
    <label>{{ control.name }}</label>

    <input
      v-if="isSlider"
      type="range"
      :min="control.min"
      :max="control.max"
      :step="control.step"
      :value="control.value"
      @input="emit('update', +$event.target.value)"
    />

    <input
      v-if="isToggle"
      type="checkbox"
      :checked="control.value as boolean"
      @change="emit('update', ($event.target as HTMLInputElement).checked)"
    />
  </div>
</template>

<style scoped>
.v4l-control {
  margin-bottom: 12px;
}
label {
  display: block;
  font-size: 0.85em;
  opacity: 0.75;
}
</style>