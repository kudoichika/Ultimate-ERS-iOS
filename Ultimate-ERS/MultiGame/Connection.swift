//
//  Connection.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 6/1/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation

let server = "http://192.168.1.185:3000"

//Work on Handling Cookies

func request(path : String, body : Dictionary<String, String>, method: String, completion: @escaping (_ answer: [String: Any]) -> ()) {
    let url : URL! = URL(string: server + path)
    let json = try! JSONSerialization.data(withJSONObject: body, options: [])
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-type")
    request.httpMethod = method
    request.httpBody = json
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            if let jsonRes = dataString.data(using: String.Encoding.utf8) {
                do {
                    let res = try JSONSerialization.jsonObject(with: jsonRes, options: []) as! [String: Any]
                    print(res)
                    completion(res)
                } catch {
                    print(error)
                }
            }
        }
    }.resume()
}
