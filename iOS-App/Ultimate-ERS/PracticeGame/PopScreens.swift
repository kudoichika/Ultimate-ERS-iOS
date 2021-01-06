//
//  MenuScreens.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 6/24/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation
import SpriteKit

class PopScreen {
    
    var screen : SKSpriteNode!
    var frameSize : CGSize!
    
    var zeroSize : CGSize!
    var popDuration : Double!
    
    init(frameSize : CGSize) {
        self.frameSize = frameSize
        zeroSize = CGSize(width : 0, height : 0)
        screen = SKSpriteNode(imageNamed : "BrownPop")
        screen.position = CGPoint(x : 0.5 * frameSize.width, y : 0.6 * frameSize.height)
        screen.size = zeroSize
        screen.zPosition = 90
        popDuration = 0.3
    }
    
    func addComponents(_ mainNode : SKNode) {
        let popComponent = SKAction.resize(toWidth : 0.75 * frameSize.width, height : 0.3 * frameSize.height, duration : popDuration)
        mainNode.addChild(screen)
        screen.run(popComponent)
    }
    
    func removeComponents() {
        screen.removeFromParent()
    }
    
}

class PauseScreen : PopScreen {
    
    var label : SKLabelNode!
    var resume : SKSpriteNode!
    var leave : SKSpriteNode!
    
    var finalSize : CGSize!
    var allComponents : Array<SKNode>!
    
    override init(frameSize : CGSize) {
        super.init(frameSize : frameSize)
        label = SKLabelNode(text : "Paused")
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x : 0.5 * frameSize.width, y : 0.675 * frameSize.height)
        
        resume = SKSpriteNode(imageNamed : "Menu/Resume")
        resume.position = CGPoint(x : 0.5 * frameSize.width, y : 0.6 * frameSize.height)
        resume.size = super.zeroSize
        resume.name = "resume"
        leave = SKSpriteNode(imageNamed : "Menu/Leave")
        leave.position = CGPoint(x : 0.5 * frameSize.width, y : 0.525 * frameSize.height)
        leave.size = super.zeroSize
        leave.name = "leave"
        
        finalSize = CGSize(width : 0.8 * (frameSize.width / 1.9), height : 0.8 * (frameSize.width / CGFloat(3.5 * 16.0 / 9.0)))
        allComponents = [label, resume, leave]
        for component in allComponents {
            component.zPosition = 100
        }
        
    }
    
    override func addComponents(_ mainNode : SKNode) {
        super.addComponents(mainNode)
        for component in allComponents {
            mainNode.addChild(component)
            component.run(SKAction.resize(toWidth : finalSize.width, height : finalSize.height, duration : popDuration))
        }
    }
    
    override func removeComponents() {
        super.removeComponents()
        for component in allComponents {
            component.removeFromParent()
        }
    }
    
    func shrinkComponent(name : String, time : Double) {
        let shrinkAction = SKAction.resize(toWidth: 0.9 * finalSize.width, height : 0.9 * finalSize.height, duration: time)
        if name == "resume" {
            resume.run(shrinkAction)
        } else if name == "leave" {
            leave.run(shrinkAction)
        }
    }
    
    func growComponents(time : Double) {
        let growAction = SKAction.resize(toWidth : finalSize.width, height : finalSize.height, duration: time)
        resume.run(growAction)
        leave.run(growAction)
    }

}

class EndScreen : PopScreen {
    
    var label : SKLabelNode!
    var leave : SKSpriteNode!
    
    var finalSize : CGSize!
    var allComponents : Array<SKNode>!
    
    init(frameSize : CGSize, verdict : Int) {
        super.init(frameSize : frameSize)
        if verdict == 1 {
            label = SKLabelNode(text : "You Win!!")
        } else {
            label = SKLabelNode(text : "You ranked #\(verdict)!")
        }
        label.fontName = "AvenirNext-Bold"
        label.position = CGPoint(x : 0.5 * frameSize.width, y : 0.675 * frameSize.height)
        
        
        leave = SKSpriteNode(imageNamed : "Menu/Leave")
        leave.position = CGPoint(x : 0.5 * frameSize.width, y : 0.575 * frameSize.height)
        leave.size = super.zeroSize
        leave.name = "leave"
        
        finalSize = CGSize(width : 0.8 * (frameSize.width / 1.9), height : 0.8 * (frameSize.width / CGFloat(3.5 * 16.0 / 9.0)))
        allComponents = [label, leave]
        for component in allComponents {
            component.zPosition = 100
        }
    }
    
    override func addComponents(_ mainNode : SKNode) {
        super.addComponents(mainNode)
        for component in allComponents {
            mainNode.addChild(component)
            component.run(SKAction.resize(toWidth : finalSize.width, height : finalSize.height, duration : popDuration))
        }
    }
    
    override func removeComponents() {
        super.removeComponents()
        for component in allComponents {
            component.removeFromParent()
        }
    }
    
    func shrinkComponent(name : String, time : Double) {
        let shrinkAction = SKAction.resize(toWidth: 0.9 * finalSize.width, height : 0.9 * finalSize.height, duration: time)
        if name == "leave" {
            leave.run(shrinkAction)
        }
    }
    
    func growComponents(time : Double) {
        let growAction = SKAction.resize(toWidth : finalSize.width, height : finalSize.height, duration: time)
        leave.run(growAction)
    }
    
}

func generateLabel(frameSize : CGSize, slapText : String, mainNode : SKNode) {
    let label : SKLabelNode!
    label = SKLabelNode(text : "\(slapText) Slap!")
    label.fontName = "AvenirNext-Bold"
    label.position = CGPoint(x : 0.5 * frameSize.width, y : 0.325 * frameSize.height)
    label.zPosition = 100
    label.fontColor = UIColor.yellow
    mainNode.addChild(label)
    let finalSize = CGSize(width : 0.8 * (frameSize.width / 1.9), height : 0.8 * (frameSize.width / CGFloat(3.5 * 16.0 / 9.0)))
    let popDuration = 0.6
    label.run(SKAction.resize(toWidth : finalSize.width, height : finalSize.height, duration : popDuration), completion : {
        label.removeFromParent()
    })
    
}
