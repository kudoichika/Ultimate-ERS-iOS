//
//  LoginViewController.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/25/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let server = "http://192.168.1.185:3000"

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
        print("Here")
        let url : URL! = URL(string: server + "/api/users/register")
        
        let handle : String = handleTextField.text!
        let email : String = emailTextField.text!
        let pass : String = passTextField.text!
        print("Entries: ", handle, email, pass)
        
        let body: Dictionary<String, String> = [
            "handle": handle,
            "email": email,
            "pass": pass
        ]
        let json = try! JSONSerialization.data(withJSONObject: body, options:[])
        
        var request = URLRequest(url : url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = json
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                print("Response:\n \(dataString)")
            }
        }
        task.resume()
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
