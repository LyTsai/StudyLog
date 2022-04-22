const User = require('../models/users')

// get
exports.getUsers = async (req, res) => {
  try {
    let condition = req.query
    // if (condition.id !== null) {
    //   console.log(condition.id)
    //   condition._id = condition.id
    // }
    let result = await User.find(condition)
    res.send(result)
  } catch (error) {
    res.status(404).send(error)
  }
}

exports.getUserByPage= async (req, res) => {
  const query = req.query
  let reg = {$regex: `^.*${query.query}.*$`}
  let condition = { username: reg}
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
    let total = await User.count(condition)
    let result = await User.find(condition).limit(limit).skip(skip)
    res.json({"data": result, "total": total})
  } catch (error) {
    res.status(404).send(error)
  }
}

// add
exports.addUser = async (req, res) => {
  //req.body
  let userData = new User (req.body)
  // check before add?
  try {
    let user= await userData.save()
    res.status(201).send(user)
  } catch (error) {
    res.status(500).send(error)
  }
}
// update
// allow add
exports.updateUserById = async (req, res) => {
  let id = req.body
  if (req.query.id) {
    id = req.query.id
  }
  const updated = req.body
  try {
    let update = await User.updateOne({_id: updated._id}, {$set: updated}, {upsert: true})
    res.send(update)
  } catch (error) {
    res.status(500).send(error)
  }
}

// delete
exports.deleteUserById = async (req, res) => {
  const id = req.query.id
  try {
    let removed = await User.remove({_id: id})
    res.send(removed)
  } catch (error) {
    res.status(500).send(error)
  }
}