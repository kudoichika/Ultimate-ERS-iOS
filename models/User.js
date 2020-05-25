const mongoose = require('mongoose')
const Schema = mongoose.Schema

let User = new Schema({
  handle: {
    type: String,
    unique: true,
    required: true
  },
  email: {
    type: String,
    unique: true,
    required: true
  },
  pass: {
    type: String,
    unqiue: false,
    required: true
  }
})

User.statics = {
  create: function(data, callback) {
    this(data).save(callback)
  },
  get: function(query, callback) {
    this.find(query, callback)
  },
  update: function(query, data, callback) {
    this.findOneAndUpdate(
      query,
      {$set:data},
      {new: true},
      callback
    )
  },
  delete: function(query, callback) {
    this.findOneAndDelete(query, callback)
  }
}

module.exports = mongoose.model('user', User)
