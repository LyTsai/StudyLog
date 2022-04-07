// import axios from 'axios'

// export default function request ({ data }) {
//   const baseUrl = '/api'
//   const service = axios.create({
//     baseURL: baseUrl,
//     timeout: 5000
//   })

//   service.interceptors.request.use(config => {
//     config.data = JSON.stringify(config.data)
//     config.headers = {
//       'Content-Type' : "application/x-www-form-urlencoded"
//     }
//     config.params = {
//       grant_type: 'password'
//     }

//     return config
//   })

//   return service(data)
// }