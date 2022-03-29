const express = require('express')
const router = express.router

router.get("/", (req, res) => {
    res.end('hello')
})


module.exports = router