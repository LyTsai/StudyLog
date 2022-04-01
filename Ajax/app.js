const express = require("express");
const path = require('path')
const bodyParser = require('body-parser')
const formidable = require('formidable')

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

app.get('/verifyEmailAddress', (req, res) => {
    const email = req.query.email
    if (email == "test@163.com") {
        res.status(400).send({message: "Taken"})
    } else {
        res.send({message: "OK"})
    }
})

app.get("/searchAutoPrompt", (req, res) => {
    const searchKey = req.query.key
    const list = ["result1", "result2", "result3", "result4"]
    let result = list.filter(item => item.includes(searchKey))
    res.send(result)    
})

app.get("/province", (req, res) => {
    res.json([{
        id: "001", name: "黑龙江省"
    },{
        id: "002", name: "江苏省"
    }])
})

app.get("/cities", (req, res) => {
    const id = req.query.id
    const cities = {
        "001": [{
            id: "300", name: "哈尔滨"
        }, {
            id: "301", name: "齐齐哈尔"
        }], "002": [{
            id: "400", name: "南京"
        }]
    }
    res.send(cities[id])
})
app.get("/areas", (req, res) => {
    const id = req.query.id
    const areas = {
        "300": [{
            id: "20", name: "道里区"
        }], "301" : {
            id: "30", name: "龙沙区"
        }, "400": [{
            id: "40",  name: "鼓楼区"
        }, {
            id: "41", name: "玄武区"
        }]
    }

    res.send(areas[id])
})

app.post('/formData', (req, res) => {
    const form = new formidable.IncomingForm()
    form.parse(req, (err, fields, files) => {
        res.send(fields)
    })
})

const port = 3000
app.listen(port, () => {
    console.log(`http://localhost:${port}`)
})