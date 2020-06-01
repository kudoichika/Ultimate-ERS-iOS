//
//  RegisterViewController.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 6/1/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    let path = "/api/users/register"

    @IBOutlet weak var handleTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.handleTextField.delegate = self
        self.emailTextField.delegate = self
        self.passTextField.delegate = self
        submitButton.addTarget(self, action: #selector (self.buttonClicked(_sender:)), for: .touchUpInside)
    }
    
    @objc func buttonClicked(_sender: UIButton) {
        let handle : String = handleTextField.text!
        let email : String = emailTextField.text!
        let pass : String = passTextField.text!
        print("Entries: ", handle, email, pass)
        
        let body: Dictionary<String, String> = [
            "handle": handle,
            "email": email,
            "pass": pass
        ]
        
        request(path: path, body: body, method: "POST", completion: { response in 
            if let msg = response["message"] {
                if msg as! String == "success" {
                    print("Success in Registration")
                }
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
