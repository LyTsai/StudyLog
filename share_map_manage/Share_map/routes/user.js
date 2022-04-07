
// const express = require("express")
// const router = express.Router()

// const User = require('../models/users')

// router.get('/list', (req, res) => {
//     User.find().then(data => {
//         console.log('get all')
//     })
//     .catch(console.log('Failed to get all users'))
// })

// router.post('/add', (req, res) => {
//     let postData = {
//         username: req.body.username,
//         password: req.body.password,
//         first_name: req.body.first_name,
//         last_name: req.body.last_name,
//         address: req.body.address,
//         profession: req.body.profession,
//         email: req.body.email,
//         cell: req.body.cell
//     }

//     User.findOne({username: postData.username})
//     .then((data) => {
//         if (data) {
//             console.log('exist')
//         }else {
//             User.insertOne(postData).then(console.log('success'))
//             .catch()
//         }
//     })
//     .catch(console.log())
// })

// module.exports = router;