import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
// import axios from 'axios'

// import './plugins/element.js'
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
// import * as ElementModules from '@element-plus/icons'

// import './assets/fonts/iconfont.css'

// style file
import './assets/css/global.css'
// axios.defaults.baseURL = 'https://annielyticx-gamedataauth.azurewebsites.net/oauth'

const app = createApp(App)
// icons
// for (const iconName in ElementModules) {
//   app.component(iconName, ElIconModules[iconName])
// }

app.use(ElementPlus, { size: 'small' }).use(router).mount('#app')
// app.prototype.$message = ElementPlus.Message
