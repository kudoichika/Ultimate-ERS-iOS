//
//  PracticeScene.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/20/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import SpriteKit

class PracticeScene : SKScene {
    
    var turn : Int = -1
    var N : Int = 2 //IDK How to get this (Maybe Customization)
    var ERS : ERSGame!
    var obg : Bool!
    
    var locked : Bool = true
    
    var deckToStack : SKAction!
    var stackToDeck : Array<SKAction>!
    
    var rotationFactor : Double!
    var cardRotation : SKAction!
    
    var stackDisplay : Array<SKSpriteNode>! //Maybe Penalty Display
    var deckJacket : Array<SKSpriteNode>!
    var hands : Array<SKSpriteNode>!
    var cardStats : Array<SKLabelNode>!
    var penaltyStats : Array<SKLabelNode>!
    var labels : Array<SKLabelNode>!
    
    override var isUserInteractionEnabled: Bool {
        get {
            return !locked
        }
        set {  }
    }
    
    override func didMove(to view: SKView) {
        obg = manualObligation
        ERS = ERSGame(difficulty : computerDifficulty,
                              numPlayers : N, manObg : manualObligation)
        layoutScene()
        distributeCards()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //CHECK END #PROBABLY DONT NEED TO
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        if touchedNodes.count > 0 {
            if touchedNodes[0].name == "pause" {
                //pause stuff
                print("User has paused the Game")
            } else if touchedNodes[0].name == "human" {
                playTurn()
                return
            }
        }
        slapAction(player : 0)
    }
    
    func layoutScene() {
        //change background to image
        self.backgroundColor = UIColor(red: 41.0 / 255, green: 165.0 / 255, blue: 68.0 / 255, alpha: 1)
        for i in 0..<N {
            deckJacket.append(SKSpriteNode(imageNamed : "Jacket"))
            deckJacket[i].position = CGPoint(x: frame.midX, y: 0)
            deckJacket[i].size = CGSize(width: frame.size.width / 3.5,
                                        height: 1.4 * frame.size.width / 3.5)
            hands.append(SKSpriteNode(imageNamed : "Hand")) //orientation matters
            hands[i].position = CGPoint(x: frame.midX, y: frame.midY)
            hands[i].zPosition = 50
            hands[i].size = CGSize(width: frame.size.width / 2,
                                   height: frame.size.height / 3.25)
            cardStats.append(SKLabelNode()) //label # cards
            penaltyStats.append(SKLabelNode()) //label # penalty
            labels.append(SKLabelNode()) //label => Computer #
        }
        deckJacket[0].name = "human"
        deckJacket[0].zPosition = 100
        deckToStack = SKAction.move(to : CGPoint(x : frame.midX, y : frame.midY), duration : 0.25)
        if N > 2 {
            //positioning of stats / decks //rotate maybe?
            stackToDeck.append(SKAction.move(to : CGPoint(x : frame.midX, y : 0), duration : 0.75))
            stackToDeck.append(SKAction.move(to : CGPoint(x : frame.midX, y : frame.size.height), duration : 0.75))
            stackToDeck.append(SKAction.move(to : CGPoint(x : 0, y : frame.midY), duration : 0.75))
            if N > 3 {
                //positioning of stats / decks //rotate maybe?
                stackToDeck.append(SKAction.move(to : CGPoint(x : frame.size.width, y : frame.midY), duration : 0.75))
            }
        } else {
            //positioning of stats / decks
            stackToDeck.append(SKAction.move(to : CGPoint(x : frame.midX, y : 0), duration : 0.75))
            stackToDeck.append(SKAction.move(to : CGPoint(x : frame.midX, y : frame.size.height), duration : 0.75))
        }
        print("Scene has been Layed Out")
    }
    
    func distributeCards() {
        //Animate Cards to both ends (Customizable)
        //Move Decks (Thick Stacks) to each player
        var attach = false
        for i in 0..<52 {
            let tempCard = SKSpriteNode()
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
        let tempCard = SKSpriteNode()
        tempCard.run(stackToDeck[(52-1) % N], completion : {
            tempCard.removeFromParent()
            print("Cards have been distributed. Starting Game...")
            self.randTurn()
        })
    }
    
    func randTurn() {
        turn = Int.random(in: 0..<N)
        print("First player is: ", turn)
        locked = false
        turnRouter()
    }
    
    func turnRouter() {
        if turn != 0 {
            self.run(SKAction.wait(forDuration : 1.25), completion: {
                self.playTurn()
            })
        }
    }
    
    func playTurn() {
        print("Player", turn, "is playing a card")
        locked = true
        let card = ERS.playCard(player : turn)
        let cardSprite = SKSpriteNode(imageNamed : "Jacket")
        addChild(cardSprite)
        //Position
        cardSprite.run(SKAction.rotate(byAngle : CGFloat(rotationFactor), duration: 0.25))
        rotationFactor += 1.5
        if rotationFactor > Double.pi {
            rotationFactor -= Double.pi
        }
        cardSprite.run(deckToStack, completion: {
            cardSprite.texture = SKTexture(imageNamed: card.tostring())
            self.stackDisplay.append(cardSprite)
            self.locked = false
            self.turn = (self.turn + 1) % self.N
            let collector = self.ERS.obgCollector()
            if self.obg && collector != -1 {
                self.collectAction(player : self.ERS.obgCollector())
            }
            self.run(SKAction.wait(forDuration : 0.5), completion : { //Customize
                if !self.obg && collector != -1 {
                    self.collectAction(player : collector)
                } else if self.ERS.checkPattern() {
                    let rand = Int.random(in : 1..<self.N)
                    self.slapAction(player : rand)
                } else {
                    self.checkWin()
                    self.turnRouter()
                }
            })
        })
    }
    
    func slapAction(player : Int) {
        print("Player", player, "has slapped the stack")
        locked = true
        addChild(hands[0])
        self.run(SKAction.wait(forDuration : 0.5), completion : {
            hands[0].removeFromParent()
            if ERS.slap(player : player) {
                //update stats
                for item in self.stackDisplay {
                    item.run(self.stackToDeck[player], completion : {
                        //update cards
                        item.removeFromParent()
                        self.locked = false
                    })
                }
                self.turn = player
            } else {
                //Penalize player
                self.checkWin()
                self.locked = false
            }
        })
    }
    
    func collectAction(player : Int) {
        print("Player", player, "is collected obligation")
        locked = true
        ERS.collectObg()
        for item in stackDisplay {
            item.run(stackToDeck[player], completion : {
                item.removeFromParent()
                self.turn = player
                self.checkWin()
                self.locked = false
            })
        }
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
