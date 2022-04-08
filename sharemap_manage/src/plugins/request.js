import axios from 'axios'
import { configProviderContextKey } from 'element-plus'

axios.defaults.baseURL = 'https://localhost:5001/'
// axios.defaults.timeout = 2000

axios.interceptors.request.use(response => {
  response.headers.Authorization = window.sessionStorage.getItem('token')
  return response
})

export default axios
