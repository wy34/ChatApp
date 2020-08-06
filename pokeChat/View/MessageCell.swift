//
//  MessageCell.swift
//  pokeChat
//
//  Created by William Yeung on 8/2/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {
    // MARK: - Properties
    var message: Message? {
        didSet {
            configureCell()
        }
    }
    
    var chatPartner: User? {
        didSet {
            guard let user = chatPartner else { return }
            NetworkManager.shared.downloadImage(forUrl: user.imageUrl!) { (result) in
                switch result {
                    case .success(let image):
                        self.chatPartnerImageView.image = image
                    case .failure(let error):
                        print(error.rawValue)
                }
            }
        }
    }
    
    static let reuseId = "messageCell"
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    let bubbleViewCornerRadius: CGFloat = 16
    
    // MARK: - Subviews
    lazy var bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = bubbleViewCornerRadius
        view.sizeToFit()
        return view
    }()
    
    lazy var chatPartnerImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "hippo")
        iv.layer.cornerRadius = (frame.size.width * 0.07) / 2
        iv.layer.borderWidth = 1
        iv.clipsToBounds = true
        return iv
    }()

    lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = bubbleViewCornerRadius
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigureCell method
    func configureCell() {
        guard let message = self.message else { return }
        messageLabel.text = message.message
        
        if message.chatPartnerId == message.toId {
            messageLabel.textColor = .white
            bubbleView.backgroundColor = Constants.Color.customGray
            bubbleViewRightAnchor?.isActive = true
            bubbleViewLeftAnchor?.isActive = false
            chatPartnerImageView.isHidden = true
        } else {
            messageLabel.textColor = .black
            bubbleView.backgroundColor = #colorLiteral(red: 0.8913444877, green: 0.8954699636, blue: 0.9055526853, alpha: 1)
            bubbleViewLeftAnchor?.isActive = true
            bubbleViewRightAnchor?.isActive = false
            chatPartnerImageView.isHidden = false
        }
    }
    
    // MARK: - Layout views method
    func layoutViews() {
        addSubview(chatPartnerImageView)
        chatPartnerImageView.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.07, hMult: 0.07)
        chatPartnerImageView.anchor(bottom: bottomAnchor, left: leftAnchor, paddingBottom: 10, paddingLeft: 10)
        
        addSubview(bubbleView)
        bubbleView.anchor(top: topAnchor, bottom: chatPartnerImageView.bottomAnchor, paddingTop: 16)
        bubbleView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.75).isActive = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: chatPartnerImageView.rightAnchor, constant: 10)
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        
        bubbleView.addSubview(messageLabel)
        messageLabel.anchor(top: bubbleView.topAnchor, right: bubbleView.rightAnchor, bottom: bubbleView.bottomAnchor, left: bubbleView.leftAnchor, paddingTop: 10, paddingRight: 15, paddingBottom: 10, paddingLeft: 15)
    }
}
