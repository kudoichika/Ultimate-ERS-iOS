const checkSlap = require('./patternChecker')

class Game {
    constructor(playerOne, playerTwo) {
        this.playerOne = playerOne
        this.playerTwo = playerTwo
        this.cardStack = []
        this.turn = 0
        this.moves = []
        //resign + winner needed
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
    
}

module.exports = Game