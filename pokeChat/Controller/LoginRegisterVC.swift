//
//  LoginRegisterVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/21/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class LoginRegisterVC: UIViewController {
    // MARK: - Subviews
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "background")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to PokeChat"
        label.textColor = .systemYellow
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let loginRegisterSementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.backgroundColor = Constants.Color.gray75Opacity
        sc.selectedSegmentIndex = 0
        let whiteText = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let grayText = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        sc.setTitleTextAttributes(whiteText, for: .normal)
        sc.setTitleTextAttributes(grayText, for: .selected)
        return sc
    }()
    
    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.gray75Opacity
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = Constants.Color.gray75Opacity
        button.layer.cornerRadius = 10
        let title = NSAttributedString(string: "Login", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20, weight: .bold)])
        button.setAttributedTitle(title, for: .normal)
        return button
    }()
    
    private let nameTextField = InputTextField(placeholder: "Name")
    private let emailTextField = InputTextField(placeholder: "Email")
    private let passwordTextField = InputTextField(placeholder: "Password")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }
    
    // MARK: - Layout methods
    func layoutViews() {
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
        
        view.addSubview(titleLabel)
        titleLabel.setDimension(width: view.widthAnchor, wMult: 0.85)
        titleLabel.center(x: view.centerXAnchor)
        titleLabel.center(to: view, by: .centerY, withMultiplierOf: 0.5)
        
        view.addSubview(loginRegisterSementedControl)
        loginRegisterSementedControl.center(x: view.centerXAnchor, y: view.centerYAnchor, yPadding: -15)
        loginRegisterSementedControl.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.9, hMult: 0.04)
        
        view.addSubview(inputContainerView)
        inputContainerView.anchor(top: loginRegisterSementedControl.bottomAnchor, paddingTop: 15)
        inputContainerView.setDimension(width: loginRegisterSementedControl.widthAnchor, height: view.heightAnchor, hMult: 0.15)
        inputContainerView.center(x: view.centerXAnchor)
        
        view.addSubview(loginRegisterButton)
        loginRegisterButton.anchor(top: inputContainerView.bottomAnchor, paddingTop: 15)
        loginRegisterButton.setDimension(width: loginRegisterSementedControl.widthAnchor, height: view.heightAnchor, hMult: 0.05)
        loginRegisterButton.center(x: view.centerXAnchor)
        
        inputContainerView.addSubview(nameTextField)
        nameTextField.anchor(top: inputContainerView.topAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        nameTextField.setDimension(height: inputContainerView.heightAnchor, hMult: 0.333)
        
        inputContainerView.addSubview(emailTextField)
        emailTextField.anchor(top: nameTextField.bottomAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        emailTextField.setDimension(height: inputContainerView.heightAnchor, hMult: 0.333)
        
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        passwordTextField.setDimension(height: inputContainerView.heightAnchor, hMult: 0.333)
    }
}
