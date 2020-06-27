//
//  PracticeGame.swift
//  Ultimate-ERS
//
//  Created by Kudo on 6/25/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation
import SpriteKit

class PracticeGame {
    
    var gameNode : SKNode!
    
    var frameSize : CGSize!
    var frameMidX : CGFloat!
    var frameMidY : CGFloat!
    
    var turn : Int = -1
    var N : Int = 4
    var ers : ERS!
    var obg : Bool!
    
    var locked : Bool = true
    
    var deckToStack : SKAction!
    var stackToDeck : Array<SKAction>!
    var waitCollect : SKAction!
    
    var rotationFactor : Double = 0.0
    var cardRotation : SKAction!
    
    var deckLocations : Array<CGPoint>!
    var statLocations : Array<CGPoint>!
    
    var pauseButton : SKSpriteNode!
    
    var stackDisplay : Array<SKSpriteNode>!
    var deckJacket : Array<SKSpriteNode>!
    var hands : Array<SKSpriteNode>!
    var cardStats : Array<SKLabelNode>!
    //Replace with penalty number
    var penaltyStat : SKLabelNode!
    var labels : Array<SKLabelNode>!
    
    var thread : UInt64!
    
    var cardToDeckTime : Double!
    var cardToStackTime : Double!
    var turnBufferTime : Double!
    var computerActionTime : Double!
    var handVisibleTime : Double!
    
    init(frame : CGSize, numPlayers : Int) {
        frameSize = frame
        frameMidX = frameSize.width / 2
        frameMidY = frameSize.height / 2
        N = numPlayers
        create()
    }
    
    func isPaused() -> Bool {
        //Replace with true pause (for background screens)
        return gameNode.isPaused
    }
    
    func setPause(_ state : Bool) {
        gameNode.isPaused = state
    }
    
    func userTouched(node : SKNode) {
        /*if touchedNodes[0].name == "pause" {
            openPauseScreen()
            return
        } else*/
        if node.name == "human" && turn == 0 {
            print("User has tapped Jacket")
            thread += 1
            playTurn(curr : thread)
            return
        } else {
            print("User has slapped")
            slapAction(player : 0, curr : thread)
        }
    }
    
    func addComponents(_ parent : SKNode) {
        parent.addChild(gameNode)
    }
    
    func removeComponents() {
        gameNode.removeFromParent()
    }
    
    func create() {
        deckLocations = []
        statLocations = []
        stackToDeck = []
        stackDisplay = []
        deckJacket = []
        hands = []
        cardStats = []
        labels = []
        ers = ERS(difficulty : computerDifficulty,
                              numPlayers : N, manObg : manualObligation)
        configureSettings()
        layoutScene()
        distributeCards()
    }
    
    func configureSettings() {
        obg = manualObligation
        //Default 0.75s
        cardToDeckTime = 0.75
        turnBufferTime = 0.75
        computerActionTime = 0.75
        //Default 0.25s
        cardToStackTime = 0.25
        handVisibleTime = 0.25
    }
    
