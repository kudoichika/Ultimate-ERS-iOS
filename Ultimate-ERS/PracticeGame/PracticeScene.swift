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
    var N : Int = 4 //IDK How to get this (Maybe Customization)
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
        randTurn() // after completion  of distribute cards
    }
    
    override func update(_ currentTime: TimeInterval) {
        //CHECK END #PROBABLY DONT NEED TO
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //PAUSE BUTTON
        //IF CARD & TURN -> PLAY
        //ELSE -> SLAP
    }
    
    func layoutScene() {
        //change background to image
        self.backgroundColor = UIColor(red: 41.0 / 255, green: 165.0 / 255, blue: 68.0 / 255, alpha: 1)
        for _ in 0..<N {
            deckJacket.append(SKSpriteNode()) //image
            hands.append(SKSpriteNode()) //image (orientation matters)
            cardStats.append(SKLabelNode()) //label # cards
            penaltyStats.append(SKLabelNode()) //label # penalty
            labels.append(SKLabelNode()) //label => Computer #
        }
        if N > 2 {
            //positioning for #3
            //SKAction
            if N > 3 {
                //positioning for #4
                //SKAction
            }
        } else {
            //positioning for #1 & #2
            //SKAction
        }
    }
    
    func distributeCards() {
        //Animate Cards to both ends (Customizable)
        //Remove Cards Except one
        //Move Decks (Thick Stacks) to each player
        for i in 0..<52-1 {
            let tempCard = SKSpriteNode()
            tempCard.run(stackToDeck[i % N], completion : {
                //remove from parent
            })
        }
    }
    
    func randTurn() {
        turn = Int.random(in: 0..<N)
        locked = false
        turnRouter()
    }
    
    func turnRouter() {
        if turn != 0 {
            //Wait for a while before playing (more natural) [can be customized]
            self.run(SKAction.wait(forDuration : 1.25), completion: {
                self.playTurn()
            })
        }
    }
    
    func playTurn() {
        locked = true
        let card = ERS.playCard(player : turn)
        let cardSprite = SKSpriteNode()
        //Position + Image at turn
        cardSprite.run(SKAction.rotate(byAngle: CGFloat(rotationFactor), duration: 0.25))
        rotationFactor += 1.5
        if rotationFactor > Double.pi {
            rotationFactor -= Double.pi
        }
        cardSprite.run(deckToStack, completion: {
            //Flip Card
            self.stackDisplay.append(cardSprite)
            self.locked = false
            self.turn = (self.turn + 1) % self.N
            let collector = self.ERS.obgCollector()
            if self.obg && collector != -1 {
                self.collectAction(player : ERS.obgCollector())
            }
            self.run(SKAction.wait(forDuration : 0.5), completion : { //Customize
                if !obg && collector != -1 {
                    self.collectAction(player : collector)
                } else if self.ERS.checkPattern() {
                    let rand = Int.random(in : 1..<self.N)
                    self.slapAction(player : rand)
                } else {
                    self.turnRouter()
                }
            })
        })
    }
    
    func slapAction(player : Int) {
        locked = true
        //put hand
        self.run(SKAction.wait(forDuration : 0.5), completion : {
            //remove hands
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
                self.locked = false
            }
        })
    }
    
    func collectAction(player : Int) {
        locked = true
        ERS.collectObg(player : player)
        for item in stackDisplay {
            item.run(stackToDeck[player], completion : {
                item.removeFromParent()
                self.turn = player
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
