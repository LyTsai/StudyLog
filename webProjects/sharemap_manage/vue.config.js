const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    port: 8080,
    host: "localhost",
    open: true,
    proxy: {
      // '/token': {
      //   target: "https://annielyticx-gamedataauth.azurewebsites.net/oauth",
      //   changeOrigin: true,
      //   pathRewrite: {
      //     "^/token":""
      //   }
      // }
      '/api': {
        target: "https://localhost:5001/api",
        changeOrigin: true,
        pathRewrite: {
          "^/api":""
        }
      }
    }
  }
})