    func layoutScene() {
        
        gameNode = SKNode()
        
        deckLocations.append(CGPoint(x : frameMidX, y : 0))
        statLocations.append(CGPoint(x : 0.75 * frameSize.width, y : 0.075 * frameSize.height))
        if N > 2 {
            deckLocations.append(CGPoint(x : frameSize.width, y : frameMidY))
            deckLocations.append(CGPoint(x : frameMidX, y : frameSize.height))
            statLocations.append(CGPoint(x : 0.9 * frameSize.width, y : 0.6 * frameSize.height))
            statLocations.append(CGPoint(x : 0.25 * frameSize.width, y : 0.9 * frameSize.height))
        } else {
            deckLocations.append(CGPoint(x : frameMidX, y : frameSize.height))
            deckLocations.append(CGPoint(x : frameSize.width, y : frameMidY))
        }
        deckLocations.append(CGPoint(x : 0, y : frameMidY))
        statLocations.append(CGPoint(x : 0.1 * frameSize.width, y : 0.35 * frameSize.height))
        
        for i in 0..<N {
            deckJacket.append(SKSpriteNode(imageNamed : "Game/Jacket"))
            deckJacket[i].size = CGSize(width: frameSize.width / 3.5,
                                        height: 1.4 * frameSize.width / 3.5)
            deckJacket[i].position = deckLocations[i]
            deckJacket[i].zRotation = CGFloat(Double(i) * (Double.pi / 2))
            deckJacket[i].zPosition = 75
            
            hands.append(SKSpriteNode(imageNamed : "Game/Hand"))
            hands[i].position = CGPoint(x: frameMidX, y: frameMidY)
            hands[i].zPosition = 50
            hands[i].size = CGSize(width: frameSize.width / 2,
                                   height: frameSize.height / 3.25)
            hands[i].zRotation = CGFloat(Double(i) * (Double.pi / 2))
            
            cardStats.append(SKLabelNode())
            cardStats[i].fontName = "AvenirNext-Bold"
            cardStats[i].position = statLocations[i]
            
            labels.append(SKLabelNode()) //label => Computer #
            
            stackToDeck.append(SKAction.move(to : deckLocations[i], duration : cardToDeckTime))
        }
        
        deckJacket[0].name = "human"
        deckToStack = SKAction.move(to : CGPoint(x : frameMidX, y : frameMidY), duration : cardToStackTime)
        penaltyStat = SKLabelNode()
        penaltyStat.position = CGPoint(x : frameMidX, y : 0.65 * frameSize.height)
        penaltyStat.fontColor = UIColor.red
        penaltyStat.text = ""
        penaltyStat.fontName = "AvenirNext-Bold"
        gameNode.addChild(penaltyStat)
        
        waitCollect = SKAction.wait(forDuration : cardToDeckTime)
        print("Scene has been Layed Out")
    }
    
    func updateStats() {
        let numCards = self.ers.getNumCards()
        for i in 0..<self.N {
            self.cardStats[i].text = String(numCards[i])
        }
    }
    
    func updatePenalty() {
        let penalty = self.ers.getPenalities()
        if penalty == 0 {
            self.penaltyStat.text = ""
        } else {
            self.penaltyStat.text = "+" + String(penalty)
        }
    }
    
    func distributeCards() {
        var attach = false
        for i in 0..<52 {
            let tempCard = SKSpriteNode(imageNamed : "Game/Jacket")
            tempCard.position = CGPoint(x: frameMidX, y: frameMidY)
            tempCard.size = CGSize(width: frameSize.width / 3.5,
                                   height: 1.4 * frameSize.width / 3.5)
            gameNode.addChild(tempCard)
            tempCard.run(stackToDeck[i % N], completion : {
                if !attach {
                    for j in self.deckJacket {
                        self.gameNode.addChild(j)
                    }
                    attach = true
                }
                tempCard.removeFromParent()
            })
        }
        let tempCard = SKSpriteNode(imageNamed : "Game/Jacket")
        tempCard.position = CGPoint(x: frameMidX, y: frameMidY)
        tempCard.size = CGSize(width: frameSize.width / 3.5,
                               height: 1.4 * frameSize.width / 3.5)
        gameNode.addChild(tempCard)
        tempCard.run(stackToDeck[(52-1) % N], completion : {
            tempCard.removeFromParent()
            self.updateStats()
            for stat in self.cardStats {
                self.gameNode.addChild(stat)
            }
            print("Cards have been distributed. Starting Game...")
            self.randTurn()
        })
    }
    
    func wrongThread(_ curr : UInt64) -> Bool {
        return curr != thread
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
        print("--------------------------")
        if turn != 0 {
            print("Routing to player", turn, "after delay")
            if locked { return }
            if wrongThread(curr) { return }
            gameNode.run(SKAction.wait(forDuration :  turnBufferTime), completion: {
                if self.locked { return }
                if self.wrongThread(curr) { return }
                self.playTurn(curr : curr)
            })
        }
    }
    
    func endTurn(curr : UInt64) {
        if locked { return }
        if wrongThread(curr) { return }
        gameNode.run(SKAction.wait(forDuration : computerActionTime), completion : {
            if self.locked { return }
            if self.wrongThread(curr) { return }
            print("Additional Wait Time Completed")
            let collector = self.ers.obgCollector()
            if !self.obg && collector != -1 {
                print("Manual Obligation Collection")
                self.collectAction(player : collector, curr : curr)
            } else if self.ers.checkPattern() {
                print("Slap Detected, Computer Slap Sequence")
                let rand = Int.random(in : 1..<self.N)
                self.slapAction(player : rand, curr : curr)
            } else {
                print("Nothing Detected. Proceeding to Routing")
                self.checkWin()
                self.turnRouter(curr : curr)
            }
        })
    }
    
