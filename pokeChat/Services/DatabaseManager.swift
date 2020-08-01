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
    
    func getUserWith(id: String, completion: @escaping (Result<User, ErrorMessage>) -> Void) {
        let ref = Database.database().reference().child("users").child(id)
        
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
    
    func addMessage(of message: String, toId partnerId: String, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let ref = Database.database().reference().child("messages").childByAutoId()
        
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        let timeSent = Int(Date().timeIntervalSince1970)
        let data = ["message": message, "fromId": fromId, "toId": partnerId, "timeSent": timeSent] as [String: AnyObject]
        
        ref.updateChildValues(data) { (error, ref) in
            if let _ = error {
                completion(.failure(.AddingMessageError))
                return
            }
            
            completion(.success(true))
        }
    }
    
    func getAllMessages(completion: @escaping (Result<[Message], ErrorMessage>) -> Void) {
        let ref = Database.database().reference().child("messages")
        var messagesArray = [Message]()
        var messagesDictionary = [String: Message]()
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        
        ref.observe(.childAdded) { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let message = Message(dictionary: dictionary)
                
                if currentUid == message.fromId! || currentUid == message.toId! {
                    messagesDictionary[message.chatPartnerId!] = message
                    messagesArray = Array(messagesDictionary.values)
                    messagesArray.sort { (message1, message2) -> Bool in
                        return message1.timeSent! > message2.timeSent!
                    }
                }
            }
            DispatchQueue.main.async {
                completion(.success(messagesArray))
            }
        }
    }
}
