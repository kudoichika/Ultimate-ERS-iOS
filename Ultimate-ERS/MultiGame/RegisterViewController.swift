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
    
    @IBOutlet weak var registerHandleTextField: UITextField!
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPassTextField: UITextField!
    @IBOutlet weak var registerSubmitButton: UIButton!
    

   override func viewDidLoad() {
        super.viewDidLoad()
        self.registerHandleTextField.delegate = self
        self.registerEmailTextField.delegate = self
        self.registerPassTextField.delegate = self
        registerSubmitButton.addTarget(self, action: #selector (self.buttonClicked(_sender:)), for: .touchUpInside)
    }
    
    @objc func buttonClicked(_sender: UIButton) {
        let handle : String = registerHandleTextField.text!
        let email : String = registerEmailTextField.text!
        let pass : String = registerPassTextField.text!
        print("Entries: ", handle, email, pass)
        
        let body: Dictionary<String, String> = [
            "handle": handle,
            "email": email,
            "pass": pass
        ]
        print(deleteCookies())
        postRequest(path: "/api/users/register", body: body, completion: { response in
            if let msg = response["message"] {
                if msg as! String == "success" {
                    print("Success in Registration")
                    DispatchQueue.main.async {
                        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let lobbyVC = storyBoard.instantiateViewController(withIdentifier: "MultiLobbyViewController") as! MultiLobbyViewController
                        lobbyVC.modalPresentationStyle = .fullScreen
                        self.present(lobbyVC, animated: true, completion: nil)
                    }
                } else {
                    print("Error in Registration 1")
                    print(readCookies())
                }
            } else {
                print("Error in Registration 2")
            }
        })
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

}
