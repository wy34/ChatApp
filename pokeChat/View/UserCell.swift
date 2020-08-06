//
//  UserCell1.swift
//  pokeChat
//
//  Created by William Yeung on 8/6/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit


class UserCell: UITableViewCell {
     // MARK: - Properties
    static let reuseId = "userCell"
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            textLabel?.text = user.name
            detailTextLabel?.text = user.email
            
            NetworkManager.shared.downloadImage(forUrl: user.imageUrl!) { (result) in
                switch result {
                    case .success(let image):
                        self.userImageView.image = image
                    case .failure(let error):
                        print(error.rawValue)
                }
            }
        }
    }
    
    // MARK: - Subview
    lazy var userImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 28
        iv.layer.borderWidth = 1
        iv.clipsToBounds = true
        return iv
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        anchorUserImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout subviews methods
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 75, y: textLabel!.frame.origin.y, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 75, y: detailTextLabel!.frame.origin.y, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    func anchorUserImage() {
        addSubview(userImageView)
        userImageView.anchor(left: leftAnchor, paddingLeft: 10)
        userImageView.center(y: centerYAnchor)
        userImageView.setDimension(width: heightAnchor, height: heightAnchor, wMult: 0.70, hMult: 0.70)
    }
}
