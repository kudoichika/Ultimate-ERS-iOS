//
//  PracticeScene.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/20/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import SpriteKit

class PracticeScene: SKScene {
    
    let N : Int = 2
    let difficulty : Int = 2
    var gameStatus : Bool = true

    var turn : Int = 0
    var obligation : Int = 1
    var flag : Bool = false
    var claim : Int = 0
    var hold : Bool = true
    var slap : Bool = true
    
    var stack : Stack<Card> = Stack<Card>()
    var penaltyStack : Stack<Card> = Stack<Card>()
    var player : Player = Player()
    var computer : Player = Player()
    var game : PracticeGamePlay = PracticeGamePlay()
    
    var moveCardToStack : SKAction!
    var moveCardsToPlayer : SKAction!
    var moveCardsToComputer : SKAction!
    var rotateCard : SKAction!
    
    var stackDisplay : Array<SKSpriteNode> = []
    var displayRotation : Double = 0.0
    
    //Testing Variables
    var pass = 0
    var count = 0
    
    var playerJacket : SKSpriteNode!
    var computerJacket : SKSpriteNode!
    var cardButton : SKSpriteNode!
    var hand : SKSpriteNode!
    var revHand : SKSpriteNode!
    
    var stats : Array<SKLabelNode> = []
    var playerStats : SKLabelNode!
    var playerPenalty : SKLabelNode!
    var computerStats : SKLabelNode!
    
    override func didMove(to view: SKView) {
        layoutScene()
        distributeCards()
        self.addChild(cardButton)
    }
    
