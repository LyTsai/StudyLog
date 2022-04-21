const mongoose = require('./mongoConnect')

// collection rules
const userSchema = new mongoose.Schema({
    username: {
        type: String,
        required: true,
        unique: true
    },
    password: {
        type: String,
        required: true
    },
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