//
//  MultiGameScene.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 6/1/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class MultiGameScene : SKScene {
    
    var gameStatus : Bool = false
    var player : Player = Player()
    var opponent : Player = Player()
    
    var playerJacket : SKSpriteNode!
    var opponentJacket : SKSpriteNode!
    var cardButton : SKSpriteNode!
    var hand : SKSpriteNode!
    var revHand : SKSpriteNode!
    var hands : Array<SKSpriteNode> = []
    
    var stats : Array<SKLabelNode> = []
    var penalty : Array<SKLabelNode> = []
    var playerStats : SKLabelNode!
    var playerPenalty : SKLabelNode!
    var opponentStats : SKLabelNode!
    var opponentPenalty : SKLabelNode!
    
    var stackDisplay : Array<SKSpriteNode> = []
    var displayRotation : Double = 0.0
    
    var actions : Array<SKAction> = []
    var moveCardToStack : SKAction!
    var moveCardsToPlayer : SKAction!
    var moveCardsToOpponent : SKAction!
    var rotateCard : SKAction!
    
    var slapAllowed : Bool = false
    var hold : Bool = true
    var turn : Int = 0
    var id : Int = -1
    
    override func didMove(to view: SKView) {
        socket.on("id") { data, ack in
            if let json = data as? [[String: Any]] {
                self.id = json[0]["id"] as! Int
                if self.id != 0 {
                    self.actions.swapAt(0, 1)
                    self.stats.swapAt(0, 1)
                    self.hands.swapAt(0, 1)
                    self.penalty.swapAt(0, 1)
                }
            }
        }
        layoutScene()
        distributeCards()
        startListening()
        slapAllowed = true
    }
    
    override var isUserInteractionEnabled: Bool {
        get { return true }
        set {  }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (!gameStatus || hold) { return }
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        //if turn == 0 {
        if touchedNodes.count > 0 && touchedNodes[0].name == "button" {
            self.playCardAction()
            return
        }
        //}
        if slapAllowed {
            self.slapAction()
            socket.emit("playCard")
        }
        //Pause Button: self.isPaused = !self.isPaused
    }
    
    func startListening() {
        socket.on("cardPlayed") { data, ack in
            if let json = data as? [[String: Any]] {
                print(json[0])
                let cardPlayer : Int = json[0]["player"] as! Int
                let card : String = json[0]["card"] as! String
                let nextTurn : Int = json[0]["turn"] as! Int
                let zero : Int = json[0]["zero"] as! Int
                let one : Int = json[0]["one"] as! Int
                let collect : Int = json[0]["collect"] as! Int
                self.hold = true
                let cardBeingPlayed = SKSpriteNode(imageNamed: "Jacket")
                if (cardPlayer == self.id) {
                    cardBeingPlayed.position = CGPoint(x : self.frame.midX, y : 0)
                } else {
                    cardBeingPlayed.position = CGPoint(x : self.frame.midX, y : self.frame.size.height)
                }
                cardBeingPlayed.size = CGSize(width: self.frame.size.width / 3.5, height: 1.4 * self.frame.size.width / 3.5)
                self.addChild(cardBeingPlayed)
                cardBeingPlayed.run(SKAction.rotate(byAngle: CGFloat(self.displayRotation), duration: 0.25))
                self.displayRotation += 1.5
                if (self.displayRotation > Double.pi) {
                    self.displayRotation -= Double.pi
                }
                cardBeingPlayed.run(self.moveCardToStack, completion: {
                    cardBeingPlayed.texture = SKTexture(imageNamed: card)
                    self.stackDisplay.append(cardBeingPlayed)
                    self.stats[0].text = "Cards: \(zero)"
                    self.stats[1].text = "Cards: \(one)"
                    self.turn = nextTurn
                    if (collect != -1) {
                        self.penalty[0].text = ""
                        self.penalty[1].text = ""
                        for item in self.stackDisplay {
                            item.run(self.actions[collect], completion: {
                                item.removeFromParent()
                                self.stats[0].text = "Cards: \(zero)"
                                self.stats[1].text = "Cards: \(one)"
                                self.hold = false
                            })
                        }
                    } else {
                        self.hold = false
                    }
                })
            }
        }
        socket.on("stackSlapped") { data, ack in
            self.slapAllowed = false
            if let json = data as? [[String: Any]] {
                let slapPlayer : Int = json[0]["slapper"] as! Int
                let outcome : Bool = json[0]["outcome"] as! Bool
                let nextTurn : Int = json[0]["turn"] as! Int
                let zero : Int = json[0]["zero"] as! Int
                let one : Int = json[0]["one"] as! Int
                //let winner : Int = Int(json[0]["winner"]!)!
                self.addChild(self.hands[slapPlayer])
                self.hand.run(SKAction.wait(forDuration: 0.5), completion : {
                    self.hands[slapPlayer].removeFromParent()
                    self.slapAllowed = true
                    self.stats[0].text = "Cards: \(zero)"
                    self.stats[1].text = "Cards: \(one)"
                })
                if outcome == false {
                    if self.penalty[slapPlayer].text == "" {
                        self.penalty[slapPlayer].text = "-2"
                    } else {
                        self.penalty[slapPlayer].text = String(Int(self.penalty[slapPlayer].text!)! - 2)
                    }
                } else {
                    self.penalty[0].text = ""
                    self.penalty[1].text = ""
                    for item in self.stackDisplay {
                        item.run(self.actions[slapPlayer], completion: {
                            item.removeFromParent()
                        })
                    }
                }
                self.turn = nextTurn
            }
        }
    }
    
    func playCardAction() {
        socket.emit("playCard")
    }
    
    func slapAction() {
        socket.emit("slapStack")
    }
    
    func layoutScene() {
        self.backgroundColor = UIColor(red: 41.0 / 255, green: 165.0 / 255, blue: 68.0 / 255, alpha: 1)
        playerJacket = SKSpriteNode(imageNamed: "Jacket")
        playerJacket.size = CGSize(width: frame.size.width / 3.5, height: 1.4 * frame.size.width / 3.5)
        playerJacket.position = CGPoint(x: frame.midX, y: 0)
        opponentJacket = SKSpriteNode(imageNamed: "Jacket")
        opponentJacket.size = CGSize(width: frame.size.width / 3.5, height: 1.4 * frame.size.width / 3.5)
        opponentJacket.position = CGPoint(x: frame.midX, y: frame.size.height)
        cardButton = SKSpriteNode(color: SKColor.red, size: CGSize(width: 140, height: 60))
        cardButton.position = CGPoint(x: frame.midX, y: frame.size.height / 20)
        cardButton.name = "button"
        cardButton.zPosition = 10
        self.addChild(cardButton)
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
        hands.append(hand)
        hands.append(revHand)
        
        //Initialize important SKActions (moving cards to/from stack)
        moveCardToStack = SKAction.move(to : CGPoint(x : frame.midX, y : frame.midY), duration : 0.25)
        moveCardsToPlayer = SKAction.move(to : CGPoint(x : frame.midX, y : 0), duration : 0.75)
        moveCardsToOpponent = SKAction.move(to : CGPoint(x : frame.midX, y : frame.size.height), duration : 0.75)
        actions.append(moveCardsToPlayer)
        actions.append(moveCardsToOpponent)
        
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
        opponentStats = SKLabelNode(fontNamed: "AvenirNext-Bold");
        opponentStats.text = "Cards : \(0)";
        opponentStats.fontSize = 20
        opponentStats.fontColor = SKColor.white
        opponentStats.position = CGPoint(x: 2 * frame.size.width / 10, y: 8 * frame.size.height / 9)
        addChild(opponentStats)
        opponentPenalty = SKLabelNode(fontNamed: "AvenirNext-Bold");
        opponentPenalty.text = "";
        opponentPenalty.fontSize = 20
        opponentPenalty.fontColor = SKColor.red
        opponentPenalty.position = CGPoint(x: 2 * frame.size.width / 10, y: 19 * frame.size.height / 20)
        addChild(opponentPenalty)
        stats.append(playerStats)
        stats.append(opponentStats)
        penalty.append(playerPenalty)
        penalty.append(opponentPenalty)
        self.run(SKAction.wait(forDuration: 3), completion : {
            self.gameStatus = true
            self.hold = false
        })
    }
    
    func distributeCards() {
        
        let distSpeed = 0.3 //Distribution Speed
        let distCardsToPlayer = SKAction.move(to : CGPoint(x : frame.midX, y : 0), duration : distSpeed)
        let distCardsToOpponent = SKAction.move(to : CGPoint(x : frame.midX, y : frame.size.height), duration : 0.5)
        
        //Distribute Cards (with Animation)
        var j = true
        var k = 0.0
        for i in 0...51 {
            let tempJacket = SKSpriteNode(imageNamed: "Jacket")
            tempJacket.size = CGSize(width: frame.size.width / 3.5, height: 1.4 * frame.size.width / 3.5)
            tempJacket.position = CGPoint(x: frame.midX, y: frame.midY)
            self.addChild(tempJacket)
            if j {
                tempJacket.run(SKAction.sequence([SKAction.wait(forDuration: distSpeed * k),distCardsToPlayer]), completion : {
                    self.stats[0].text = "Cards : \(i / 2 + 1)"
                    tempJacket.removeFromParent()
                })
            } else {
                tempJacket.run(SKAction.sequence([SKAction.wait(forDuration: distSpeed * k),distCardsToOpponent]), completion : {
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
        self.addChild(opponentJacket)
    }
    
}

