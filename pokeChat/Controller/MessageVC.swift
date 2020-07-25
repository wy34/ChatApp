//
//  ViewController.swift
//  pokeChat
//
//  Created by William Yeung on 7/21/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit
import FirebaseAuth

class MessageVC: UIViewController {
    // MARK: - Variables/Constants
    
    
    // MARK: - Subviews
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        return tv
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarButtons()
        layoutViews()
        checkIfUserIsLoggedIn()
    }
    
    // MARK: - Login methods
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            let loginRegisterVc = LoginRegisterVC()
            loginRegisterVc.modalPresentationStyle = .fullScreen
            present(loginRegisterVc, animated: true)
        }
    }
    
    // MARK: - NavigationBar methods
    func setupNavBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newMessagePressed))
    }
    
    // MARK: - Layout methods
    func layoutViews() {
        view.addSubview(tableView)
        tableView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    // MARK: - Selector methods
    @objc func logoutPressed() {
        print("slfjals")
    }
    
    @objc func newMessagePressed() {
        print("new message")
    }
}

