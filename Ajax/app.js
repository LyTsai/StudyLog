const express = require("express");
const path = require('path')
const bodyParser = require('body-parser')

const app = express()
app.use(bodyParser.urlencoded({extended: false }))

app.use(bodyParser.json())

// 静态资源访问服务器，放在public文件夹里
app.use(express.static(path.join(__dirname, 'public')))

// 创建路由，请求方式/地址和客户端对应
app.get('/first', (req, res) => {
    res.send('hello ajax')
})

app.get('/get', (req, res) => {
    res.send(req.query)
})

app.post('/post', (req, res) => {
    res.send(req.body)
})

const port = 3000
app.listen(port, () => {
    console.log(`http://localhost:${port}`)
})