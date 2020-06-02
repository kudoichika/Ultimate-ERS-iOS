//
//  LoginViewController.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/25/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var handleTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.addTarget(self, action: #selector (self.buttonClicked(_sender:)), for: .touchUpInside)
    }
    
    @objc func buttonClicked(_sender: UIButton) {
        //attempt login then
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let lobbyVC = storyBoard.instantiateViewController(withIdentifier: "MultiLobbyViewController") as! MultiLobbyViewController
        lobbyVC.modalPresentationStyle = .fullScreen
        present(lobbyVC, animated: true, completion: nil)
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
