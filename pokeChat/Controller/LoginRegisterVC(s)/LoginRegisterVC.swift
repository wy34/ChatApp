//
//  LoginRegisterVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/21/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit
import Firebase

class LoginRegisterVC: UIViewController {
      // MARK: - Properties
      var messageVC: MessageVC?
    
    // MARK: - Subviews
    private let appLogoImageView = UIImageView(image: UIImage(named: "pokeball"))
    private let titleLabel = UILabel()
    private let signpButton = CustomButton(title: "Sign up", bgColor: Constants.Color.customGray)
    private let loginButton = CustomButton(title: "Log in", textColor: Constants.Color.customGray)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLogo()
        setupTitleLabel()
        setuptButtons()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser != nil {
            dismiss(animated: true, completion: nil)
            self.messageVC?.getCurrentUser()
            self.messageVC?.getAllMessages()
        }
    }
    
    // MARK: - View Configuration
    func setupLogo() {
        view.addSubview(appLogoImageView)
        appLogoImageView.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.35, hMult: 0.35)
        appLogoImageView.center(to: view, by: .centerY, withMultiplierOf: 0.75)
        appLogoImageView.center(x: view.centerXAnchor)
    }
    
    func setupTitleLabel() {
        titleLabel.text = "Welcome to PokeChat"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        view.addSubview(titleLabel)
        titleLabel.setDimension(width: view.widthAnchor, wMult: 0.8)
        titleLabel.center(x: view.centerXAnchor)
        titleLabel.center(to: view, by: .centerY, withMultiplierOf: 1.1)
    }
    
    func setuptButtons() {
        view.addSubview(loginButton)
        loginButton.addTarget(self, action: #selector(loginPressed), for: .touchUpInside)
        loginButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 15)
        loginButton.center(x: view.centerXAnchor)
        loginButton.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.8, hMult: 0.05)
        
        view.addSubview(signpButton)
        signpButton.layer.cornerRadius = (view.frame.height * 0.05) / 2
        signpButton.addTarget(self, action: #selector(signupPressed), for: .touchUpInside)
        signpButton.anchor(bottom: loginButton.topAnchor, paddingBottom: 5)
        signpButton.center(x: view.centerXAnchor)
        signpButton.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.8, hMult: 0.05)
    }
    
    // MARK: - Login/Register function
    @objc func loginPressed() {
        let loginVC = LoginVC()
        let nav = UINavigationController(rootViewController: loginVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc func signupPressed() {
        let nameAvatarVC = RegisterAvatarVC()
        let nav = UINavigationController(rootViewController: nameAvatarVC)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
}
