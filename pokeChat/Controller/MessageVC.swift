//
//  ViewController.swift
//  pokeChat
//
//  Created by William Yeung on 7/21/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit
import Firebase

class MessageVC: UIViewController {
    // MARK: - Variables/Constants
    var messages = [Message]()
    var name = "William"
    
    // MARK: - Subviews: main
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseId)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()
    
    // MARK: - Subviews: navBar
    private let customTitleViewContainer = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
    private let customTitleView = UIView()
    private let titleViewNameLabel = UILabel()
    private let titleViewImageView = UIImageView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
        layoutViews()
        perform(#selector(checkIfUserIsLoggedIn), with: nil, afterDelay: 0)
        getAllMessages()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkIfUserIsLoggedIn()
    }
    
    // MARK: - Login methods
    @objc func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            logoutPressed()
        } else {
            getCurrentUser()
        }
    }
    
    // MARK: - Fetching methods
    func getCurrentUser() {
        DatabaseManager.shared.getCurrentUser { (result) in
            switch result {
                case .success(let user):
                    self.displayUserInNavBar(user: user)
                case .failure(_):
                    print("Error in getting current user")
            }
        }
    }
    
    func getAllMessages() {
        DatabaseManager.shared.getAllMessages { (result) in
            switch result {
            case .success(let messages):
                self.messages = messages
                self.tableView.reloadData()
            case .failure(_):
                print("Error in getting all messages back")
            }
        }
    }
    
    // MARK: - NavigationBar methods
    func setupNavBarButtons() {
        navigationController?.navigationBar.tintColor = .systemGreen
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMessagePressed))
    }
    
    func displayUserInNavBar(user: User) {
        customTitleView.addSubview(titleViewImageView)
        downloadTitleViewImage(imageUrl: user.imageUrl!)
        titleViewImageView.contentMode = .scaleAspectFill
        titleViewImageView.clipsToBounds = true
        titleViewImageView.layer.cornerRadius = 17
        titleViewImageView.anchor(top: customTitleView.topAnchor, bottom: customTitleView.bottomAnchor, left: customTitleView.leftAnchor)
        titleViewImageView.setDimension(width: customTitleView.heightAnchor, wMult: 1)
        
        customTitleView.addSubview(titleViewNameLabel)
        titleViewNameLabel.anchor(top: customTitleView.topAnchor, right: customTitleView.rightAnchor, bottom: customTitleView.bottomAnchor, left: titleViewImageView.rightAnchor, paddingLeft: 10)
        titleViewNameLabel.text = user.name
        
        customTitleViewContainer.addSubview(customTitleView)
        customTitleView.center(to: customTitleViewContainer, by: .centerX, withMultiplierOf: 1)
        customTitleView.setDimension(height: customTitleViewContainer.heightAnchor, hMult: 0.8)
        self.navigationItem.titleView = customTitleViewContainer
    }
    
    func downloadTitleViewImage(imageUrl: String) {
        NetworkManager.shared.downloadImage(forUrl: imageUrl) { (result) in
            switch result {
            case .success(let image):
                self.titleViewImageView.image = image
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
    
    // MARK: - Layout methods
    func layoutViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    // MARK: - Selector methods
    @objc func logoutPressed() {
        do {
            try Auth.auth().signOut()
            let loginRegisterVC = LoginRegisterVC()
            loginRegisterVC.messageVC = self
            loginRegisterVC.modalPresentationStyle = .fullScreen
            present(loginRegisterVC, animated: true) { self.titleViewImageView.image = nil}
        } catch {
            print("\(error) - Error signing out user")
        }
    }
    
    @objc func newMessagePressed() {
        let newMessageVC = NewMessageVC()
        newMessageVC.messageVC = self
        let nav = UINavigationController(rootViewController: newMessageVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}

// MARK: - UITableView
extension MessageVC: UITableViewDelegate, UITableViewDataSource {
    func goToChatVC(user: User) {
        let chatVC = ChatVC(collectionViewLayout: UICollectionViewFlowLayout())
        chatVC.chatPartner = user
        navigationController?.pushViewController(chatVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseId, for: indexPath) as! UserCell
        cell.message = messages[indexPath.item]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chatPartnerId = messages[indexPath.row].chatPartnerId else { return }
        DatabaseManager.shared.getUserWith(id: chatPartnerId) { (result) in
            switch result {
            case .success(let user):
                self.goToChatVC(user: user)
                tableView.deselectRow(at: indexPath, animated: true)
            case .failure(_):
                print("Error in getting partner user to pass into ChatVc")
            }
        }
    }
}
