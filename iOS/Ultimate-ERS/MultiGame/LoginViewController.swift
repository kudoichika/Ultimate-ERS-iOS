//
//  LoginViewController.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/25/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var loginHandleTextField: UITextField!
    @IBOutlet weak var loginPassTextField: UITextField!
    @IBOutlet weak var loginSubmitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginHandleTextField.delegate = self
        self.loginPassTextField.delegate = self
        loginSubmitButton.addTarget(self, action: #selector (self.buttonClicked(sender:)), for: .touchUpInside)
    }
    
    
    @objc func buttonClicked(sender: UIButton) {
        if sender != loginSubmitButton { return }
        //Attempt Login
        let handle : String = loginHandleTextField.text!
        let pass : String = loginPassTextField.text!
        let body: Dictionary<String, String> = [
            "userid": handle,
            "password": pass
        ]
        print(body)
        print(deleteCookies())
        postRequest(path: "/api/users/login", body: body, completion: { response in
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

