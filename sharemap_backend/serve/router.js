
const express = require('express')
const router = express.Router()

const User = require('../controllers/user')

router.get('/api/user', User.getAllUsers)
router.get('/api/userByusername', User.getUserByName)
router.post('/api/user', User.addUser)
router.put('/api/user/:id', User.updateUserById)
router.delete('/api/user/:id', User.deleteUserById)
//路由控制
module.exports = router

