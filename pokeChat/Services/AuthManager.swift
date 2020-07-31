//
//  Authorization.swift
//  pokeChat
//
//  Created by William Yeung on 7/24/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import Foundation
import Firebase

class AuthManager {
    static let shared = AuthManager()
    
    func signIn(withEmail email: String, andPassword password: String, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let _ = error {
                completion(.failure(.SignInError))
                return
            }
            
            completion(.success(true))
        }
    }
    
    func register(withName name: String, email: String, password: String, andImage image: UIImage, completion: @escaping (Result<Bool, ErrorMessage>) -> Void) {
        let imageName = UUID().uuidString
        let storageRef = Storage.storage().reference().child("profileImages/\(imageName)")
        var selectedImage: UIImage?
        
        if image == UIImage(systemName: "plus.square") {
            selectedImage = UIImage(systemName: "person.circle.fill")
        } else {
            selectedImage = image
        }
        
        guard let data = selectedImage!.jpegData(compressionQuality: 0.2) else { return }
        
        storageRef.putData(data, metadata: nil) { (metadata, error) in
            if let _ = error {
                completion(.failure(.PutDataError))
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let _ = error {
                    completion(.failure(.DownloadUrlError))
                    return
                }
                
                guard let imageUrl = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                    if let _ = error {
                        completion(.failure(.RegisteringUserError))
                        return
                    }
                    
                    guard let user = result?.user else { return }
                    let userInfo = ["name": name, "email": email, "imageUrl": imageUrl]
                    let databaseRef = Database.database().reference().child("users").child(user.uid)
                    
                    databaseRef.updateChildValues(userInfo) { (error, ref) in
                        if let _ = error {
                            completion(.failure(.UpdatingDatabaseError))
                            return
                        }
                        
                        completion(.success(true))
                    }
                }
            }
        }
    }
}
