//
//  Message.swift
//  Swipe
//
//  Created by Brett Wallace on 8/21/15.
//  Copyright (c) 2015 Brett Wallace. All rights reserved.
//

import Foundation

struct Message {
    let message: String
    let senderID: String
    let date: NSDate
}

private let ref = Firebase(url: "https://swipe.firebaseio.com/messages")
private let dateFormat = "yyyyMMddHHmmss"