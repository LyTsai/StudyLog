import { createApp } from 'vue'

import App from './App.vue'
import router from './router'
import request from './plugins/request'

// Element plus, icons are missing
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'

// style file
import './assets/css/global.css'

// plus
// import { ElButton, ElInput, FormInstance, ElMessage, ElMessageBox } from 'element-plus'
// import { Delete, Edit, Search } from '@element-plus/icons-vue'
// app
const app = createApp(App)
// component
// app.component('ElButton', ElButton)
// app.component('ElInput', ElInput)
// app.component('ElForm', ElForm)
// app.component('ElFormItem', ElFormItem)
// app.component('FormInstance', FormInstance)
// app.component('DeleteIcon', Delete)
// app.component('EditIcon', Edit)
// app.component('SearchIcon', Search)

// config
app.config.globalProperties.$http = request
// app.config.globalProperties.$message = ElMessage
// app.config.globalProperties.$confirm = ElMessageBox.confirm
// use
app.use(ElementPlus).use(router).mount('#app')
