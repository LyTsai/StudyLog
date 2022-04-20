
const User = require('../models/users')

exports.getAllUsers = function(req, res) {
  User.find({}, function (error, data) {
    if (error) {
      res.json({"status": "error", "msg": "Failed to get all users"});
    } 
    res.json({"status": "success", "data": data})
  })
}

exports.getUserByName= function(req, res) {
  const username = req.params.username
  console.log(username)
  User.findOne({username: username}, function (err, data) {
      if(err){
          res.json({"status": "error"});
      }else{
          res.json({"status":"success","data": data})
      }
  })
}

exports.addUser = function(req, res) {
  let userData = new User ({
      username: req.body.username,
      password: req.body.password,
      first_name: req.body.first_name,
      last_name: req.body.last_name,
      address: req.body.address,
      profession: req.body.profession,
      email: req.body.email,
      cell: req.body.cell
  })
  // check before add?
  userData.save(function(err) {
    if (err) {
      res.json({"status" : "error" + err})
    }else {
      res.json({"status": "success"})
    }
  })
  // user.findOne({username: userData.username})
  // .then((data) => {
  //     if (data) {
  //         console.log('user exist')
  //     }else {
          // userData.save().then(console.log('success'))
  //         .catch()
  //     }
  // })
  // .catch(console.log())
}

exports.getUserByName= function(req, res) {
  const username = req.params.username
  console.log(username)
  User.findOne({username: username}, function (err, data) {
      if(err){
          res.json({"status": "error"});
      }else{
          res.json({"status":"success","data": data})
      }
  })
}

exports.updateUserById = function(req, res) {
  const id = req.params.id
  User.updateOne()
}

exports.deleteUserById = function(req, res) {
  const id = req.params.id
  User.updateOne()
}