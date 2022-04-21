module.exports = defineConfig({
  Server: {
  // port: '8080',
  // host: "localhost",
  open: true,
  proxy: {
    '/api': {
      target: "http://localhost:5001/api",
      changeOrigin: true,
      pathRewrite: {
        "^/api":""
      }
    }
  }
}
})