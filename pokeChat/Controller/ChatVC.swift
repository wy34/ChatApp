//
//  ChatVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/26/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class ChatVC: UICollectionViewController {
    // MARK: - Variables/Constants
    var chatPartner: User?
    var inputFieldContainerBottom: NSLayoutConstraint?
    
    // MARK: - Subviews
    private lazy var inputFieldContainer: MessageInputContainerView = {
        let view = MessageInputContainerView()
        view.backgroundColor = .white
        view.delegate = self
        return view
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbarWithPartnerName()
        setupCollectionView()
        layoutInputAccessoryView()
        addKBObserver()
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
    
    // MARK: - Selectors
    @objc func handleKBWilShow(notification: Notification) {
        if let frame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let rect = frame.cgRectValue
            let height = rect.height
            
            inputFieldContainerBottom?.constant = -height
            view.layoutIfNeeded()
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
    func setupCollectionView() {
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "chatCell")
        collectionView.backgroundColor = .white
        collectionView.keyboardDismissMode = .interactive
        collectionView.delegate = self
        collectionView.dataSource = self
    }
}

// MARK: - UICollectionViewDelegate/DataSource/FlowLayoutDelegate
extension ChatVC: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
}

// MARK: - InputContainerViewDelegate
extension ChatVC: InputContainerViewDelegate {
    func send(message: String, inputField: UITextView) {
        guard let toId = chatPartner?.id else { return }
        DatabaseManager.shared.addMessage(of: message, toId: toId) { (result) in
            switch result {
            case .success(_):
                print("Message sent!")
                inputField.text = ""
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
}
