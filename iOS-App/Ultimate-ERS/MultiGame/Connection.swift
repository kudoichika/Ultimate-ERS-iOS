//
//  Connection.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 6/1/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation
import UIKit

let server = "http://192.168.1.185:3000"

var sessionConfig : URLSessionConfiguration!
var session : URLSession!
var storage : HTTPCookieStorage!

func initializeSession() {
    sessionConfig = URLSessionConfiguration.ephemeral
    sessionConfig.httpCookieAcceptPolicy = .never
    session = URLSession(configuration: sessionConfig)
    storage = HTTPCookieStorage.shared
}

func storeCookies(_ cookies : [HTTPCookie]) {
    storage.setCookies(cookies, for: URL(string : server)!, mainDocumentURL: nil)
}

func readCookies() -> [HTTPCookie] {
    let cookies = storage.cookies(for: URL(string : server)!) ?? []
    return cookies
}

func deleteCookies() {
    for cookie in readCookies() {
        storage.deleteCookie(cookie)
    }
}

func postRequest(path : String, body : Dictionary<String, String>, completion: @escaping (_ answer: [String : Any]) -> ()) {
    let url : URL! = URL(string: server + path)
    let json = try! JSONSerialization.data(withJSONObject: body, options: [])
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-type")
    request.httpMethod = "POST"
    request.httpBody = json
    print("Sending Request...")
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            print("Error: \(error)")
            return
        }
        if let data = data, let dataString = String(data: data, encoding: .utf8) {
            print("Raw Data", dataString)
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


//write JSON to Dict && Dict to JSON Function
