const mongoose = require('mongoose')

// connect
const dbName = 'share_map'
const username = 'sharemap'
const password = 'LyPXwvDthnPtUi6HoFzCjIfMcb5OyD4ePaVFDB5oJ4sSVQOPBQeRCMfmqwnogqPKMhWlCdI1Ed4rdnTg8SIR4A=='
const host = 'sharemap.mongo.cosmos.azure.com'
const port = '10255'
const mongoUrl = `mongodb://${username}:${password}@${host}:${port}/${dbName}`
mongoose.connect(mongoUrl, {
    ssl: true, 
    replicaSet: 'globaldb',
    maxIdleTimeMS: 120000,
    appName: 'sharemap',
    useNewUrlParser: true,
    retrywrites: false
})
.then(() => {
    console.log(dbName + ' is connected')
})
.catch((error) => console.log(error))

// if disconnected
mongoose.connection.on('disconnected', () => {
    console.log('Mongoose connection disconnected')
})

module.exports = mongoose
