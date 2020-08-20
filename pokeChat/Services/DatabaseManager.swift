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
                if snapshot.key != Auth.auth().currentUser?.uid {
                    dictionary["id"] = snapshot.key as AnyObject
                    let user = User(dictionary: dictionary)
                    users.append(user)
                }
            }
            DispatchQueue.main.async {
                completion(.success(users))
            }
        }
    }
    
    func addMessage(withProperties properties: [String: AnyObject], toId: String, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let ref = Database.database().reference().child("messages").childByAutoId()
        
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        let timeSent = Int(Date().timeIntervalSince1970)
        var data = ["fromId": fromId, "toId": toId, "timeSent": timeSent] as [String: AnyObject]
        
        properties.forEach {
            data[$0] = $1
        }
        
        ref.updateChildValues(data) { (error, ref) in
            if let _ = error {
                completion(.failure(.AddingMessageError))
                return
            }
            
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            if let messageId = ref.key {
                userMessagesRef.updateChildValues([messageId: 1])
            }
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
            if let messageId = ref.key {
                recipientUserMessagesRef.updateChildValues([messageId: 1])
            }
            
            completion(.success(true))
        }
    }
    
    func getAllMessages(chatPartner: User, completion: @escaping (Result<[Message], ErrorMessage>) -> Void) {
        var messages = [Message]()
        guard let currentId = Auth.auth().currentUser?.uid else { return }
        guard let chatPartnerId = chatPartner.id else { return }
        
        let ref = Database.database().reference().child("user-messages").child(currentId).child(chatPartnerId)
        ref.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    let message = Message(dictionary: dictionary)
                    messages.append(message)
                }
                
                DispatchQueue.main.async {
                    completion(.success(messages))
                }
            }
        }
    }
    
    func getConversations(completion: @escaping (Result<[Message], ErrorMessage>) -> Void) {
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
    
    func store(image: UIImage, inDirectory folder: String, completion: @escaping (Result<String, ErrorMessage>) -> Void) {
        let imageName = UUID()
        let ref = Storage.storage().reference().child(folder).child("\(imageName)")
        guard let imageData = image.jpegData(compressionQuality: 0.2) else { return }
        
        ref.putData(imageData, metadata: nil) { (metaData, error) in
            if let _ = error {
                completion(.failure(.PutDataError))
                return
            }
            
            ref.downloadURL { (url, error) in
                if let _ = error {
                    completion(.failure(.DownloadUrlError))
                    return
                }
                
                guard let urlString = url?.absoluteString else { return }
                completion(.success(urlString))
            }
        }
    }
}
