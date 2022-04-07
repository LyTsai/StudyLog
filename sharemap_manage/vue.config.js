const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
  transpileDependencies: true,
  devServer: {
    port: "5001",
    host: "localhost",
    open: true,
    proxy: {
      '/axios': {
        target: 'https://annielyticx-gamedataauth.azurewebsites.net',
        changeOrigin: true,
        ws: false,
        secure: false,
        pathRewrite: {
          '^/axios': ''
        }
      }
    }
  }
})
