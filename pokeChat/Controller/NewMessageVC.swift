//
//  NewMessageVCViewController.swift
//  pokeChat
//
//  Created by William Yeung on 7/25/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class NewMessageVC: UIViewController {
    // MARK: - Variables/constants
    var users = [User]()
    var messageVC: MessageVC?
    
    // MARK: - Subviews
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseId)
        tv.delegate = self
        tv.dataSource = self
        return tv
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        layoutViews()
        getAllUsers()
    }
    
    // MARK: - NavBar methods
    func configureNavBar() {
        navigationController?.navigationBar.tintColor = .systemGreen
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
    }
    
    // MARK: - Subviews layout methods
    func layoutViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    // MARK: - Fetching methods
    func getAllUsers() {
        DatabaseManager.shared.getAllUsers { (result) in
            switch result {
            case .success(let users):
                self.users = users
                self.tableView.reloadData()
            case .failure(_):
                print("Couldn't get all users")
            }
        }
    }
    
    // MARK: - Selector methods
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate and Datasource
extension NewMessageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseId, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        messageVC?.goToChatVC(user: users[indexPath.row])
    }
}
