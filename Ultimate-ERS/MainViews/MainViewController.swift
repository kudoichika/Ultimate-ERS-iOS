//
//  MainViewController.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/20/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var singleButton: UIButton!
    @IBOutlet weak var multiButton: UIButton!
    @IBOutlet weak var customizeButton: UIButton!
    @IBOutlet weak var otherButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameLabel.layer.masksToBounds = true
        gameLabel.layer.cornerRadius = 20
        
        let Buttons = [singleButton, multiButton, customizeButton, otherButton]
        
        for button in Buttons {
            button!.layer.borderWidth = 2
            button!.layer.borderColor = UIColor(red: 38.0 / 255, green: 41.0 / 255, blue: 157.0 / 255, alpha: 1).cgColor
            button!.layer.cornerRadius = 10
        }
        
        // Do any additional setup after loading the view.
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
