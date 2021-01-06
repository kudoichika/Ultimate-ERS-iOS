//
//  MainScene.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 9/6/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import SpriteKit
import GameplayKit

class LoginScene: SKScene {
    
    weak var viewController: UIViewController?
    
    var backgroundImage : SKSpriteNode!
    var header : SKSpriteNode!
    var hand : SKSpriteNode!
    
    var practiceLabel : SKSpriteNode!
    var multiplayLabel : SKSpriteNode!
    var customizeLabel : SKSpriteNode!
    var otherLabel : SKSpriteNode!
    var labels : Array<SKSpriteNode>!
    
    var shrinkAction : SKAction!
    var growAction : SKAction!
    
    var current : String!
    var labelAnimTime : Double!

    override var isUserInteractionEnabled: Bool {
        get {
            return true
        }
        set {  }
    }
    
    override func didMove(to view: SKView) {
        print("Loaded View")
        layoutScene()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func layoutScene() {
        
        backgroundImage = SKSpriteNode(imageNamed : "Bg")
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        backgroundImage.size = CGSize(width : frame.size.width, height : frame.size.height)
        addChild(backgroundImage)
        /*self.backgroundColor = UIColor(red: 60.0 / 255, green: 153.0 / 255, blue: 52.0 / 255, alpha: 1)*/
        header = SKSpriteNode(imageNamed : "Menu/Header")
        header.position = CGPoint(x: frame.midX, y: frame.size.height * 0.75)
        header.size = CGSize(width : frame.size.width / 0.9, height: frame.size.width / 1.6)
        addChild(header)
        
        hand = SKSpriteNode(imageNamed : "Game/Hand")
        hand.position = CGPoint(x: frame.midX, y: frame.size.height * 0.7)
        hand.size = CGSize(width: frame.size.width / 3, height: frame.size.height / 4.25)
        addChild(hand)
        
        
        practiceLabel = SKSpriteNode(imageNamed : "Menu/Practice")
        practiceLabel.name = "practice"
        multiplayLabel = SKSpriteNode(imageNamed : "Menu/Multiplay")
        multiplayLabel.name = "multiplay"
        customizeLabel = SKSpriteNode(imageNamed : "Menu/Customize")
        customizeLabel.name = "customize"
        otherLabel = SKSpriteNode(imageNamed : "Menu/Other")
        otherLabel.name = "other"
        labels = [practiceLabel, multiplayLabel, customizeLabel, otherLabel]
        
        let labelSize = CGSize(width : frame.size.width / 1.9, height : frame.size.width / CGFloat(3.5 * 16.0 / 9.0))
        
        var i = 0
        for label in labels {
            label.size = labelSize
            label.position = CGPoint(x: frame.midX, y: 0.95 * frame.midY - CGFloat(i) * frame.size.width / CGFloat(2.9 * 16.0 / 9.0))
            addChild(label)
            i += 1
        }
        
        labelAnimTime = 0.075
        
        shrinkAction = SKAction.resize(toWidth: frame.size.width / 2.1, height : frame.size.width / CGFloat(3.7 * 16.0 / 9.0), duration: labelAnimTime)
        growAction = SKAction.resize(toWidth : labelSize.width, height : labelSize.height, duration: labelAnimTime)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        if touchedNodes.count > 0 {
            let node = touchedNodes[0]
            for label in labels {
                if label.name == node.name {
                    node.run(shrinkAction)
                    current = node.name
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        for label in labels {
            label.run(growAction)
        }
        let location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        if touchedNodes.count > 0 {
            let node = touchedNodes[0]
            for label in labels {
                if label.name == node.name && node.name == current {
                    self.run(SKAction.wait(forDuration : labelAnimTime), completion : {
                        self.switchScreens(dest : self.current!)
                    })
                }
            }
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func switchScreens(dest : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vcdest : String
        switch (dest) {
        case "practice": vcdest = "PracticeViewController"
        case "multiplay": vcdest = "LoginViewController"
        case "customize": vcdest = "CustomizeViewController"
        case "other": vcdest = "RulesViewController"
        default: vcdest = ""
        }
        if vcdest == "" { return }
        let nextVC = storyboard.instantiateViewController(withIdentifier: vcdest)
        nextVC.modalPresentationStyle = .fullScreen
        viewController?.present(nextVC, animated: true, completion: nil)
    }
    
}
