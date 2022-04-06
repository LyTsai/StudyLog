const express = require('express')
const router = express.Router()

const users = require("./models/users.js")

router.get('/user', users.getAllUsers)


module.exports = router