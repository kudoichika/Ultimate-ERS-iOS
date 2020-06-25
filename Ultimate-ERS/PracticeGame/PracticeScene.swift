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
//Random Chance that computer does ot get the slap

class PracticeScene : SKScene {
    
    var backgroundImage : SKSpriteNode!
    var pauseButton : SKSpriteNode!
    
    var game : PracticeGame!
    var pauseScreen : PauseScreen!
    var endScreen : EndScreen!
    
    weak var viewController : UIViewController?
    
    override var isUserInteractionEnabled: Bool {
        get {
            return true//!locked
        }
        set {  }
    }
    
    override func didMove(to view: SKView) {
        print("Loaded View")
        layoutScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        //CHECK END #PROBABLY DONT NEED TO
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //if locked { print("User Interaction Prohibited"); return }
        print("User Has Interacted")
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        if touchedNodes.count > 0 {
            let node = touchedNodes[0]
            if game.isPaused() {
                //Handle Pause/End Screens Here
                if node.name == "resume" {
                    print("User has resumed the game")
                    closePauseScreen()
                } else if node.name == "leave" {
                    print("User has left the game")
                    goToMain()
                }
            } else {
                if node.name == "pause" {
                    game.setPause(true)
                    openPauseScreen()
                    return
                }
                game.userTouched(node : node)
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
        addChild(pauseButton)
        
        game = PracticeGame(frame : frame.size, numPlayers: 4)
        game.addComponents(self)
    }
    
    func openPauseScreen() {
        self.isPaused = true
        pauseScreen = PauseScreen(frameSize : frame.size)
        pauseScreen.addComponents(self)
    }
    
    func closePauseScreen() {
        //overlay with dim node
        pauseScreen.removeComponents()
        self.isPaused = false
    }
    
    func showEndScreen() {
        
    }
    
    func goToMain() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "MainSceneViewController")
        nextVC.modalPresentationStyle = .fullScreen
        viewController?.present(nextVC, animated: true, completion: nil)
    }
}
