const mongoose = require('mongoose')
const Schema = mongoose.Schema

const UserSchema = new Schema({
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
}, {
      timestamps: true
})

mongoose.model('UserSchema', UserSchema)
