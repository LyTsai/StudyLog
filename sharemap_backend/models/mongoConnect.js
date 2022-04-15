const mongoose = require('mongoose')

// connect
const dbName = 'share_map'
const mongoUrl = "sharemap:LyPXwvDthnPtUi6HoFzCjIfMcb5OyD4ePaVFDB5oJ4sSVQOPBQeRCMfmqwnogqPKMhWlCdI1Ed4rdnTg8SIR4A==@sharemap.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&maxIdleTimeMS=120000&appName=@sharemap@" + dbName
mongoose.connect(mongoUrl, { useNewUrlParser: true})
.then(() => {
    console.log(dbName + ' is connected')
})
.catch((error) => console.log(error))

module.exports = mongoose
