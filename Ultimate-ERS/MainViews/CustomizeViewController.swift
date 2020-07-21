//
//  CustomizeViewController.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/20/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit

class CustomizeViewController: UIViewController {

    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBOutlet weak var diffcultyLabel: UILabel!
    @IBOutlet weak var difficultyStepper: UIStepper!
    @IBOutlet weak var playersLabel: UILabel!
    @IBOutlet weak var playersStepper: UIStepper!
    @IBOutlet weak var pairSwitch: UISwitch!
    @IBOutlet weak var topBottomSwitch: UISwitch!
    @IBOutlet weak var sandwichSwitch: UISwitch!
    @IBOutlet weak var marriageSwitch: UISwitch!
    @IBOutlet weak var divorceSwitch: UISwitch!
    @IBOutlet weak var additionSwitch: UISwitch!
    @IBOutlet weak var staircaseSwitch: UISwitch!
    @IBOutlet weak var pythSwitch: UISwitch!
    @IBOutlet weak var obligationSwitch: UISwitch!
    @IBOutlet weak var labelSwitch: UISwitch!
    
    var setup : Bool = false
    
    @objc func difStepperValue(sender : UIStepper) {
        if !setup { return }
        diffcultyLabel.text = "Computer Difficulty: \(Int(sender.value))"
    }
    
    @objc func playStepperValue(sender : UIStepper) {
        if !setup { return }
        playersLabel.text = "Number of Players: \(Int(sender.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Bg")!)
        gameLabel.layer.masksToBounds = true
        gameLabel.layer.cornerRadius = 20
        gameLabel.textColor = UIColor.white
        
        saveButton!.layer.borderWidth = 2
        saveButton!.layer.borderColor = UIColor.white.cgColor
        saveButton!.layer.cornerRadius = 10

        let switches = [
            pairSwitch,
            topBottomSwitch,
            sandwichSwitch,
            marriageSwitch,
            divorceSwitch,
            additionSwitch,
            staircaseSwitch,
            pythSwitch,
            obligationSwitch,
            labelSwitch
        ]
        
        for sw in switches {
            sw?.onTintColor = UIColor.brown
            //sw?.backgroundColor = UIColor.brown
            //sw?.layer.cornerRadius = 16.0;
        }
            
        difficultyStepper.wraps = false
        difficultyStepper.autorepeat = false
        difficultyStepper.minimumValue = 1
        difficultyStepper.maximumValue = 5
        difficultyStepper.stepValue = 1
        playersStepper.wraps = false
        playersStepper.autorepeat = false
        playersStepper.minimumValue = 2
        playersStepper.maximumValue = 4
        playersStepper.stepValue = 1
        initDefaults();
        
        difficultyStepper.addTarget(self, action: #selector(difStepperValue), for: .valueChanged)
        playersStepper.addTarget(self, action: #selector(playStepperValue), for : .valueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveSegue" {
            topBottomSlap = topBottomSwitch.isOn
            pairSlap = pairSwitch.isOn
            sandwichSlap = sandwichSwitch.isOn
            marriageSlap = marriageSwitch.isOn
            divorceSlap = divorceSwitch.isOn
            additionSlap = additionSwitch.isOn
            pythSlap = pythSwitch.isOn
            stairSlap = staircaseSwitch.isOn
            manualObligation = obligationSwitch.isOn
            computerDifficulty = Int(difficultyStepper.value)
            numPlayers = Int(playersStepper.value)
            labelHint = labelSwitch.isOn
            saveUserDefaults()
        }
    }
    
    func initDefaults() {
        topBottomSwitch.setOn(topBottomSlap, animated: false)
        pairSwitch.setOn(pairSlap, animated: false)
        sandwichSwitch.setOn(sandwichSlap, animated: false)
        marriageSwitch.setOn(marriageSlap, animated: false)
        divorceSwitch.setOn(divorceSlap, animated: false)
        additionSwitch.setOn(additionSlap, animated: false)
        pythSwitch.setOn(pythSlap, animated: false)
        staircaseSwitch.setOn(stairSlap, animated: false)
        obligationSwitch.setOn(manualObligation, animated: false)
        difficultyStepper.value = Double(computerDifficulty)
        diffcultyLabel.text = "Computer Difficulty: \(Int(difficultyStepper.value))"
        playersLabel.text = "Number of Players: \(Int(playersStepper.value))"
        labelSwitch.setOn(labelHint, animated: false)
        setup = true
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
