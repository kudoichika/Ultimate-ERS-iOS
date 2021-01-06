const Player = require('./Player')
const checkSlap = require('../utils/patternChecker')

class ERS {
    //Add support for more players later
    constructor(numPlayers) {
        this.players = []
        for (let i = 0; i < numPlayers; i++) {
            this.players.push(new Player())
        }
        this.stack = []
        this.burnStack = []
        this.num = numPlayers
    }
    readyGame() {
        this.distributeCards()
        this.turn = Math.floor(Math.random() * this.num)

        //Helper
        this.obligation = 1
        this.pass = 0
        this.flag = false
        this.claim = this.num
        return true
    }
    distributeCards() {
        const suite = ['S', 'H', 'C', 'D']
        let cards = []
        for (let i = 1; i <= 13; i++) {
            for (let j = 0; j < suite.length; j++) {
                cards.push({suit: suite[j], val: i})
            }
        }
        //Knuth Shuffle
        let curr = cards.length
        while (curr !== 0) {
            let rand = Math.floor(Math.random() * curr)
            curr--
            let temp = cards[curr]
            cards[curr] = cards[rand]
            cards[rand] = temp
        }
        //Distribute Cards
        for (let i = 0; i < cards.length; i++) {
            this.players[i%this.num].appendCards(cards[i])
        }
    }
    playCard(player) { //Add support for manual obligation later
        //check status - player might leave after losing
        let card = this.players[player].popCard()
        this.stack.push(card)
        console.log('Player', player+1, 'has played card', card)
        //check if that was the player's last card
        this.obligation--
        let val = card.val
        if (val === 1) val = 14
        if (val > 10) {
            this.obligation = val - 10
            this.flag = true
            this.claim = this.turn
        }
        let collect = -1
        if (this.obligation === 0) {
            if (this.flag) {
                collect = this.claim
                this.players[collect].appendCards(this.stack)
                this.players[collect].appendCards(this.burnStack)
                this.stack = []
                this.burnStack = []
                this.flag = false
            }
            this.obligation = 1
            this.turn = (this.turn + 1) % this.num
            //check if the next guys are alive or not
        }
        //check if theres a winner
        return {player: player,
                card: card.suit + card.val,
                turn: this.turn,
                zero: this.players[0].cardQueue.length,
                one: this.players[1].cardQueue.length,
                collect: collect,
                winner: -1}
    }
    slapStack(player) { //check for obligation slap
        let result = checkSlap(this.stack)
        if (result) {
            this.turn = player
            this.obligation = 1
            this.players[player].appendCards(this.stack)
            this.players[player].appendCards(this.burnStack)
            this.stack = []
            this.burnStack = []
            this.flag = false
        } else {
            this.burnStack.push(this.players[player].popCard())
            this.burnStack.push(this.players[player].popCard())
        }
        //check if theres a winner
        return {slapper: player,
                outcome: result,
                turn: this.turn,
                zero: this.players[0].cardQueue.length,
                one: this.players[1].cardQueue.length,
                winner: -1}
    }
    playerLeft(player) { //mutator method
        //mark players that have left
        //either, play as computer, distribute cards,
        //or close the game
    }
}

module.exports = ERS
