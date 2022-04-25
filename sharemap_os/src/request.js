import axios from 'axios'

axios.defaults.baseURL = 'http://localhost:5001/'
axios.defaults.timeout = 20000

axios.interceptors.request.use(response => {
  response.headers.Authorization = window.sessionStorage.getItem('token')
  return response
})

export default axios