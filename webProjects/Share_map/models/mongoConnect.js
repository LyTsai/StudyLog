const mongoose = require('mongoose')

// connect
const dbName = 'Share_map'
const mongoUrl = "mongodb://localhost:27017/" + dbName
mongoose.connect(mongoUrl, { useNewUrlParser: true})
.then(() => {
    console.log(dbName + ' is connected')
})
.catch((error) => console.log(error))

module.exports = mongoose
