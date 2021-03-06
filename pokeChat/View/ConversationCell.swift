//
//  UserCell.swift
//  pokeChat
//
//  Created by William Yeung on 7/25/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class ConversationCell: UITableViewCell {
    // MARK: - Variables/constants
    static let reuseId = "conversationCell"
    var dateFormatter = DateFormatter()

    var message: Message? {
        didSet {
            imageView?.image = nil
            guard let message = message else { return }
            guard let chatPartnerId = message.chatPartnerId else { return }
            
            DatabaseManager.shared.getUserWith(id: chatPartnerId) { (result) in
                switch result {
                case .success(let user):
                    self.timeLabel.text = self.getDateAndTimeStringFrom(seconds: message.timeSent!)
                    self.nameLabel.text = user.name
                    
                    if let message = message.message {
                        self.previewEmailLabel.text = message
                    } else if let _ = message.videoUrl {
                        self.previewEmailLabel.text = "[Video]"
                    } else {
                        self.previewEmailLabel.text = "[Image]"
                    }

                    if let imageUrl = user.imageUrl {
                        NetworkManager.shared.downloadImage(forUrl: imageUrl) { (result) in
                            switch result {
                            case .success(let image):
                                self.userImageView.image = image
                            case .failure(_):
                                print("Error in downloading image for user in MessageVC")
                            }
                        }
                    }
                case .failure(_):
                    print("Error in getting back a user with toId")
                }
            }
        }
    }
    
    // MARK: - Subviews
    lazy var userImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 28
        iv.layer.borderWidth = 1
        iv.clipsToBounds = true
        return iv
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        return label
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private let previewEmailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        return label
    }()
    
    private let disclosureIndicator: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "chevron.right"))
        iv.tintColor = .lightGray
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout subviews methods
    func layoutViews() {
        addSubview(userImageView)
        userImageView.anchor(left: leftAnchor, paddingLeft: 10)
        userImageView.center(y: centerYAnchor)
        userImageView.setDimension(width: heightAnchor, height: heightAnchor, wMult: 0.70, hMult: 0.70)
    
        addSubview(nameLabel)
        nameLabel.setDimension(width: widthAnchor, wMult: 0.4)
        nameLabel.anchor(left: userImageView.rightAnchor, paddingLeft: 10)
        nameLabel.center(to: self, by: .centerY, withMultiplierOf: 0.5)

        addSubview(previewEmailLabel)
        previewEmailLabel.anchor(top: nameLabel.bottomAnchor, bottom: bottomAnchor, left: nameLabel.leftAnchor, paddingTop: 5, paddingBottom: 10)
        previewEmailLabel.anchor(bottom: bottomAnchor, left: nameLabel.leftAnchor, paddingBottom: 10)
        previewEmailLabel.setDimension(width: widthAnchor, wMult: 0.77)

        addSubview(disclosureIndicator)
        disclosureIndicator.anchor(top: nameLabel.topAnchor, right: previewEmailLabel.rightAnchor, paddingRight: -3)
        disclosureIndicator.setDimension(width: heightAnchor, height: heightAnchor, wMult: 0.23, hMult: 0.23)
        
        addSubview(timeLabel)
        timeLabel.anchor(right: disclosureIndicator.leftAnchor, left: nameLabel.rightAnchor)
        timeLabel.center(y: disclosureIndicator.centerYAnchor)
    }
    
    // MARK: - Helper functions
    func getDateAndTimeStringFrom(seconds: Int) -> String {
        let date = Date(timeIntervalSince1970: Double(seconds))
        dateFormatter.dateFormat = "M/dd/yy, h:mm:ss a"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
