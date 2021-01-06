//
//  MultiLobbyViewController.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 6/1/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import UIKit
import Foundation
import SocketIO

var manager : SocketManager!
var socket : SocketIOClient!

class MultiLobbyViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var codeSubmitButton: UIButton!
    
    var ready : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.codeTextField.delegate = self
        print("Loaded Screen")
        connectSocket()
    }
    
    func connectSocket() {
        print("Starting to make connection")
        manager = SocketManager(socketURL: URL(string: "http://192.168.1.185:3000")!, config: [.log(true), .compress, .forceWebsockets(true)])
        socket = manager.socket(forNamespace: "/game")
        print("Built Sockets")
        socket.on("created") { data, ack in
            print("Connection Created")
            self.ready = true
        }
        socket.connect()
        codeSubmitButton.addTarget(self, action: #selector (self.buttonClicked(sender:)), for: .touchUpInside)
    }
    
    func disconnectSocket() {
        socket.disconnect()
    }
    
    @objc func buttonClicked(sender: UIButton) {
        if !self.ready { return }
        let room = codeTextField.text
        socket.emit("join", ["room":room])
        DispatchQueue.main.async {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let gameVC = storyBoard.instantiateViewController(withIdentifier: "MultiGameViewController") as! MultiGameViewController
            gameVC.modalPresentationStyle = .fullScreen
            self.present(gameVC, animated: true, completion: nil)
        }
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
