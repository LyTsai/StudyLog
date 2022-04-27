import axios from 'axios'

axios.defaults.baseURL = 'https://sharemap-node-backend.azurewebsites.net'
axios.defaults.timeout = 20000

axios.interceptors.request.use(response => {
  response.headers.Authorization = window.sessionStorage.getItem('token')
  return response
})

export default axios