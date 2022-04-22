
const express = require('express')
const router = express.Router()

const User = require('./user')
const Visual = require('./visual')

// USER
router.get('/api/user', User.getUsers)
router.get('/api/userByPage', User.getUserByPage)
router.post('/api/user', User.addUser)
router.put('/api/user', User.updateUserById) ///:id
router.delete('/api/user', User.deleteUserById)

// Visual
router.get('/api/visual', Visual.getVisuals)
router.post('/api/visual', Visual.addVisual)
router.put('/api/visual', Visual.updateVisualById) ///:id
router.delete('/api/visual', Visual.deleteVisualById)

//router
module.exports = router
