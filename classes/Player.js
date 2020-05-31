class Player {
    constructor(socket) {
        this.socket = socket
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
}

module.exports = Player