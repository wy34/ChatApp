//
//  User.swift
//  pokeChat
//
//  Created by William Yeung on 7/24/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import Foundation

class User: NSObject {
    var id: String?
    var name: String?
    var email: String?
    var imageUrl: String?
    
    init(dictionary: [String: AnyObject]) {
        self.id = dictionary["id"] as? String
        self.name = dictionary["name"] as? String
        self.email = dictionary["email"] as? String
        self.imageUrl = dictionary["imageUrl"] as? String
    }
}
