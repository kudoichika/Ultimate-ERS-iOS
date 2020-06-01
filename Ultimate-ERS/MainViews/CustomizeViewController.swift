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
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBOutlet weak var diffcultyLabel: UILabel!
    @IBOutlet weak var difficultyStepper: UIStepper!
    
    @IBOutlet weak var topBottomSwitch: UISwitch!
    @IBOutlet weak var pairSwitch: UISwitch!
    @IBOutlet weak var sandwichSwitch: UISwitch!
    @IBOutlet weak var marriageSwitch: UISwitch!
    @IBOutlet weak var divorceSwitch: UISwitch!
    @IBOutlet weak var additionSwitch: UISwitch!
    @IBOutlet weak var staircaseSwitch: UISwitch!
    @IBOutlet weak var pythSwitch: UISwitch!
    @IBOutlet weak var obligationSwitch: UISwitch!

    var setup : Bool = false
    
    @objc func stepperValue(sender : UIStepper) {
        if !setup { return }
        diffcultyLabel.text = "Computer Difficulty: \(Int(sender.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gameLabel.layer.masksToBounds = true
        gameLabel.layer.cornerRadius = 20
        gameLabel.textColor = UIColor.white
        
        let Buttons = [backButton, saveButton]
        for button in Buttons {
            button!.layer.borderWidth = 2
            button!.layer.borderColor = UIColor(red: 38.0 / 255, green: 41.0 / 255, blue: 157.0 / 255, alpha: 1).cgColor
            button!.layer.cornerRadius = 10
        }
        difficultyStepper.wraps = false
        difficultyStepper.autorepeat = false
        difficultyStepper.minimumValue = 1
        difficultyStepper.maximumValue = 5
        difficultyStepper.stepValue = 1
        initDefaults();
        
        difficultyStepper.addTarget(self, action: #selector(stepperValue), for: .valueChanged)
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
        setup = true
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
