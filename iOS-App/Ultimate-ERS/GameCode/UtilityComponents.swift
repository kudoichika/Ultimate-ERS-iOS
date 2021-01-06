//
//  UtilityComponents.swift
//  Ultimate-ERS
//
//  Created by kudoichika on 5/20/20.
//  Copyright © 2020 kudoichika. All rights reserved.
//

import Foundation

struct Queue<T> {
    var items : Array<T>
    init() {
        items = []
    }
    mutating func push(item : T) {
        items.append(item)
    }
    mutating func pop() -> T {
        let item = items[0]
        items.remove(at : 0)
        return item
    }
    mutating func reset() {
        items.removeAll()
    }
    func count() -> Int {
        return items.count
    }
}

struct Stack<T> {
    var items : Array <T>
    init() {
        items = []
    }
    mutating func push(item : T) {
        items.append(item)
    }
    mutating func pop() -> T {
        let item = items[items.count - 1]
        items.remove(at: items.count - 1)
        return item
    }
    mutating func reset() {
        items.removeAll()
    }
    func peek(at : Int = 0) -> T {
        return items[items.count - 1 - at]
    }
    func count() -> Int {
        return items.count
    }
    
}
