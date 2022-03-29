const mongoose = require('./mongoConnect')
// const http = require('http')
// const url = require('url')

// collection rules
const userSchema = new mongoose.Schema({
    username: {
        type: String,
        unique: true
    },
    password: String,
    first_name: String,
    last_name: String,
    address: String,
    profession: [String],
    email: String,
    cell: String,
    
    // address: {type: mongoose.Schema.Types.ObjectId, ref: 'User'}
})

module.exports = mongoose.model('User', userSchema)