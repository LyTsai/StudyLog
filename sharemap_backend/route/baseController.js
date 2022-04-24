const mongoose = require('../models/mongoConnect')

// RESTful api
// get
exports.getModel = async (modelName, req,res) => {
  const model = mongoose.model(modelName)
  try {
    let condition = req.query
    // replace for id
    if (req.query.id) {
      condition._id = req.query.id
    }
    let result = await model.find(condition)
    res.send(result)
  } catch (error) {
    res.status(404).send(error)
  }
}

// byQuery
exports.getByQuery= async (modelName, keys, req, res) => {
  const model = mongoose.model(modelName)
  const query = req.query
  let reg = {$regex: `^.*${query.query}.*$`}
  let condition = {}
  for (const key in keys) {
    if (keys.hasOwnProperty.call(keys, key)) {
      const element = String(keys[key])
      condition[element] = reg
    }
  }
  // empty, get all
  if (query.query === '') {
    condition = {}
  }
  let limit = Number(query.pagesize)
  let skip = (Number(query.pagenum) - 1) * limit
  if (query.pagesize === '') {
    limit = 10
  }
  if (query.pagenum === '') {
    skip = 0
  }

  try {
    let total = await model.count(condition)
    let result = await model.find(condition).limit(limit).skip(skip)
    res.json({"data": result, "total": total})
  } catch (error) {
    res.status(404).send(error)
  }
}

// post
exports.addModel = async (modelName, req, res) => {
  const model = mongoose.model(modelName)
  //req.body
  let data = new model (req.body)
  // check before add?
  try {
    let result = await data.save()
    res.status(201).send(result)
  } catch (error) {
    res.status(500).send(error)
  }
}
// put
// allow add
exports.updateById = async (modelName, req, res) => {
  const model = mongoose.model(modelName)
  try {
    let update = await model.updateOne({_id: req.body._id}, {$set: req.body}, {upsert: true})
    res.send(update)
  } catch (error) {
    res.status(500).send(error)
  }
}

// delete
exports.deleteById = async (modelName, req, res) => {
  const model = mongoose.model(modelName)
  try {
    let removed = await model.remove({_id: req.query.id})
    res.send(removed)
  } catch (error) {
    res.status(500).send(error)
  }
}