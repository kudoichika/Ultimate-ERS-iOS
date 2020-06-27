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
//Computer Automatic Obligation Too Fast Honestly
//Random Chance that computer does not get the slap

class PracticeScene : SKScene {
    
    var backgroundImage : SKSpriteNode!
    var pauseButton : SKSpriteNode!
    
    var game : PracticeGame!
    var pauseScreen : PauseScreen!
    var endScreen : EndScreen!
    
    var state : String!
    var labelAnimTime : Double!
    
    var current : String!
    
    weak var viewController : UIViewController?
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {  }
    }
    
    override func didMove(to view: SKView) {
        //Create A Screen to Start Game
        print("Loaded View")
        layoutScene()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("User Has Interacted")
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        if touchedNodes.count > 0 {
            let node = touchedNodes[0]
            if game.isPaused() {
                if node.name == nil { return }
                if state == "paused" {
                    pauseScreen.shrinkComponent(name : node.name!, time : labelAnimTime)
                } else if state == "ended" {
                    endScreen.shrinkComponent(name: node.name!, time: labelAnimTime)
                }
            } else {
                if node.name == "pause" {
                    current = "pause"
                    return
                }
                game.userTouched(node : node)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        if touchedNodes.count > 0 {
            if state == "paused" {
                print("Ended Pause")
                closePauseScreen(choice : touchedNodes[0])
            } else if state == "ended" {
                print("Ended EndScreen")
                closeEndScreen(choice : touchedNodes[0])
            } else {
                if touchedNodes[0].name == "pause" && current == "pause" {
                    state = "paused"
                    game.setPause(true)
                    openPauseScreen()
                }
            }
        }
    }
    
    func layoutScene() {
        backgroundImage = SKSpriteNode(imageNamed : "Bg")
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.size = CGSize(width : frame.size.width, height : frame.size.height)
        addChild(backgroundImage)
        
        pauseButton = SKSpriteNode(imageNamed : "Game/Pause")
        pauseButton.position = CGPoint(x : 0.9 * frame.size.width, y : 0.9 * frame.size.height)
        pauseButton.size = CGSize(width : 0.125 * frame.size.width, height : 0.125 * frame.size.width)
        pauseButton.name = "pause"
        
        labelAnimTime = 0.1
        
        state = "playing"
        game = PracticeGame(frame : frame.size, numPlayers: 4)
        game.parent = self
        game.addComponents(self)
        
        self.run(SKAction.wait(forDuration : 0.3), completion : {
            self.addChild(self.pauseButton)
        })
    }
    
    func openPauseScreen() {
        //overlay with dim node
        pauseScreen = PauseScreen(frameSize : frame.size)
        pauseScreen.addComponents(self)
    }
    
    func closePauseScreen(choice : SKNode) {
        pauseScreen.growComponents(time : labelAnimTime)
        let name = choice.name
        if name == "" { return }
        self.run(SKAction.wait(forDuration : labelAnimTime), completion : {
            if name == "resume" {
                self.pauseScreen.removeComponents()
                self.game.setPause(false)
                self.state = "playing"
            } else if name == "leave" {
                self.goToMain()
            }
        })
    }
    
    func showEndScreen(verdict : Int) {
        print("Game Ended")
        game.setPause(true)
        state = "ended"
        endScreen = EndScreen(frameSize : frame.size, verdict : verdict)
        endScreen.addComponents(self)
    }
    
    func closeEndScreen(choice : SKNode) {
        endScreen.growComponents(time: labelAnimTime)
        let name = choice.name
        if name == "" { return }
        self.run(SKAction.wait(forDuration: labelAnimTime), completion : {
            if name == "leave" {
                self.goToMain()
            }
        })
    }
    
    func goToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "MainSceneViewController")
        nextVC.modalPresentationStyle = .fullScreen
        viewController?.present(nextVC, animated: true, completion: nil)
    }
}
