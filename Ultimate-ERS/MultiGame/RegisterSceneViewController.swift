//
//  RegisterSceneViewController.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 9/6/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import SpriteKit

class RegisterSceneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let view = self.view as! SKView? {
            let scene = RegisterScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            scene.viewController = self
            view.presentScene(scene)
            view.showsFPS = true
            view.showsNodeCount = true
            //view.ignoresSiblingOrder = true
            
        }
    }
    
    override var shouldAutorotate: Bool {
        return false
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
