//
//  Database.swift
//  pokeChat
//
//  Created by William Yeung on 7/24/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import Foundation
import Firebase

class DatabaseManager {
    static let shared = DatabaseManager()
    
    func getCurrentUser(completion: @escaping (Result<User, ErrorMessage>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else { return }
        let ref = Database.database().reference().child("users").child(currentUser.uid)
        
        ref.observeSingleEvent(of: .value) { (snapshot) in
            if var dictionary = snapshot.value as? [String: AnyObject] {
                dictionary["id"] = snapshot.key as AnyObject
                let user = User(dictionary: dictionary)
                completion(.success(user))
            }
        }
    }
    
    func getAllUsers(completion: @escaping (Result<[User], ErrorMessage>) -> Void) {
        let ref = Database.database().reference().child("users")
        var users = [User]()
        
        ref.observe(.childAdded) { (snapshot) in
            if var dictionary = snapshot.value as? [String: AnyObject] {
                dictionary["id"] = snapshot.key as AnyObject
                let user = User(dictionary: dictionary)
                users.append(user)
            }
            DispatchQueue.main.async {
                completion(.success(users))
            }
        }
    }
}
