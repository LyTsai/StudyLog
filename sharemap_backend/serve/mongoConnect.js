const mongoose = require('mongoose')

// connect
const dbName = 'share_map'
const mongoUrl = `mongodb://sharemap:LyPXwvDthnPtUi6HoFzCjIfMcb5OyD4ePaVFDB5oJ4sSVQOPBQeRCMfmqwnogqPKMhWlCdI1Ed4rdnTg8SIR4A==@sharemap.mongo.cosmos.azure.com:10255/${dbName}?ssl=true&replicaSet=globaldb&maxIdleTimeMS=120000&appName=@sharemap@`
mongoose.connect(mongoUrl, { useNewUrlParser: true, retrywrites: false})

.then(() => {
    console.log(dbName + ' is connected')
})
.catch((error) => console.log(error))

mongoose.connection.on('disconnected', () => {
    console.log('Mongoose connection disconnected')
})

module.exports = mongoose
