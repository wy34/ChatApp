//
//  NetworkManager.swift
//  pokeChat
//
//  Created by William Yeung on 7/25/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    let cache = NSCache<NSString, UIImage>()
    
    func downloadImage(forUrl urlString: String, completion: @escaping (Result<UIImage, ErrorMessage>) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(.success(image))
            return
        }
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { (data, resonse, error) in
                if let _ = error  {
                    completion(.failure(.DownloadingImageError))
                    return
                }
                
                guard let response = resonse as? HTTPURLResponse, response.statusCode == 200 else {
                    completion(.failure(.HTTPResponseErrorImage))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(.ImageDataError))
                    return
                }
                
                if let downloadedImage = UIImage(data: data) {
                    self.cache.setObject(downloadedImage, forKey: cacheKey)
                    
                    DispatchQueue.main.async {
                        completion(.success(downloadedImage))
                    }
                }
            }
            task.resume()
        }
    }
}
