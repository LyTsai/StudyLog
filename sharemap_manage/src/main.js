import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import request from './plugins/request'

// Element plus, icons are missing
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

// style file
import './assets/css/global.css'

// axios

// app
const app = createApp(App)
app.config.globalProperties.$http = request
app.use(ElementPlus, { size: 'small' }).use(router).mount('#app')
