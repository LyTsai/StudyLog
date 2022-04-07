import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
// import axios from 'axios'

// import './plugins/element.js'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import './assets/fonts/iconfont.css'
import './assets/css/global.css'
// axios.defaults.baseURL = 'https://annielyticx-gamedataauth.azurewebsites.net/oauth'

const app = createApp(App)
app.use(ElementPlus).use(router).mount('#app')
// app.prototype.$message = ElementPlus.Message
