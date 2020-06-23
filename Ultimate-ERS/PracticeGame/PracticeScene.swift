//
//  PracticeScene.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/20/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import SpriteKit

//ClockWise vs CounterClockwise Customization

class PracticeScene : SKScene {
    
    var turn : Int = -1
    var N : Int = 4 //IDK How to get this (Maybe Customization)
    var ERS : ERSGame!
    var obg : Bool!
    
    var locked : Bool = true
    
    var deckToStack : SKAction!
    var stackToDeck : Array<SKAction>!
    
    var rotationFactor : Double = 0.0
    var cardRotation : SKAction!
    
    var deckLocations : Array<CGPoint>!
    
    var stackDisplay : Array<SKSpriteNode>!//Maybe Penalty Display
    var deckJacket : Array<SKSpriteNode>!
    var hands : Array<SKSpriteNode>!
    var cardStats : Array<SKLabelNode>!
    var penaltyStats : Array<SKLabelNode>!
    var labels : Array<SKLabelNode>!
    
    var waitCollect : SKAction!
    
    var thread : UInt64!
    
    override var isUserInteractionEnabled: Bool {
        get {
            return !locked
        }
        set {  }
    }
    
    override func didMove(to view: SKView) {
        print("Loaded View")
        deckLocations = []
        stackToDeck = []
        stackDisplay = []
        deckJacket = []
        hands = []
        cardStats = []
        penaltyStats = []
        labels = []
        ERS = ERSGame(difficulty : computerDifficulty,
                              numPlayers : N, manObg : manualObligation)
        configureSettings()
        layoutScene()
        distributeCards()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //CHECK END #PROBABLY DONT NEED TO
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if locked { print("User Interaction Prohibited"); return }
        print("User Has Interacted")
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        if touchedNodes.count > 0 {
            if touchedNodes[0].name == "pause" {
                //pause stuff
                print("User has paused the Game")
            } else if touchedNodes[0].name == "human" && turn == 0 {
                print("User has tapped Jacket")
                thread += 1
                //print("New Thread \(thread)")
                playTurn(curr : thread)
                return
            }
        }
        print("User has slapped")
        slapAction(player : 0, curr : thread)
    }
    
    func configureSettings() {
        obg = manualObligation
    }
    
    func layoutScene() {
        //change background to image
        self.backgroundColor = UIColor(red: 41.0 / 255, green: 165.0 / 255, blue: 68.0 / 255, alpha: 1)
        
        for i in 0..<N {
            deckJacket.append(SKSpriteNode(imageNamed : "Jacket"))
            deckJacket[i].size = CGSize(width: frame.size.width / 3.5,
                                        height: 1.4 * frame.size.width / 3.5)
            deckJacket[i].zRotation = CGFloat(Double(i) * (Double.pi / 2))
            hands.append(SKSpriteNode(imageNamed : "Hand"))
            hands[i].position = CGPoint(x: frame.midX, y: frame.midY)
            hands[i].zPosition = 50
            hands[i].size = CGSize(width: frame.size.width / 2,
                                   height: frame.size.height / 3.25)
            hands[i].zRotation = CGFloat(Double(i) * (Double.pi / 2))
            cardStats.append(SKLabelNode()) //label # cards
            penaltyStats.append(SKLabelNode()) //label # penalty
            labels.append(SKLabelNode()) //label => Computer #
        }
        
        deckJacket[0].name = "human"
        deckJacket[0].zPosition = 100
        deckToStack = SKAction.move(to : CGPoint(x : frame.midX, y : frame.midY), duration : 0.25)
        
        deckLocations.append(CGPoint(x : frame.midX, y : 0))
        if N > 2 {
            deckLocations.append(CGPoint(x : frame.size.width, y : frame.midY))
            deckLocations.append(CGPoint(x : frame.midX, y : frame.size.height))
        } else {
            deckLocations.append(CGPoint(x : frame.midX, y : frame.size.height))
            deckLocations.append(CGPoint(x : frame.size.width, y : frame.midY))
        }
        deckLocations.append(CGPoint(x : 0, y : frame.midY))
        
        for i in 0..<N {
            deckJacket[i].position = deckLocations[i]
            stackToDeck.append(SKAction.move(to : deckLocations[i], duration : 0.75))
        }
        waitCollect = SKAction.wait(forDuration : 0.75)
        print("Scene has been Layed Out")
    }
    
    func distributeCards() {
        //Animate Cards to both ends (Customizable)
        //Move Decks (Thick Stacks) to each player
        var attach = false
        for i in 0..<52 {
            let tempCard = SKSpriteNode(imageNamed : "Jacket")
            tempCard.position = CGPoint(x: frame.midX, y: frame.midY)
            tempCard.size = CGSize(width: frame.size.width / 3.5,
                                   height: 1.4 * frame.size.width / 3.5)
            addChild(tempCard)
            tempCard.run(stackToDeck[i % N], completion : {
                if !attach {
                    for j in self.deckJacket {
                        self.addChild(j)
                    }
                    attach = true
                }
                tempCard.removeFromParent()
            })
        }
        let tempCard = SKSpriteNode(imageNamed : "Jacket")
        tempCard.position = CGPoint(x: frame.midX, y: frame.midY)
        tempCard.size = CGSize(width: frame.size.width / 3.5,
                               height: 1.4 * frame.size.width / 3.5)
        addChild(tempCard)
        tempCard.run(stackToDeck[(52-1) % N], completion : {
            tempCard.removeFromParent()
            print("Cards have been distributed. Starting Game...")
            self.randTurn()
        })
    }
    
    func randTurn() {
        turn = Int.random(in: 0..<N)
        print("First player is: ", turn)
        print("Rand Locked")
        locked = false
        thread = 0
        turnRouter(curr : thread)
    }
    
