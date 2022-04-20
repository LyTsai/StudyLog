const mongoose = require('../serve/mongoConnect')

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
}, { versionKey: false })

// userSchema.query.byName

module.exports = mongoose.model('User', userSchema, 'users')