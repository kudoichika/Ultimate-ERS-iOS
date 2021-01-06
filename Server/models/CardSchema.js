const Schema = require('mongoose').Schema

let CardSchema = new Schema({
    suit: {
        type: String,
        unique: false,
        required: true
    },
    val: {
        type: String,
        unique: false,
        required: true
    }
}, {
    _id: false
})

module.exports = CardSchema