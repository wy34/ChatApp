//
//  ChatVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/26/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    // MARK: - Variables/Constants
    var chatPartner: User?
    var inputFieldContainerBottom: NSLayoutConstraint?
    var messages = [Message]()
    
    // MARK: - Zoom in/out image messages variables
    var startingImageView: UIImageView?
    var startingImageViewFrame: CGRect?
    var fullScreenImageView: UIImageView?
    var blackBackgroundView: UIView?
    
    // MARK: - Subviews
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseId)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var inputFieldContainer: MessageInputContainerView = {
        let view = MessageInputContainerView()
        view.backgroundColor = .white
        view.chatPartner = self.chatPartner
        view.delegate = self
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbarWithPartnerName()
        layoutInputAccessoryView()
        layoutCollectionView()
        addKBObserver()
        getAllMessages()
    }
    
    // MARK: - Input Accessory
    func layoutInputAccessoryView() {
        view.addSubview(inputFieldContainer)
        inputFieldContainer.anchor(right: view.rightAnchor, left: view.leftAnchor)
        inputFieldContainerBottom = inputFieldContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        inputFieldContainerBottom?.isActive = true
    }
    
    func addKBObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKBWilShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKBWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Fetch methods
    func getAllMessages() {
        guard let chatPartner = self.chatPartner else { return }
        DatabaseManager.shared.getAllMessages(chatPartner: chatPartner) { (result) in
            switch result {
            case .success(let messages):
                self.messages = messages
                self.collectionView.reloadData()
                self.scrollToBottom()
            case .failure(_):
                print("Cannot fetch messages")
            }
        }
    }
    
    // MARK: - Navbar config
    func setNavbarWithPartnerName() {
        guard let partner = chatPartner else { return }
        self.navigationItem.title = partner.name
    }
    
    // MARK: - CollectionView configuration
    func layoutCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: inputFieldContainer.topAnchor, left: view.leftAnchor)
    }
    
    func scrollToBottom() {
        if messages.count >= 1 {
            let lastIndex = IndexPath(row: messages.count - 1, section: 0)
            collectionView.scrollToItem(at: lastIndex, at: .bottom, animated: true)
        }
    }
    
    // MARK: - ImageFullScreen method
    func fullScreenImage(tappedImage: UIImageView) {
        startingImageView = tappedImage
        startingImageViewFrame = tappedImage.superview?.convert(tappedImage.frame, to: nil) // gives x,y,w,h (startingImageView.frame doesnt give position????)
        tappedImage.isHidden = true
        
        if let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            fullScreenImageView = UIImageView(frame: startingImageViewFrame!)
            fullScreenImageView!.isUserInteractionEnabled = true
            fullScreenImageView!.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissFullScreen(tapGesture:))))
            fullScreenImageView!.image = tappedImage.image
            
            blackBackgroundView = UIView(frame: keyWindow.frame)
            blackBackgroundView!.backgroundColor = .black
            blackBackgroundView!.alpha = 0
            
            keyWindow.addSubview(blackBackgroundView!)
            keyWindow.addSubview(fullScreenImageView!)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.inputFieldContainer.inputTextView.resignFirstResponder()
                self.blackBackgroundView!.alpha = 1
                let fullScreenImageHeight = (tappedImage.frame.height / tappedImage.frame.width) * keyWindow.frame.width
                self.fullScreenImageView!.frame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: fullScreenImageHeight)
                self.fullScreenImageView!.center = keyWindow.center
            }, completion: nil)
        }
    }
    
    // MARK: - Selectors
    @objc func dismissFullScreen(tapGesture: UITapGestureRecognizer) {
        if let fullScreenImageView = tapGesture.view as? UIImageView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                fullScreenImageView.frame = self.startingImageViewFrame!
                self.blackBackgroundView!.alpha = 0
                fullScreenImageView.layer.cornerRadius = 16
                fullScreenImageView.clipsToBounds = true
            }) { (Bool) in
                self.startingImageView?.isHidden = false
                fullScreenImageView.removeFromSuperview()
                self.blackBackgroundView?.removeFromSuperview()
            }
        }
    }
    
    @objc func handleKBWilShow(notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let rect = frame.cgRectValue
            let height = rect.height
            
            inputFieldContainerBottom?.constant = -height
            view.layoutIfNeeded()
            scrollToBottom()
        }
    }
    
    @objc func handleKBWillHide(notification: Notification) {
        if let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            UIView.animate(withDuration: duration) {
                self.inputFieldContainerBottom?.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - UICollectionViewDelegate/Datasource/FlowLayoutDelegate
extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseId, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.item]
        cell.chatPartner = chatPartner
        cell.chatVC = self
        cell.backgroundColor = .blue
        
        if let text = messages[indexPath.item].message {
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
        } else if messages[indexPath.item].imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 250
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.item]
        
        if let text = message.message {
            height = estimateFrameForText(text: text).height + 20
        } else if let imageHeight = message.imageHeight, let imageWidth = message.imageWidth {
            height = CGFloat(Float(imageHeight) / Float(imageWidth) * 250)
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    
    func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 250, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}

// MARK: - InputContainerViewDelegate
extension ChatVC: InputContainerViewDelegate {
    func present(optionSheet: UIAlertController) {
        present(optionSheet, animated: true)
    }
    
    func dismissImagePicker() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func present(imagePicker: UIImagePickerController) {
        self.present(imagePicker, animated: true)
    }
    
    func moveMessagesAboveInputContainer() {
        self.scrollToBottom()
    }
    
    func send(message: String, inputField: UITextView) {
        guard let toId = chatPartner?.id else { return }
        let properties = ["message": message] as [String: AnyObject]
        DatabaseManager.shared.addMessage(withProperties: properties, toId: toId) { (result) in
            switch result {
            case .success(_):
                print("Message sent!")
                inputField.text = ""
                self.inputFieldContainer.placeholderLabel.isHidden = false
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
}

