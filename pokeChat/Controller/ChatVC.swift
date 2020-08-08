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
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.separatorStyle = .none
        tv.register(MessageCell.self, forCellReuseIdentifier: "id")
        tv.delegate = self
        tv.dataSource = self
        return tv
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
        layoutTableView()
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
                    self.tableView.reloadData()
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
    
    // MARK: - TableView configuration
    func layoutTableView() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: inputFieldContainer.topAnchor, left: view.leftAnchor)
    }
    
    func scrollToBottom() {
        if messages.count >= 1 {
            let lastIndex = IndexPath(row: messages.count - 1, section: 0)
            tableView.scrollToRow(at: lastIndex, at: .bottom, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate/Datasource
extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! MessageCell
        cell.selectionStyle = .none
        cell.message = messages[indexPath.row]
        cell.chatPartner = chatPartner
        return cell
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

