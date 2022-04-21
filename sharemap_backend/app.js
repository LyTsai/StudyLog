const express = require('express')
const cors = require('cors')
const bodyParser = require('body-parser')
const app = express()

app.use(cors())
app.use(express.urlencoded({ extended: false }))

// json
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

// router
const apiRouter = require('./route/index')
app.use(apiRouter)

// 404
app.use(function(req, res, next) {
  var err = new Error('Not Found')
  err.status = 404
  next(err)
})

// listen
const port = 5001
app.listen(port, () =>
    console.log(`Express server listening at http://localhost:${port}`)
)