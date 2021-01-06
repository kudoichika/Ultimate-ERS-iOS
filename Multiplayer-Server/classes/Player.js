class Player {
    constructor() {
        this.cardQueue = []
    }
    appendCards(cards) {
        this.cardQueue.push(cards)
    }
    deckSize() {
        return this.cardQueue.length
    }
    popCard() {
        return this.cardQueue.shift()
    }
    checkStatus() {
        return (this.deckSize > 0)
    }
    getDeck() {
        return this.cardQueue
    }
}

module.exports = Player