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
    
    let messageImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "land")
        iv.contentMode = .scaleToFill
        iv.isHidden = true
        return iv
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
        guard let messageObj = self.message else { return }
        
        if let messageText = messageObj.message {
            messageImageView.isHidden = true
            messageLabel.text = messageText
        } else if messageObj.imageUrl != nil {
            NetworkManager.shared.downloadImage(forUrl: messageObj.imageUrl!) { (result) in
                switch result {
                    case .success(let image):
                        self.messageImageView.image = image
                        self.messageImageView.isHidden = false
                    case .failure(let error):
                        print(error.rawValue)
                }
            }
        }
        
        if messageObj.chatPartnerId == messageObj.toId {
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
    
    func setImageToLabel(withImage image: UIImage, height: Int, width: Int) {
        let mutableString = NSMutableAttributedString()
        let attachment = NSTextAttachment()
        attachment.image = image
        attachment.image = UIImage(cgImage: attachment.image!.cgImage!, scale: CGFloat(CGFloat(width)/bubbleView.frame.size.width), orientation: .up)
        let imageString = NSAttributedString(attachment: attachment)
        mutableString.append(imageString)
        self.messageLabel.attributedText = mutableString
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
        
        bubbleView.addSubview(messageImageView)
        messageImageView.anchor(top: bubbleView.topAnchor, right: bubbleView.rightAnchor, bottom: bubbleView.bottomAnchor, left: bubbleView.leftAnchor)
    }
}
