class Game {
    constructor(playerOne, playerTwo) {
        this.playerOne = playerOne
        this.playerTwo = playerTwo
        this.cardStack = []
        this.turn = 0
        this.moves = []
        //resign + winner needed
    }
    pushStack = function(cards) {
        this.cardStack.push(cards)
    }
    popStack = function() {
        return this.cardStack.pop()
    }
    resetStack = function() {
        this.cardStack = []
    }
    peekStack = function(num = 0) {
        return this.cardStack[this.length - num - 1]
    }
    size = function() {
        return this.cardStack.length
    }
}

module.exports = Game