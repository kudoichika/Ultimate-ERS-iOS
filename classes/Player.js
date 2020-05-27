class Player {
    constructor(handle, cardQueue) {
        this.handle = handle
        this.cardQueue = cardQueue
    }
    appendCards = function(cards) {
        this.cardQueue.push(cards)
    }
    deckSize = function() {
        return this.cardQueue.length
    }
    popCard = function() {
        return this.cardQueue.shift()
    }
    checkStatus = function() {
        return (this.deckSize > 0)
    }
}

module.exports = Player