const mongoose = require('mongoose')
const Schema = mongoose.Schema
const PlayerSchema = require('./PlayerSchema')
const CardSchema = require('./CardSchema')

const GameSchema = new Schema({
    //Add support for more players later
    playerOne: {
        type: PlayerSchema,
        unique: false,
        required: true
    },
    playerTwo: {
        type: PlayerSchema,
        unique: false,
        required: true
    },
    cardStack: {
        type: [CardSchema],
        unique: false,
        required: true
    },
    turn: {
        type: Integer,
        unique: false,
        required: true
    },
    winner: {
        type: String,
        unique: false,
        required: false
    },
    moves: {
        type: [String],
        unique: false,
        required: false
    },
    resign: {
        type: Boolean,
        unqiue: false,
        required: false
    }
}, {
    timestamp: true
})

GameSchema.methods = {
    pushStack: function(cards, callback) {
        this.cardStack.push(cards)
    },
    popStack: function() {
        return this.cardStack.pop()
    },
    resetStack: function(callback) {
        this.cardStack = []
    },
    peekStack: function(num = 0) {
        return this.cardStack[this.length - num - 1]
    },
    size: function() {
        return this.cardStack.length
    }
}

mongoose.model('GameSchema', GameSchema)