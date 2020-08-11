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
    
    // MARK: - Selectors
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

