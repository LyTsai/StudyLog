// 1. 首先引入express库：
const express = require("express");
// 2. 创建 express 的实例，代表服务器
const app = express();
// const user = require("./routes/user");
// app.use('/user', user)

// 3. 设置监听端口
const port = 3000;
app.use(express.json());

const routes = require('./routes/index')
routes(app);

// 4. 调用 app.listen 来启动 server 并监听指定端口，启动成功后打印出 log
app.listen(port, () =>
  console.log(`Express server listening at http://localhost:${port}`)
);

// get
// req: 请求的路径，这里处理根路径的请求
// res: 处理请求的回调函数，参数分别为请求和响应对象
app.get('/', (req, res) => {
    // 重启一下 express 服务，然后打开浏览器访问
    res.send('Hello world!');
});

// post
// 201代表资源创建成功
// postman -> post -> body -> raw -> JSON -> 输入数据检测
app.post('/', (req, res) => {
    console.log("request body: ", req.body);
    res.status(201).send();
});

// put
// 路径后面的:id 的意思是，根路径后边的值都会作为请求的参数
// 并且赋给名为 id 的变量，（如：http://localhost:3000/3, id 的值就为3）
app.put("/:id", (req, res) => {
    // 打印一下请求参数的值，req.params.id
    console.log("收到请求参数，id 为：", req.params.id);
      // 再打印一下请求体
    console.log("收到请求体：", req.body);
  
    // 返回响应，默认是200
    res.send();
  
  });

  // delete
  app.delete("/:id", (req, res) => {
    console.log("收到请求参数，id 为：", req.params.id);
    res.status(204).send();
  });

  