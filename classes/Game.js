const checkSlap = require('../utils/patternChecker')
const Player = require('./Player')

class Game {
    constructor(adapter, room, playerOne) {
        console.log('New game initialized')
        this.adapter = adapter
        this.room = room
        this.status = 'waiting'
        this.playerOne = new Player(playerOne)
        this.playerTwo = null
        this.cardStack = []
        this.turn = 0
        this.moves = []
        //resign + winner needed
    }

    addPlayerAndStart(playerTwo) {
        this.playerTwo = new Player(playerTwo)
        this.status = 'playing'
        console.log('Starting Game')
        this.startGame()
    }

    pushStack(cards){
        this.cardStack.push(cards)
    }
    get popStack() {
        return this.cardStack.pop()
    }
    resetStack() {
        this.cardStack = []
    }
    peekStack(num = 0) {
        return this.cardStack[this.length - num - 1]
    }
    get size() {
        return this.cardStack.length
    }

    //Actual Gameplay
    startGame() {
        const adapter = this.adapter
        const room = this.room
        this.playerOne.socket.on('playCard', function(data) {
            console.log('PlayerOne has played a card')
            adapter.to(room).emit('cardPlayed')
        })
        this.playerTwo.socket.on('playCard', function(data) {
            console.log('PlayerTwo has played a card')
            adapter.to(room).emit('cardPlayed')
        })
        this.playerOne.socket.on('disconnect', function() {
            console.log('Player 1 Disconnected')
        })
        this.playerTwo.socket.on('disconnect', function() {
            console.log('Player 2 Disconnected')
        })
    }
}

module.exports = Game