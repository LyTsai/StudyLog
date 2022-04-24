const mongoose = require('./mongoConnect')

// collection rules
const visualSchema = new mongoose.Schema({
    title: {
        type: String
    },
    abstract: {
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
    // refs
    user_id: {
      type: mongoose.Schema.Types.ObjectId, 
      ref: 'User'
    }
}, { versionKey: false })

module.exports = mongoose.model('Visual', visualSchema, 'visuals')