const express = require('express')
const router = express.Router()

const users = require("./models/users.js")
router.get('/api/user', users.getAllUsers)

module.exports = router