    func turnRouter(curr : UInt64) {
        //if locked { return }
        if curr != self.thread { print("Thread Mismatch 1"); return }
        print("--------------------------")
        if turn != 0 {
            print("Routing to player", turn, "after delay")
            self.run(SKAction.wait(forDuration : 0.75), completion: {
                //if self.locked { return }
                //self.locked = false //Experimental
                if curr != self.thread { print("Thread Mismatch 2"); return }
                self.playTurn(curr : curr)
            })
        }
    }
    
    func endTurn(curr : UInt64) {
        if self.locked { print("End Turn Locked"); return}
        if curr != thread { print("Thread Mismatch"); return}
        self.run(SKAction.wait(forDuration : 0.75), completion : { //Customize
            if self.locked { print("End Turn Locked"); return}
            if curr != self.thread { print("Thread Mismatch 5"); return }
            print("Additional Wait Time Completed")
            let collector = self.ERS.obgCollector()
            if !self.obg && collector != -1 {
                print("Automatic Obligation Collection")
                self.collectAction(player : collector, curr : curr)
            } else if self.ERS.checkPattern() {
                print("Slap Detected, Computer Slap Sequence")
                let rand = Int.random(in : 1..<self.N)
                self.slapAction(player : rand, curr : curr)
            } else {
                print("Nothing Detected. Proceeding to Routing")
                self.checkWin()
                //self.thread += 1
                //print("New Thread \(self.thread)")
                self.turnRouter(curr : self.thread)
            }
        })
    }
    
    func playTurn(curr : UInt64) {
        if locked { print("Turn Prohibited"); return }
        if curr != self.thread { print("Thread Mismatch 3"); return }
        print("Player", turn, "is playing a card")
        print("Turn Locked")
        locked = true
        let card = ERS.playCard(player : turn)
        let cardSprite = SKSpriteNode(imageNamed : "Jacket")
        cardSprite.position = deckLocations[turn]
        cardSprite.size = CGSize(width: frame.size.width / 3.5,
                               height: 1.4 * frame.size.width / 3.5)
        addChild(cardSprite)
        //Position
        cardSprite.run(SKAction.rotate(byAngle : CGFloat(rotationFactor), duration: 0.25))
        rotationFactor += 1.5
        if rotationFactor > Double.pi {
            rotationFactor -= Double.pi
        }
        cardSprite.run(deckToStack, completion: {
            if curr != self.thread { print("Thread Mismatch 4"); return }
            cardSprite.texture = SKTexture(imageNamed: card.tostring())
            print("Card Played is", card.tostring())
            self.stackDisplay.append(cardSprite)
            print("Turn Unlocked")
            self.locked = false
            if !self.ERS.underObg(player : self.turn) {
                self.turn = (self.turn + 1) % self.N
            } else {
                print("Under Obligation. Repeat Turn")
            }
            let collector = self.ERS.obgCollector()
            if self.obg && collector != -1 {
                print("Automatic Obligation Collection")
                self.collectAction(player : collector, curr : curr)
            }
            self.endTurn(curr : curr)
        })
    }
    
    func slapAction(player : Int, curr : UInt64) {
        if locked { print("Slap Prohibited"); return }
        if curr != self.thread { print("Thread Mismatch 6"); return }
        print("Player", player, "has slapped the stack")
        print("Slap Locked")
        locked = true
        addChild(hands[player])
        self.run(SKAction.wait(forDuration : 0.25), completion : {
            //if curr != self.thread { print("Thread Mismatch 7"); return }
            self.hands[player].removeFromParent()
            if self.ERS.slap(player : player) {
                
                print("Slap is Valid. Collecting Cards")
                //update stats
                for item in self.stackDisplay {
                    item.run(self.stackToDeck[player], completion : {
                        //update cards
                        item.removeFromParent()
                    })
                }
                self.stackDisplay = []
                self.run(self.waitCollect, completion : {
                    if curr != self.thread { print("Thread Mismatch 8"); return }
                    print("Collection Completed. Proceeding with Routing")
                    self.turn = player
                    self.checkWin()
                    print("Slap Unlocked")
                    self.locked = false
                    self.thread += 1
                    print("Slap: New Thread \(self.thread)")
                    self.turnRouter(curr : self.thread)
                    print("Slap Action Problem After Turn Router")
                })
            } else {
                print("Slap is Invalid. Penalty Issued")
                //Penalize player
                self.checkWin()
                print("Slap Unlocked")
                self.locked = false
                self.endTurn(curr : curr)
            }
        })
    }
    
    func collectAction(player : Int, curr : UInt64) {
        if locked { print("Collect Prohibited"); return }
        if curr != self.thread { print("Thread Mismatch 9"); return }
        print("Player", player, "is collecting obligation")
        print("Collect Locked")
        locked = true
        ERS.collectCards(receiver : player)
        for item in stackDisplay {
            item.run(stackToDeck[player], completion : {
                item.removeFromParent()
            })
        }
        self.stackDisplay = []
        self.run(waitCollect, completion : {
            print("Obligation Collected. Proceeding with Routing")
            if curr != self.thread { print("Thread Mismatch 10"); return }
            self.turn = player
            self.checkWin()
            print("Collect Unlocked")
            self.locked = false
            self.thread += 1
            print("Collect: New Thread \(self.thread)")
            self.turnRouter(curr : self.thread)
        })
    }
    
    func checkWin() {
        
    }
    
    /**
     CHECK WIN {
        IF WIN -> {
            ANIMATE: => WAIT
                LAUNCH END SCREEN
            WAIT FOR INPUT TO LEAVE
        }
     }
     */
    
}
