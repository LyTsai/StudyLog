var express = require('express');
var route = express.Router();



const userModel = require('../models/user')
route.get("/", async (req, res) => {
  try {
    const users = await userModel.findAll();
    res.json(users);
  } catch (error) {
    console.error(error);
    res.status(404).send();
  }
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
  
// route.put("/:id", async (req, res) => {
//   try {
//     const updatedUser = await userModel.update(req.params.id, req.body);
//     res.json(updatedUser);
//   } catch (error) {
//     console.error(error);
//     res.status(500).send();
//   }
// });
  
route.delete("/:id", async (req, res) => {
  try {
    await userModel.delete(req.params.id);
    res.status(204).send();
  } catch (error) {
    console.error(error);
    res.status(500).send();
  }
});

  // 导出子路由变量
  module.exports = route;