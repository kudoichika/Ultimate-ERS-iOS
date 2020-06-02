//
//  MultiGameScene.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 6/1/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import SpriteKit

class MultiGameScene : SKScene {
    
    override func didMove(to view: SKView) {
        layoutScene()
    }
    
    override var isUserInteractionEnabled: Bool {
        get { return true }
        set {  }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        socket.emit("playCard")
    }
    
    func layoutScene() {
        self.backgroundColor = UIColor(red: 41.0 / 255, green: 165.0 / 255, blue: 68.0 / 255, alpha: 1)
    }
}
