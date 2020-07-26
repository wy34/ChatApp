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
    
    
    // MARK: - Subviews: main
    private let tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
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
        checkIfUserIsLoggedIn()
    }
    
    // MARK: - Login methods
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            let loginRegisterVc = LoginRegisterVC()
            loginRegisterVc.modalPresentationStyle = .fullScreen
            present(loginRegisterVc, animated: true)
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
    
    // MARK: - NavigationBar methods
    func setupNavBarButtons() {
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
        print("new message")
    }
}

