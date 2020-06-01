//
//  PracticeGamePlay.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/20/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation

class PracticeGamePlay {

    func checkRules(stack : Stack<Card>) -> Bool {

        /*if stack.count() > 0 {
            print("\(count) Stack: ", terminator: " ")
            for i in 0...(stack.count()-1) {
                print("\(stack.peek(at : i).val) ", terminator: " ")
            }
            print()
            count += 1
        }*/

        var val : Bool = false
        if topBottomSlap && checkTopBottom(stack : stack) {
            print("Top Bottom Detected")
            val = true
        }
        if pairSlap && checkPair(stack : stack) {
            print("Pair Detected")
            val = true
        }
        if sandwichSlap && checkSandwich(stack : stack) {
            print("Sandwich Detected")
            val = true
        }
        if marriageSlap && checkMarriage(stack : stack) {
            print("Marriage Detected")
            val = true
        }
        if divorceSlap && checkDivorce(stack : stack) {
            print("Divorce Detected")
            val = true
        }
        if additionSlap && checkAddition(stack : stack) {
            print("Addition Detected")
            val = true
        }
        if pythSlap && checkPythagorean(stack : stack) {
            print("Pythagorean Detected")
            val = true
        }
        if stairSlap && checkStaircase(stack : stack) {
            print("Staircase Detected")
            val = true
        }
        return val
    }

    func checkTopBottom(stack : Stack<Card>) -> Bool {
        if stack.count() > 2 {
            if stack.peek().val == stack.peek(at : stack.count() - 1).val {
                return true
            }
        }
        return false
    }

    func checkPair(stack : Stack<Card>) -> Bool {
        if stack.count() > 1 {
            if stack.peek().val == stack.peek(at : 1).val {
                return true
            }
        }
        return false
    }

    func checkSandwich(stack : Stack<Card>) -> Bool {
        if stack.count() > 2 {
            if stack.peek().val == stack.peek(at : 2).val {
                return true
            }
        }
        return false
    }

    func checkMarriage(stack : Stack<Card>) -> Bool {
        if stack.count() > 1 {
            if (stack.peek().val == 13 && stack.peek(at : 1).val == 12) || (stack.peek().val == 12 && stack.peek(at : 1).val == 13) {
                return true
            }
        }
        return false
    }

    func checkDivorce(stack : Stack<Card>) -> Bool {
        if stack.count() > 2 {
            if (stack.peek().val == 13 && stack.peek(at : 2).val == 12) || (stack.peek().val == 12 && stack.peek(at : 2).val == 13) {
                return true
            }
        }
        return false
    }

    func checkAddition(stack : Stack<Card>) -> Bool {
        if stack.count() > 2 {
            if stack.peek(at : 2).val + stack.peek(at : 1).val == stack.peek().val {
                return true
            }
            if (stack.peek(at : 2).val + stack.peek(at : 1).val == 14) && (stack.peek().val == 1) {
                return true
            }
        }
        return false
    }

    func checkPythagorean(stack : Stack<Card>) -> Bool {
        //account for different order
        if stack.count() > 2 {
            if pow(Decimal(stack.peek(at : 2).val), 2) + pow(Decimal(stack.peek(at : 1).val), 2) == pow(Decimal(stack.peek().val), 2) {
                return true
            }
        }
        return false
    }

    func checkStaircase(stack : Stack<Card>) -> Bool {
        //edge case account for 14 Ace
        if stack.count() > 2 {
            if (stack.peek().val - stack.peek(at : 1).val == stack.peek(at : 1).val - stack.peek(at : 2).val) {
                return true
            }
        }
        return false
    }

}
