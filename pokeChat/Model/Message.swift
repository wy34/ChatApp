//
//  Message.swift
//  pokeChat
//
//  Created by William Yeung on 7/28/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import Foundation
import Firebase

class Message {
    var fromId: String?
    var toId: String?
    var message: String?
    var timeSent: Int?
    var imageUrl: String?
    var imageHeight: Int?
    var imageWidth: Int?
    var thumbnailImageUrl: String?
    var videoUrl: String?
    
    var chatPartnerId: String? {
        return Auth.auth().currentUser?.uid == fromId ? toId! : fromId!
    }
    
    init(dictionary: [String: AnyObject]) {
        self.fromId = dictionary["fromId"] as? String
        self.toId = dictionary["toId"] as? String
        self.message = dictionary["message"] as? String
        self.timeSent = dictionary["timeSent"] as? Int
        self.imageUrl = dictionary["imageUrl"] as? String
        self.imageWidth = dictionary["imageWidth"] as? Int
        self.imageHeight = dictionary["imageHeight"] as? Int
        self.thumbnailImageUrl = dictionary["thumbnailImageUrl"] as? String
        self.videoUrl = dictionary["videoUrl"] as? String
    }
}
