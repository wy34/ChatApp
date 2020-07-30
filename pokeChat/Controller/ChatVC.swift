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
    
    // MARK: - Subviews
    private lazy var inputFieldContainer: MessageInputContainerView = {
        let view = MessageInputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        view.backgroundColor = .white
        view.delegate = self
        return view
    }()
    
    // MARK: - Input Accessory
    override var inputAccessoryView: UIView? {
        get {
            return inputFieldContainer
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavbarWithPartnerName()
        setupCollectionView()
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
extension ChatVC: UICollectionViewDelegateFlowLayout { // }{: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
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
    func send(message: String, inputField: UITextField) {
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
