const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    port: 5001,
    host: "localhost",
    open: true,
    proxy: {
      '/token': {
        target: "https://annielyticx-gamedataauth.azurewebsites.net/oauth",
        changeOrigin: true,
        ws: false,
        secure: false,
        pathRewrite: {
          "^/token":""
        }
      }
    }
  }
})
