
const express = require('express')
const router = express.Router()

const User = require('./user')

router.get('/api/user', User.getUsers)
router.get('/api/userByPage', User.getUserByPage)
router.post('/api/user', User.addUser)
router.put('/api/user', User.updateUserById) ///:id
router.delete('/api/user', User.deleteUserById)

//路由控制
module.exports = router