    func layoutScene() {
        //Initialize the Background Color
        self.backgroundColor = UIColor(red: 41.0 / 255, green: 165.0 / 255, blue: 68.0 / 255, alpha: 1)
        //Place all display jackets
        playerJacket = SKSpriteNode(imageNamed: "Jacket")
        playerJacket.size = CGSize(width: frame.size.width / 3.5, height: 1.4 * frame.size.width / 3.5)
        playerJacket.position = CGPoint(x: frame.midX, y: 0)
        computerJacket = SKSpriteNode(imageNamed: "Jacket")
        computerJacket.size = CGSize(width: frame.size.width / 3.5, height: 1.4 * frame.size.width / 3.5)
        computerJacket.position = CGPoint(x: frame.midX, y: frame.size.height)
        cardButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 44))
        cardButton.position = CGPoint(x: frame.midX, y: frame.size.height / 20)
        cardButton.name = "button"
        cardButton.zPosition = 10
        hand = SKSpriteNode(imageNamed: "hand")
        hand.size = CGSize(width: frame.size.width / 2, height: frame.size.height / 3.25)
        hand.name = "hand"
        hand.position = CGPoint(x: frame.midX, y: frame.midY)
        hand.zPosition = 50
        revHand = SKSpriteNode(imageNamed: "hand")
        revHand.size = CGSize(width: frame.size.width / 2, height: frame.size.height / 3.25)
        revHand.name = "hand"
        revHand.position = CGPoint(x: frame.midX, y: frame.midY)
        revHand.zPosition = 50
        revHand.zRotation = CGFloat(Double.pi)
        
        //Initialize important SKActions (moving cards to/from stack)
        moveCardToStack = SKAction.move(to : CGPoint(x : frame.midX, y : frame.midY), duration : 0.25)
        moveCardsToPlayer = SKAction.move(to : CGPoint(x : frame.midX, y : 0), duration : 0.75)
        moveCardsToComputer = SKAction.move(to : CGPoint(x : frame.midX, y : frame.size.height), duration : 0.75)
        
        playerStats = SKLabelNode(fontNamed: "AvenirNext-Bold");
        playerStats.text = "Cards : \(0)";
        playerStats.fontSize = 20
        playerStats.fontColor = SKColor.white
        playerStats.position = CGPoint(x: 8 * frame.size.width / 10, y: frame.size.height / 9)
        addChild(playerStats)
        playerPenalty = SKLabelNode(fontNamed: "AvenirNext-Bold");
        playerPenalty.text = "";
        playerPenalty.fontSize = 20
        playerPenalty.fontColor = SKColor.red
        playerPenalty.position = CGPoint(x: 8 * frame.size.width / 10, y: frame.size.height / 20)
        addChild(playerPenalty)
        computerStats = SKLabelNode(fontNamed: "AvenirNext-Bold");
        computerStats.text = "Cards : \(0)";
        computerStats.fontSize = 20
        computerStats.fontColor = SKColor.white
        computerStats.position = CGPoint(x: 2 * frame.size.width / 10, y: 8 * frame.size.height / 9)
        addChild(computerStats)
        stats.append(playerStats)
        stats.append(computerStats)
        self.run(SKAction.wait(forDuration: 3), completion : {
            self.hold = false
        })
    }
    
    override var isUserInteractionEnabled: Bool {
        get { return true }
        set {  }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Check when to Finish Game (maybe integrate this later procedurally
        if !player.checkStatus() || !computer.checkStatus() {
            //remove cards
            if gameStatus {endScreen()}
            gameStatus = false
            print("Game Completed") //Complete Cards
        }
        //print("Turn = \(turn)")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !gameStatus { return } //Game is over
        if hold { return }
        //Only sense one touch
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        if turn == 0 { //If your turn
            if touchedNodes.count > 0 && touchedNodes[0].name == "button" {
                //self.isPaused = !self.isPaused
                //If button is pressed
                playCardAction()
                return
            }
        }
        //Else always Slap
        if slap { slapAction() }
        //print("Turn = \(turn)")
    }
    
    func endScreen() {
        let endLabel = SKLabelNode(fontNamed: "")
        endLabel.position = CGPoint(x : frame.midX, y : frame.midY)
        endLabel.fontSize = 30
        endLabel.fontColor = SKColor.white
        let background = SKSpriteNode(color: UIColor.red, size: CGSize(width: frame.size.width / 1.5, height: frame.size.height / 3))
        background.position = endLabel.position
        addChild(endLabel)
        if (player.checkStatus()) {
            endLabel.text = "You Win!"
        } else {
            endLabel.text = "Computer Wins"
        }
        background.zPosition = 10
        endLabel.zPosition = 100
        addChild(background)
    }
    
    func distributeCards() {
        //Create and Shuffle Cards
        var cards : Array<Card> = []
        let suite = ["S", "H", "C", "D"]
        for i in 1...13 {
            for s in suite {
                let t = Card(suit : Character(s), val : i)
                cards.append(t)
            }
        }
        cards.shuffle()
        
        let distSpeed = 0.3 //Distribution Speed
        let distCardsToPlayer = SKAction.move(to : CGPoint(x : frame.midX, y : 0), duration : distSpeed)
        let distCardsToComputer = SKAction.move(to : CGPoint(x : frame.midX, y : frame.size.height), duration : 0.5)
        
        //Distribute Cards (with Animation)
        //TODO : Consider using recursion to keep delay before next Cards
        var j = true
        var k = 0.0
        for i in 0...51 {
            let tempJacket = SKSpriteNode(imageNamed: "Jacket")
            tempJacket.size = CGSize(width: frame.size.width / 3.5, height: 1.4 * frame.size.width / 3.5)
            tempJacket.position = CGPoint(x: frame.midX, y: frame.midY)
            self.addChild(tempJacket)
            if j {
                player.appendCards(cardIn : [cards[i]])
                tempJacket.run(SKAction.sequence([SKAction.wait(forDuration: distSpeed * k),distCardsToPlayer]), completion : {
                    self.stats[0].text = "Cards : \(i / 2 + 1)"
                    tempJacket.removeFromParent()
                })
            } else {
                computer.appendCards(cardIn : [cards[i]])
                tempJacket.run(SKAction.sequence([SKAction.wait(forDuration: distSpeed * k),distCardsToComputer]), completion : {
                    self.stats[1].text = "Cards : \(i / 2 + 1)"
                    tempJacket.removeFromParent()
                })
            }
            if i % 2 == 1 {
                k += 0.5
            }
            j = !j
        }
        self.addChild(playerJacket)
        self.addChild(computerJacket)
    }
    
    func checkSlap() -> Bool {
        if self.game.checkRules(stack : self.stack) {
            self.run(SKAction.wait(forDuration: 0.6), completion: {
                if self.game.checkRules(stack : self.stack) {
                    self.addChild(self.revHand)
                    if !self.gameStatus { return }
                    print("Turn = \(self.turn)")
                    print("Computer Slapped")
                    self.obligation = 1
                    self.turn = 1
                    print("Slap Valid obligation of \(self.turn) is \(self.obligation)")
                    //Externally Conduct Slap
                    self.flag = false
                    self.computer.appendCards(cardIn: self.stack.items)
                    self.computer.appendCards(cardIn: self.penaltyStack.items)
                    self.stack.reset()
                    self.penaltyStack.reset()
                    var check = true
                    for item in self.stackDisplay {
                        item.run(self.moveCardsToComputer, completion: {
                            if check { self.revHand.removeFromParent();}
                            check = false
                            item.removeFromParent()
                            self.stats[1].text = "Cards : \(self.computer.size())"
                        })
                    }
                    print("Turn is \(self.turn)")
                    self.playerPenalty.text = ""
                }
            })
            print("Slap Over")
            return true
        } else {
            return false
        }
    }
    
    func falseSlap() {
        if stack.count() <= 0 { return }
        var count = 0
        if (player.size() > 0) { penaltyStack.push(item : player.pop()); count += 1 }
        if (player.size() > 0) { penaltyStack.push(item : player.pop()); count += 1 }
        playerPenalty.text = "-\(penaltyStack.count())"
    }
    
    func slapAction() {
        slap = false
        addChild(hand)
        if !gameStatus { return }
        print("Turn = \(turn)")
        print("Slapped")
        if game.checkRules(stack : self.stack) {
            obligation = 1
            print("Slap Valid obligation of \(turn) is \(obligation)")
            //Externally Conduct Slap
            flag = false
            player.appendCards(cardIn: stack.items)
            player.appendCards(cardIn: penaltyStack.items)
            stack.reset()
            penaltyStack.reset()
            var check = true
            for item in stackDisplay {
                item.run(moveCardsToPlayer, completion: {
                    if check { self.hand.removeFromParent(); self.slap = true }
                    check = false
                    item.removeFromParent()
                    self.stats[0].text = "Cards : \(self.player.size())"
                })
            }
            turn = 0;
            print("Turn is \(turn)")
            playerPenalty.text = ""
        } else {
            hand.run(SKAction.wait(forDuration: 0.5), completion : {
                self.hand.removeFromParent()
                self.slap = true
            })
            falseSlap()
        }
        print("Slap Over")
    }
    
    func turnOver() {
        if !gameStatus { return }
        print("Turn Over")
        if (obligation == 0) {
            if (flag) {
                hold = true
                print("Obligations claimed by Player \(claim)")
                if claim == 0 {
                    player.appendCards(cardIn: stack.items)
                    player.appendCards(cardIn: penaltyStack.items)
                } else {
                    computer.appendCards(cardIn: stack.items)
                    computer.appendCards(cardIn: penaltyStack.items)
                }
                stack.reset()
                penaltyStack.reset()
                flag = false
                turn = claim
                obligation = 1
                obligAnimate(who : claim)
                hold = false
                playerPenalty.text = ""
                return
            }
            obligation = 1
        }
        turn = (turn + 1) % N
        print("Turn Over turn = \(turn) and obligation = \(obligation)")
    }
    
    func obligAnimate(who : Int) {
        var action : SKAction!
        if who == 0 {
            action = moveCardsToPlayer
        } else {
            action = moveCardsToComputer
        }
        for item in self.stackDisplay {
            item.run(action, completion : {
                item.removeFromParent()
                if (who == 0) {
                    self.stats[0].text = "Cards : \(self.player.size())"
                } else {
                    self.stats[1].text = "Cards : \(self.computer.size())"
                }
            })
        }
    }
    
    func playTurn(who : Player) -> Card{
        if !gameStatus { return Card(suit : "S", val : 0) }
        print("Playing Turn")
        let retCard = who.pop()
        //stack.push(item : who.pop())
        //var force = stack.peek().val
        var force = retCard.val
        if (force == 1) { force = 14 }
        if (force > 10) {
            print("Force Activated")
            obligation = force - 10
            flag = true
            claim = turn
            turn = (turn + 1) % N
            return retCard
        }
        obligation -= 1;
        return retCard
    }
    
    func playComputerCardAction() { //Stop playing when slap is done
        //Internally Play Card
        if !gameStatus { return }
        print("Playing Computer Card 1")
        let cardBeingPlayed = SKSpriteNode(imageNamed: "Jacket")
        print("Playing Computer Card 1.5")
        cardBeingPlayed.position = CGPoint(x : frame.midX, y : frame.size.height)
        cardBeingPlayed.size = CGSize(width: frame.size.width / 3.5, height: 1.4 * frame.size.width / 3.5)
        print("Playing Computer Card 1.9")
        //stackDisplay.append(cardBeingPlayed)
        self.addChild(cardBeingPlayed)
        print("Playing Computer Card 2")
        cardBeingPlayed.run(SKAction.wait(forDuration : 1.25), completion : {
            if self.turn == 1 {
                self.hold = true
                print("Playing Computer Card 2.5")
                let played = self.playTurn(who : self.computer)
                if played.val == 0 { return }
                //let played = self.stack.peek()
                print("Computer has played the card \(played.suit ?? Suit.spades)\(played.val)")
                //Externally Play Card + Animation
                let playedCardString = "\(played.suit ?? Suit.spades)\(played.val)"
                cardBeingPlayed.run(SKAction.rotate(byAngle: CGFloat(self.displayRotation), duration: 0.25))
                self.displayRotation += 1.5; if (self.displayRotation > Double.pi) { self.displayRotation -= Double.pi }
                cardBeingPlayed.run(self.moveCardToStack, completion: {
                    self.stats[1].text = "Cards : \(self.computer.size())"
                    cardBeingPlayed.texture = SKTexture(imageNamed: playedCardString)
                    self.stack.push(item : played)
                    self.stackDisplay.append(cardBeingPlayed)
                    self.hold = false
                    if self.obligation == 0 {
                        self.turnOver()
                    }
                    if self.checkSlap() {
                        print("After slap turn is \(self.turn)")
                        self.run(SKAction.wait(forDuration: 0.8), completion: {
                            print("Turn after is \(self.turn)")
                            if self.turn == 1 {
                                self.playComputerCardAction()
                            }
                        })
                    } else {
                        if self.turn == 1 {
                            self.playComputerCardAction()
                        }
                    }
                })
            }
        })
        print("Playing Computer Stopped")
    }
    
    func playCardAction() {
        //Internally Play Card
        if !gameStatus { return }
        hold = true
        let played = playTurn(who : player)
        //let played = stack.peek()
        print("Player has played the card \(played.suit ?? Suit.spades)\(played.val)")
        
        //Externally Play Card
        let playedCardString = "\(played.suit ?? Suit.spades)\(played.val)"
        let cardBeingPlayed = SKSpriteNode(imageNamed: "Jacket")
        cardBeingPlayed.position = CGPoint(x : frame.midX, y : 0)
        cardBeingPlayed.size = CGSize(width: frame.size.width / 3.5, height: 1.4 * frame.size.width / 3.5)
        //stackDisplay.append(cardBeingPlayed)
        self.addChild(cardBeingPlayed)
        //Animate
        cardBeingPlayed.run(SKAction.rotate(byAngle: CGFloat(displayRotation), duration: 0.25))
        displayRotation += 1.5; if (displayRotation > Double.pi) { displayRotation -= Double.pi }
        cardBeingPlayed.run(moveCardToStack, completion: {
            cardBeingPlayed.texture = SKTexture(imageNamed: playedCardString)
            self.stats[0].text = "Cards : \(self.player.size())"
            self.stack.push(item : played)
            self.stackDisplay.append(cardBeingPlayed)
            self.hold = false
            if self.obligation == 0 {
                self.turnOver()
            }
            if self.checkSlap() {
                print("After slap turn is \(self.turn)")
                self.run(SKAction.wait(forDuration: 0.1), completion: {
                    if self.turn == 1 {
                        self.playComputerCardAction()
                    }
                })
            } else {
                if self.turn == 1 {
                    self.playComputerCardAction()
                }
            }
        })
    }

}