    func playTurn(curr : UInt64) {
        if locked { return }
        if wrongThread(curr) { return }
        locked = true
        print("Player", turn, "is playing a card")
        let card = ers.playCard(player : turn)
        let cardSprite = SKSpriteNode(imageNamed : "Game/Jacket")
        cardSprite.position = deckLocations[turn]
        cardSprite.size = CGSize(width: frameSize.width / 3.5,
                               height: 1.4 * frameSize.width / 3.5)
        cardSprite.zPosition = 30
        gameNode.addChild(cardSprite)
        //Position
        updateStats()
        cardSprite.run(SKAction.rotate(byAngle : CGFloat(rotationFactor), duration: cardToStackTime))
        rotationFactor += 1.5
        if rotationFactor > Double.pi {
            rotationFactor -= Double.pi
        }
        cardSprite.run(deckToStack, completion: {
            cardSprite.texture = SKTexture(imageNamed: "Cards/" + card.tostring())
            print("Card Played is", card.tostring())
            self.stackDisplay.append(cardSprite)
            if !self.ers.underObg(player : self.turn) {
                self.turn = (self.turn + 1) % self.N
            } else {
                print("Under Obligation. Repeat Turn")
            }
            self.locked = false
            let collector = self.ers.obgCollector()
            if self.obg && collector != -1 {
                print("Automatic Obligation Collection")
                self.collectAction(player : collector, curr : curr)
            }
            self.endTurn(curr : curr)
        })
    }
    
    func slapAction(player : Int, curr : UInt64) {
        if locked { return }
        if wrongThread(curr) { return }
        locked = true
        print("Player", player, "has slapped the stack")
        gameNode.addChild(hands[player])
        gameNode.run(SKAction.wait(forDuration : handVisibleTime), completion : {
            self.hands[player].removeFromParent()
            if self.ers.slap(player : player) {
                print("Slap is Valid. Collecting Cards")
                for item in self.stackDisplay {
                   item.run(self.stackToDeck[player], completion : {
                       item.removeFromParent()
                   })
                }
                self.stackDisplay = []
                self.gameNode.run(self.waitCollect, completion : {
                    print("Collection Completed. Proceeding with Routing")
                    self.updateStats()
                    self.updatePenalty()
                    self.turn = player
                    self.checkWin()
                    self.locked = false
                    self.thread += 1
                    self.turnRouter(curr : self.thread)
                })
            } else {
                print("Slap is Invalid. Penalty Issued")
                //Penalize player
                self.updateStats()
                self.updatePenalty()
                self.checkWin()
                self.locked = false
                self.thread += 1
                self.endTurn(curr : self.thread)
            }
        })
    }
    
    func collectAction(player : Int, curr : UInt64) {
        if locked { return }
        if wrongThread(curr) { return }
        self.locked = true
        /*if self.obg { //Hand for Obligation
            addChild(hands[player])
            self.run(SKAction.wait(forDuration : handVisibleTime), completion : {
                self.hands[player].removeFromParent()
            })
        }*/
        print("Player", player, "is collecting obligation")
        ers.collectCards(receiver : player)
        for item in stackDisplay {
            item.run(stackToDeck[player], completion : {
                item.removeFromParent()
            })
        }
        self.stackDisplay = []
        gameNode.run(waitCollect, completion : {
            print("Obligation Collected. Proceeding with Routing")
            self.updateStats()
            self.updatePenalty()
            self.turn = player
            self.checkWin()
            self.locked = false
            self.thread += 1
            self.turnRouter(curr : self.thread)
        })
    }
    
    func checkWin() {
        /**
       IF WIN -> {
           ANIMATE: => WAIT
               LAUNCH END SCREEN
           WAIT FOR INPUT TO LEAVE
       }
        */
        //if false { showEndScreen() }
    }
}
