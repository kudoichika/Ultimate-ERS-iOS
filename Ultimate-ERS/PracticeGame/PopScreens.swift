//
//  MenuScreens.swift
//  Ultimate-ERS
//
//  Created by Kudo on 6/24/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation
import SpriteKit

class PopScreen {
    
    var screen : SKSpriteNode!
    
    init(frameSize : CGSize) {
        screen = SKSpriteNode(imageNamed : "BrownPop")
        screen.position = CGPoint(x : 0.5 * frameSize.width, y : 0.6 * frameSize.height)
        screen.size = CGSize(width : 0.75 * frameSize.width, height : 0.3 * frameSize.height)
    }
    
    func addComponents(_ mainNode : SKNode) {
        mainNode.addChild(screen)
    }
    
    func removeComponents() {
        screen.removeFromParent()
    }
    
}

class PauseScreen : PopScreen {
    
    var label : SKLabelNode!
    var resume : SKSpriteNode!
    var leave : SKSpriteNode!
    
    override init(frameSize : CGSize) {
        super.init(frameSize : frameSize)
        label = SKLabelNode(text : "Paused")
        label.position = CGPoint(x : 0.5 * frameSize.width, y : 0.675 * frameSize.height)
        let labelSize = CGSize(width : 0.8 * (frameSize.width / 1.9), height : 0.8 * (frameSize.width / CGFloat(3.5 * 16.0 / 9.0)))
        resume = SKSpriteNode(imageNamed : "Menu/Resume")
        resume.position = CGPoint(x : 0.5 * frameSize.width, y : 0.6 * frameSize.height)
        resume.size = labelSize
        resume.name = "resume"
        leave = SKSpriteNode(imageNamed : "Menu/Leave")
        leave.position = CGPoint(x : 0.5 * frameSize.width, y : 0.525 * frameSize.height)
        leave.size = labelSize
        leave.name = "leave"
    }
    
    override func addComponents(_ mainNode : SKNode) {
        super.addComponents(mainNode)
        mainNode.addChild(label)
        mainNode.addChild(resume)
        mainNode.addChild(leave)
    }
    
    override func removeComponents() {
        super.removeComponents()
        label.removeFromParent()
        resume.removeFromParent()
        leave.removeFromParent()
    }

}

class EndScreen : PopScreen {
    
    override init(frameSize : CGSize) {
        super.init(frameSize : frameSize)
        //Make stuff here
    }
    
    override func addComponents(_ mainNode : SKNode) {
        super.addComponents(mainNode)
    }
    
    override func removeComponents() {
        super.removeComponents()
    }
    
}
