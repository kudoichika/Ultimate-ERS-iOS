//
//  PracticeViewController.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/20/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import SpriteKit

class PracticeViewController: UIViewController {
    
    //This Needs a Back Button

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = PracticeScene(size: view.bounds.size)
            scene.viewController = self
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.showsFPS = true
            view.showsNodeCount = true
            //view.ignoresSiblingOrder = true
            
        }

        // Do any additional setup after loading the view.
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
