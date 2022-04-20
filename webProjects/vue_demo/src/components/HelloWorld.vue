<template>
  <h1>{{ msg }}</h1>
  <button @click="counter++">count is: {{ counter }}, double is {{ doubleCounter}}</button>
  <p ref="desc">dtest</p>
</template>

<script>
import { reactive, computed, onMounted, onUnmounted, toRefs, ref, watch } from "vue"
export default {
  name: 'HelloWorld',
  props: {
    msg: String
  },
  setup() {
    const { counter, doubleCounter } = useCounter()
    const desc = ref(null)
    watch(counter, (val, oldVal) => {
      const p = desc.value
      p.textContent = `counter change from ${oldVal} to ${val}`
    })
    return { counter, doubleCounter, desc }
  }
}

function useCounter() {
  // https://www.bilibili.com/video/BV1WP4y1T7jS?from=search&seid=4304144511116026744&spm_id_from=333.337.0.0
  const data = reactive({
    counter: 1,
    doubleCounter: computed(() => data.counter * 2)
  })

  let timer
  onMounted(() => {
    timer = setInterval(() => {
      data.counter++
    }, 1000)
  })

  onUnmounted(() => {
    clearInterval(timer)
  })
  return toRefs(data)
}
</script>
