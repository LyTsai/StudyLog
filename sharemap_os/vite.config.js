const path = require('path')

module.exports = {
  alias: {
    '/@/': path.resolve(__dirname, './src')
  },
  hostname: "0.0.0.0",
  port: '8000',
  open: true,
  ssr: false,
  base: './',
  outDir: 'dist',
  proxy: {
    '/api': {
      target: "https://sharemap-node-backend.azurewebsites.net/api",
      changeOrigin: true,
      pathRewrite: path => path.replace(/^\/api/, '')
    }
  }
}