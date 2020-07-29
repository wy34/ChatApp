//
//  Message.swift
//  pokeChat
//
//  Created by William Yeung on 7/28/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import Foundation

class Message {
    var fromId: String?
    var toId: String?
    var message: String?
    var timeSent: Int?
    
    init(fromId: String?, toId: String?, message: String?, timeSent: Int?) {
        self.fromId = fromId
        self.toId = toId
        self.message = message
        self.timeSent = timeSent
    }
    
    init(dictionary: [String: AnyObject]) {
        self.fromId = dictionary["fromId"] as? String
        self.toId = dictionary["toId"] as? String
        self.message = dictionary["message"] as? String
        self.timeSent = dictionary["timeSent"] as? Int
    }
}
