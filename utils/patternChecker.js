module.exports = function(cardStack) {
    if (checkTopBottom() ||
        checkPair() ||
        checkSandwich() ||
        checkMarriage() ||
        checkDivorce() ||
        checkAddition() ||
        checkPythagorean() ||
        checkStaircase()) {
            return true
    }
    function checkTopBottom() {
        if (cardStack.length > 2) {
            if (peek() === peek(cardStack.length - 1)) {
                return true
            }
        }
        return false
    }
    function checkPair() {
        if (cardStack.length > 1) {
            if (peek() === peek(1)) {
                return true
            }
        }
        return false
    }
    function checkSandwich() {
        if (cardStack.length > 2) {
            if (peek() === peek(2)) {
                return true
            }
        }
        return false
    }
    function checkMarriage() {
        if (cardStack.length > 1) {
            if ((peek() === 13 && peek(1) === 12) ||
                (peek() === 12 && peek(1) === 13)) {
                    return true
            }
        }
        return false
    }
    function checkDivorce() {
        if (cardStack.length > 2) {
            if ((peek() === 13 && peek(2) === 12) ||
                (peek() === 12 && peek(2) === 13)) {
                    return true
            }
        }
        return false
    }
    function checkAddition() {
        if (cardStack.length > 2) {
            if ((peek(2) + peek(1) === peek()) ||
                (peek(2) + peek(1) === 14) && peek() === 1) {
                    return true
                }
        }
        return false
    }
    function checkPythagorean() {
        if (cardStack.length > 2) {
            if ((pow(peek(), 2) + pow(peek(1),2) === pow(peek(2),2)) ||
                (pow(peek(), 2) + pow(peek(2),2) === pow(peek(1),2)) ||
                (pow(peek(1), 2) + pow(peek(2),2) === pow(peek(),2))) {
                    return true
                }
        }
        return false
    }
    function checkStaircase() {
        //edge case (haven't accounted for Ace = 14)
        if (cardStack.length > 2) {
            if (peek() - peek(1) === peek(1) - peek(2)) {
                return true
            }
        }
        return false
    }

    function peek(num = 0) {
        return cardStack[this.length - num - 1].val
    }
}