const Schema = require('mongoose').Schema
const CardSchema = require('./CardSchema')

let PlayerSchema = new Schema({
    handle: {
        type: String,
        unqiue: true,
        require: true
    },
    cardQueue: {
        type: [CardSchema],
        unqiue: true,
        required: true
    }
}, {
    _id: false
})

PlayerSchema.methods = {
    appendCards: function(cards, callback) {
        this.cardQueue.push(cards)
    },
    deckSize: function() {
        return this.cardQueue.length
    },
    popCard: function() {
        return this.cardQueue.shift()
    },
    checkStatus: function() {
        return (this.cardQueue.length > 0)
    }
}

module.exports = PlayerSchema