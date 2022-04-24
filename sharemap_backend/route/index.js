
const express = require('express')
const router = express.Router()

const base = require('./baseController')
// registe for model
const User = require('../models/users')
const Visual = require('../models/visuals')

// USER
router.get('/api/user', (req, res) => {
  base.getModel('User', req, res)
})
router.get('/api/userByPage', (req, res) => {
  base.getByQuery('User', ['username'], req, res)
})
router.post('/api/user', (req, res) => {
  base.addModel('User', req, res)
})
router.put('/api/user', (req, res) => {
  base.updateById('User', req, res)
})
router.delete('/api/user', (req, res) => {
  base.deleteById('User', req, res)
})

// Visual
router.get('/api/visual', (req, res) => {
  base.getModel('Visual', req, res)
})
router.get('/api/visualByPage', (req, res) => {
  base.getByQuery('Visual',['title', 'subject'], req, res)
})
router.post('/api/visual', (req, res) => {
  base.addModel('Visual', req, res)
})
router.put('/api/visual', (req, res) => {
  base.updateById('Visual', req, res)
})
router.delete('/api/visual', (req, res) => {
  base.deleteById('Visual', req, res)
})

// router.get('/api/userByPage', User.getUserByPage)
// router.post('/api/user', User.addUser)
// router.put('/api/user', User.updateUserById) ///:id
// router.delete('/api/user', User.deleteUserById)

// // Visual
// const visuals = require('./visual')
// router.get('/api/visual', visuals.getVisuals)
// router.post('/api/visual', Visual.addVisual)
// router.put('/api/visual', Visual.updateVisualById) ///:id
// router.delete('/api/visual', Visual.deleteVisualById)

//router
module.exports = router
