const express = require('express')
// const path = require('path');
const router = require('./router.js')
const bodyParser = require('body-parser')

const app = express()

// static
app.use(express.static('public'))

// parser
app.use(bodyParser.urlencoded({extended: false }))
app.use(bodyParser.json())

// router
app.use(router);

// listen
app.listen(5001,()=>{
    console.log('running...')
});