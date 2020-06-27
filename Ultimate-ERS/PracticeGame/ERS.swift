//
//  ERSGame.swift
//  Ultimate-ERS
//
//  Created by Kudo on 6/22/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation

class ERS {
    
    let difficulty : Int
    let N : Int
    let obg : Bool
    let burns : Int
    var stack : Stack<Card>
    var penaltyStack : Stack<Card>
    var players : Array<Player>
    var penalties : Array<Int>
    
    var claim : Bool!
    var claimer : Int!
    var numleft : Int!
    
    //obligation
    
    init(difficulty : Int = 5, numPlayers : Int = 2, manObg : Bool = true, penalty : Int = 2) {
        self.difficulty = difficulty
        N = numPlayers
        obg = manObg
        burns = penalty
        stack = Stack<Card>()
        penaltyStack = Stack<Card>()
        players = []
        penalties = []
        
        claim = false
        claimer = -1
        numleft = -1
        
        for _ in 1...N {
            self.players.append(Player())
        }
        distributeCards()
    }
    
    func distributeCards() {
        var cards : Array<Card> = []
        let suite = ["S", "H", "C", "D"]
        for i in 1...13 {
            for s in suite {
                let t = Card(suit : Character(s), val : i)
                cards.append(t)
            }
        }
        cards.shuffle()
        for i in 0..<cards.count {
            players[i % N].appendCards(cardIn : [cards[i]])
        }
    }
    
    func slap(player : Int) -> Bool {
        if player == obgCollector() || checkPattern() {
            collectCards(receiver : player)
            return true
        }
        /*for i in 1...burn {
            if getStatus(players[player]) {
                penaltyStack.push(players[player].pop())
            } else {
                //player retired
            }
        }*/
        return false
    }
    
    func obgCollector() -> Int {
        if claim && numleft == 0 {
            print("Obligation Collecter = \(claimer)")
            return claimer
        }
        return -1
    }
    
    func underObg(player : Int) -> Bool {
        if claim {print("Under Obligation of \(claimer) numleft = \(numleft)")}
        return claim && player != claimer
    }
    
    func collectCards(receiver : Int) {
        print("Collecting All Cards")
        players[receiver].appendCards(cardIn: stack.items)
        players[receiver].appendCards(cardIn: penaltyStack.items)
        stack.reset()
        penaltyStack.reset()
        claim = false
        numleft = -1
        claimer = -1
    }
    
    func playCard(player : Int) -> Card {
        let card = players[player].pop()
        stack.push(item : card)
        if claim {
            numleft -= 1
        }
        var value = card.val
        if value == 1 {
            value += 13
        }
        if value > 10 {
            claim = true
            numleft = value - 10
            claimer = player
            print("Obligation Activated claimer = \(claimer) numleft = \(numleft)")
        }
        print("If Obligation, numleft = \(numleft)")
        return card
    }
    
    func getStatus(player : Int) -> Bool {
        return players[player].checkStatus()
    }
    
    func getPenalities() -> [Int] {
        return penalties
    }
    
    func getNumCards() -> [Int] {
        var numCards : Array<Int> = []
        for player in players {
            numCards.append(player.size())
        }
        return numCards
    }
    
    /*func checkWin() -> Int {
        //Implementation Matters on Random Gen
        var count = 0
        var player : Int
        for p in players {
            if checkStatus() {
                count += 1
            } else {
                player = p
            }
        }
        if count == N - 1 {
            return true
        }
        return false
    }*/
    
    func checkPattern() -> Bool {
        
        func compare(first : Int, second : Int) -> Bool{
            return stack.peek(at : first).val == stack.peek(at : second).val
        }
        
        func getval(at : Int = 0) -> Int {
            return stack.peek(at : at).val
        }
        
        func checkTopBottom() -> Bool {
            if stack.count() > 2 {
                return compare(first : 0, second : stack.count() - 1)
            }
            return false
        }
        
        func checkPair() -> Bool {
            if stack.count() > 1 {
                return compare(first : 0, second : 1)
            }
            return false
        }
        
        func checkSandwich() -> Bool {
            if stack.count() > 2 {
                return compare(first : 0, second : 2)
            }
            return false
        }
        
        func checkMarriage() -> Bool {
            if stack.count() > 1 {
                return (getval() == 13 && getval(at : 1) == 12) ||
                        (getval() == 12 && getval(at : 1) == 13)
            }
            return false
        }
        
        func checkDivorce() -> Bool {
            if stack.count() > 2 {
                return (getval() == 13 && getval(at : 2) == 12) ||
                    (getval() == 12 && getval(at : 2) == 13)
            }
            return false
        }
        func checkAddition() -> Bool{
            if (stack.count() > 2) {
                return  (getval(at : 2) + getval(at : 1) == getval()) ||
                    ((getval(at : 2) + getval(at : 1) == 14) && getval() == 1)
            }
            return false
        }
        func checkPythagorean() -> Bool {
            if stack.count() > 2 {
                return ((pow(Decimal(getval()), 2) + pow(Decimal(getval(at : 1)), 2) == pow(Decimal(getval(at : 2)), 2)) ||
                    (pow(Decimal(getval()), 2) + pow(Decimal(getval(at : 2)), 2) == pow(Decimal(getval(at : 1)), 2)) ||
                    (pow(Decimal(getval(at: 1)), 2) + pow(Decimal(getval(at : 2)), 2) == pow(Decimal(getval()), 2)))
            }
            return false
        }
        
        func checkStaircase() -> Bool {
            //edge case (haven't accounted for Ace = 14)
            if stack.count() > 2 {
                return getval() - getval(at : 1) == getval(at : 1) - getval(at : 2)
            }
            return false
        }
        if checkTopBottom() {print("Top Bottom Slap")}
        if checkPair() {print("Pair Slap")}
        if checkSandwich() {print("Sandwich Slap")}
        if checkMarriage() {print("Marriage Slap")}
        if checkDivorce() {print("Divorce Slap")}
        if checkAddition() {print("Addition Slap")}
        if checkPythagorean() {print("Pyth Slap")}
        if checkStaircase() {print("Staircase Slap")}
        
        if (topBottomSlap && checkTopBottom()) ||
            (pairSlap && checkPair()) ||
            (sandwichSlap && checkSandwich()) ||
            (marriageSlap && checkMarriage()) ||
            (divorceSlap && checkDivorce()) ||
            (additionSlap && checkAddition()) ||
            (pythSlap && checkPythagorean()) ||
            (stairSlap && checkStaircase()) {
                return true
        }
        
        return false
    }
    
}
