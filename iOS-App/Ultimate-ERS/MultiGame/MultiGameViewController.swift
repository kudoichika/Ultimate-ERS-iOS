//
//  MultiGameViewController.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 6/1/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import SpriteKit

class MultiGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        socket.on("startGame") { data, ack in
            self.loadGameScene()
        }
        // Do any additional setup after loading the view.
    }
    
    func loadGameScene() {
        if let view = self.view as! SKView? {
            let scene = MultiGameScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.showsFPS = true
            view.showsNodeCount = true
            //view.ignoresSiblingOrder = true
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
