import { createApp } from 'vue'
import App from './App.vue'
import './index.css'

import router from './router'
import request from './request'

// Element plus, icons are missing
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

const app = createApp(App)

app.config.globalProperties.$http = request

// use
app.use(ElementPlus).use(router).mount('#app')