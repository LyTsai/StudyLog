// 1. 首先引入express库：
const express = require("express");
// 2. 创建 express 的实例，代表服务器
const app = express();
// const user = require("./routes/user");
// app.use('/user', user)

// 3. 设置监听端口
const port = 3000;

// app.use(express.json());

const routes = require('./routes/index')
routes(app);

// 4. 调用 app.listen 来启动 server 并监听指定端口，启动成功后打印出 log
app.listen(port, () =>
  console.log(`Express server listening at http://localhost:${port}`)
);

app.use(express.json());

// // get
// app.get('/', (req, res) => {
//     res.send('Hello world!');
// });

// // post
// app.post('/', (req, res) => {
//     console.log("request body: ", req.body);
//     res.status(201).send();
// });

// // put
// app.put("/:id", (req, res) => {
//     console.log("收到请求参数，id 为：", req.params.id);
//     console.log("收到请求体：", req.body);
  
//     // 返回响应，默认是200
//     res.send();
  
//   });

//   // delete
//   app.delete("/:id", (req, res) => {
//     console.log("收到请求参数，id 为：", req.params.id);
//     res.status(204).send();
//   });

  