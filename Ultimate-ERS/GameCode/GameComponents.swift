//
//  GameComponents.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/20/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation

enum Suit : CustomStringConvertible{
    case spades, hearts, clubs, diamonds
    init?(symbol : Character) {
        switch(symbol) {
            case "S": self = .spades
            case "H": self = .hearts
            case "C": self = .clubs
            case "D": self = .diamonds
            default: return nil
        }
    }
    var description : String {
        switch self {
        case .spades: return "S"
        case .hearts: return "H"
        case .clubs: return "C"
        case .diamonds: return "D"
        }
    }
}

class Card {
    var suit : Suit!
    var val : Int
    init(suit : Character, val : Int) {
        self.suit = Suit(symbol : suit)
        self.val = val
    }
}

class Player {
    var cardQueue : Queue<Card>
    init() {
        cardQueue = Queue<Card>()
    }
    func appendCards(cardIn : Array<Card>) {
        for card in cardIn {
            cardQueue.push(item : card)
        }
    }
    func size() -> Int {
        return cardQueue.count()
    }
    func pop() -> Card {
        return cardQueue.pop()
    }
    func checkStatus() -> Bool {
        if cardQueue.count() <= 0 {
            return false
        }
        return true
    }
}
