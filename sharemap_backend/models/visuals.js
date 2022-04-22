const mongoose = require('./mongoConnect')

// collection rules
const userSchema = new mongoose.Schema({
    title: {
        type: String
    },
    abstrac: {
        type: String
    },
    keywords: [String],
    subject: String,
    text: String,
    url:  {
      type: String,
      required: true,
      unique: true
    },
    url_scancode: String,
    user: {
      type: mongoose.Schema.Types.ObjectId, 
      ref: 'User'
    }
}, { versionKey: false })

module.exports = mongoose.model('Visual', userSchema, 'visuals')