//
//  MessageCell.swift
//  pokeChat
//
//  Created by William Yeung on 8/2/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit
import Firebase
import AVFoundation

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
    var chatVC: ChatVC?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleWidthAnchor: NSLayoutConstraint?
    let bubbleViewCornerRadius: CGFloat = 16
    var videoPlayer: AVPlayer?
    var playerLayer: AVPlayerLayer?
    
    // MARK: - Subviews
    lazy var bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = bubbleViewCornerRadius
        view.sizeToFit()
        return view
    }()
    
    lazy var chatPartnerImageView: UIImageView = {
       let iv = UIImageView()
        iv.layer.cornerRadius = (frame.size.width * 0.08) / 2
        iv.layer.borderWidth = 1
        iv.clipsToBounds = true
        return iv
    }()

    lazy var messageTextView: UITextView = {
        let tv = UITextView()
        tv.layer.cornerRadius = bubbleViewCornerRadius
        tv.isEditable = false
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    
    lazy var messageImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.isHidden = true
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 16
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFullScreen(tapGesture:))))
        return iv
    }()
    
    private lazy var playButton: UIImageView = {
        let iv = UIImageView()
        iv.tintColor = .white
        iv.image = UIImage(systemName: "play.circle.fill")
        iv.isHidden = true
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handlePlay)))
        return iv
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.color = .white
        return spinner
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    @objc func handleFullScreen(tapGesture: UITapGestureRecognizer) {
        if let imageView = tapGesture.view as? UIImageView {
            chatVC?.fullScreenImage(tappedImage: imageView)
        }
    }
    
    @objc func handlePlay() {
        guard let videoUrlString = message?.videoUrl, let videoUrl = URL(string: videoUrlString) else { return }
        
        playButton.isHidden = true
        loadingIndicator.startAnimating()
        
        videoPlayer = AVPlayer(url: videoUrl)
        playerLayer = AVPlayerLayer(player: videoPlayer)
        videoPlayer?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
        bubbleView.layer.addSublayer(playerLayer!)
        playerLayer!.frame = bubbleView.bounds
        playerLayer!.cornerRadius = 16
        playerLayer!.masksToBounds = true
        videoPlayer!.play()
    }
    
    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        playerLayer?.removeFromSuperlayer()
        videoPlayer?.pause()
        loadingIndicator.stopAnimating()
    }
    
    // MARK: - KeyValueObservers
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            self.loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: - ConfigureCell method
    func configureCell() {
        guard let messageObj = self.message else { return }
        playButton.isHidden = messageObj.videoUrl != nil ? false : true
        
        if let messageText = messageObj.message {
            messageImageView.isHidden = true
            messageTextView.isHidden = false
            messageTextView.text = messageText
        } else if messageObj.imageUrl != nil {
            NetworkManager.shared.downloadImage(forUrl: messageObj.imageUrl!) { (result) in
                switch result {
                    case .success(let image):
                        self.messageImageView.isHidden = false
                        self.messageTextView.isHidden = true
                        self.messageImageView.image = image
                    case .failure(let error):
                        print(error.rawValue)
                }
            }
        } else if messageObj.thumbnailImageUrl != nil {
            NetworkManager.shared.downloadImage(forUrl: messageObj.thumbnailImageUrl!) { (result) in
                switch result {
                    case .success(let image):
                        self.messageImageView.isHidden = false
                        self.messageTextView.isHidden = true
                        self.messageImageView.image = image
                    case .failure(let error):
                        print(error.rawValue)
                }
            }
        }
        
        if messageObj.chatPartnerId == messageObj.toId {
            messageTextView.textColor = .white
            bubbleView.backgroundColor = Constants.Color.customGray
            bubbleViewRightAnchor?.isActive = true
            bubbleViewLeftAnchor?.isActive = false
            chatPartnerImageView.isHidden = true
        } else {
            messageTextView.textColor = .black
            bubbleView.backgroundColor = #colorLiteral(red: 0.8913444877, green: 0.8954699636, blue: 0.9055526853, alpha: 1)
            bubbleViewLeftAnchor?.isActive = true
            bubbleViewRightAnchor?.isActive = false
            chatPartnerImageView.isHidden = false
        }
    }
    
    // MARK: - Layout views method
    func layoutViews() {
        addSubview(chatPartnerImageView)
        chatPartnerImageView.anchor(bottom: bottomAnchor, left: leftAnchor, paddingLeft: 8)
        chatPartnerImageView.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.08, hMult: 0.08)
        
        addSubview(bubbleView)
        bubbleView.anchor(top: topAnchor)
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 250)
        bubbleWidthAnchor?.isActive = true
        bubbleView.setDimension(height: heightAnchor)
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: chatPartnerImageView.rightAnchor, constant: 8)
        
        bubbleView.addSubview(messageImageView)
        messageImageView.anchor(top: bubbleView.topAnchor, right: bubbleView.rightAnchor, bottom: bubbleView.bottomAnchor, left: bubbleView.leftAnchor)
        
        addSubview(messageTextView)
        messageTextView.anchor(top: topAnchor, right: bubbleView.rightAnchor, left: bubbleView.leftAnchor, paddingRight: 10, paddingLeft: 10)
        messageTextView.setDimension(height: heightAnchor)
        
        addSubview(playButton)
        playButton.setDimension(width: bubbleView.widthAnchor, height: bubbleView.widthAnchor, wMult: 0.2, hMult: 0.2)
        playButton.center(x: bubbleView.centerXAnchor, y: bubbleView.centerYAnchor)
        
        addSubview(loadingIndicator)
        loadingIndicator.center(x: bubbleView.centerXAnchor, y: bubbleView.centerYAnchor)
    }
}

