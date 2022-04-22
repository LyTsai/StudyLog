const path = require('path')

module.exports = {
  alias: {
    '/@/': path.resolve(__dirname, './src')
  },
  hostname: "0.0.0.0",
  port: '8080',
  open: true,
  https: false,
  ssr: false,
  base: './',
  outDir: 'dist',
  proxy: {
    '/api': {
      target: "http://localhost:5001/api",
      changeOrigin: true,
      pathRewrite: path => path.replace(/^\/api/, '')
    }
  }
}