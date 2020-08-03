//
//  MessageCell.swift
//  pokeChat
//
//  Created by William Yeung on 8/2/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
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
    
    // MARK: - Subviews
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        view.layer.cornerRadius = 16
        return view
    }()
    
    lazy var chatPartnerImageView: UIImageView = {
       let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "hippo")
        iv.layer.cornerRadius = (frame.size.height * 0.4) / 2
        iv.layer.borderWidth = 1
        iv.clipsToBounds = true
        return iv
    }()
    
    let messageTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.isEditable = false
        return tv
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ConfigureCell method
    func configureCell() {
        guard let message = self.message else { return }
        
        messageTextView.text = message.message
        
        if message.chatPartnerId == message.toId {
            bubbleViewRightAnchor?.isActive = true
            bubbleViewLeftAnchor?.isActive = false
            chatPartnerImageView.isHidden = true
        } else {
            bubbleViewLeftAnchor?.isActive = true
            bubbleViewRightAnchor?.isActive = false
            chatPartnerImageView.isHidden = false
        }
    }
    
    // MARK: - Layout views method
    func layoutViews() {
        addSubview(chatPartnerImageView)
        chatPartnerImageView.setDimension(width: heightAnchor, height: heightAnchor, wMult: 0.4, hMult: 0.4)
        chatPartnerImageView.anchor(bottom: bottomAnchor, left: leftAnchor, paddingBottom: 10, paddingLeft: 10)
        
        addSubview(bubbleView)
        bubbleView.anchor(bottom: chatPartnerImageView.bottomAnchor)
        bubbleView.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.5, hMult: 0.8)
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: chatPartnerImageView.rightAnchor, constant: 10)
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        
        bubbleView.addSubview(messageTextView)
        messageTextView.anchor(top: bubbleView.topAnchor, right: bubbleView.rightAnchor, bottom: bubbleView.bottomAnchor, left: bubbleView.leftAnchor)
    }
}
