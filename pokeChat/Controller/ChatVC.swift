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
    
    // MARK: - Subviews
    private lazy var inputFieldContainer: InputContainerView = {
        let view = InputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        view.backgroundColor = .white
        view.delegate = self
        return view
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "chatCell")
        cv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: inputFieldContainer.frame.height, right: 0)
        cv.scrollIndicatorInsets = UIEdgeInsets(top: 5, left: 0, bottom: inputFieldContainer.frame.height + 5, right: 0)
        cv.keyboardDismissMode = .interactive
        cv.delegate = self
        cv.dataSource = self
        return cv
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
        layoutViews()
    }
    
    // MARK: - Navbar config
    func setNavbarWithPartnerName() {
        guard let partner = chatPartner else { return }
        self.navigationItem.title = partner.name
    }
    
    // MARK: - View layout
    func layoutViews() {
        view.addSubview(collectionView)
        collectionView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
}

// MARK: - UICollectionViewDelegate/DataSource/FlowLayoutDelegate
extension ChatVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "chatCell", for: indexPath)
        cell.backgroundColor = .green
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 70)
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
