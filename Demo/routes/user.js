var express = require('express');
var route = express.Router();

const userModel = require('../models/user')

route.get("/", (req, res) => {
    res.send({ 
        id: 1,
        title: "express"
    });
  });
  
  
  route.post("/", async (req, res) => {
    try {
      const newUser = await userModel.save(req.body);
      res.status(201).json(newUser);
    }catch (error) {
      console.error(error);
      res.status(500).send();
    }
  });
  
  route.put("/:id", (req, res) => {
    console.log("收到请求参数，id 为：", req.params.id);
    console.log("收到请求体：", req.body);
  
    res.send({id: req.params.id, ...req.body});
  });
  
  
  route.delete("/:id", (req, res) => {
    console.log("收到请求参数，id 为：", req.params.id);
    res.status(204).send();
  });

  // 导出子路由变量
  module.exports = route;