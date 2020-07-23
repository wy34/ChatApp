//
//  LoginRegisterVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/21/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class LoginRegisterVC: UIViewController {
    // MARK: - Variables/constants
    var inputContainerHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
    // MARK: - Subviews
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "background")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let addImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "addImage")
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
        sc.addTarget(self, action: #selector(handleSegmentSwitch), for: .valueChanged)
        return sc
    }()
    
    private let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Color.gray75Opacity
        view.layer.cornerRadius = 10
        return view
    }()
    
    private let loginRegisterButton = LoginButton(type: .system)
    private let nameTextField = InputTextField(placeholder: "Name")
    private let separator1 = SeparatorView()
    private let emailTextField = InputTextField(placeholder: "Email")
    private let separator2 = SeparatorView()
    private let passwordTextField = InputTextField(placeholder: "Password")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }
    
    // MARK: - Selectors
    @objc func handleSegmentSwitch() {
        let selectedIndex = loginRegisterSementedControl.selectedSegmentIndex
        
        loginRegisterButton.setTitle(loginRegisterSementedControl.titleForSegment(at: selectedIndex), for: .normal)
        
        inputContainerHeightAnchor?.isActive = false
        inputContainerHeightAnchor = inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: selectedIndex == 0 ? 0.1 : 0.15)
        inputContainerHeightAnchor?.isActive = true
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: selectedIndex == 0 ? 0 : 0.333)
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: selectedIndex == 0 ? 0.5 : 0.333)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: selectedIndex == 0 ? 0.5 : 0.333)
        passwordTextFieldHeightAnchor?.isActive = true
        
        separator1.alpha = selectedIndex == 0 ? 0 : 1
    }
    
    // MARK: - Layout method
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
        inputContainerView.setDimension(width: loginRegisterSementedControl.widthAnchor)
        inputContainerView.center(x: view.centerXAnchor)
        inputContainerHeightAnchor = inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        inputContainerHeightAnchor?.isActive = true
        
        view.addSubview(loginRegisterButton)
        loginRegisterButton.anchor(top: inputContainerView.bottomAnchor, paddingTop: 15)
        loginRegisterButton.setDimension(width: loginRegisterSementedControl.widthAnchor, height: view.heightAnchor, hMult: 0.05)
        loginRegisterButton.center(x: view.centerXAnchor)
        
        inputContainerView.addSubview(nameTextField)
        nameTextField.anchor(top: inputContainerView.topAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(separator1)
        separator1.alpha = 0
        separator1.setDimension(hConst: 1)
        separator1.anchor(top: nameTextField.bottomAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        
        inputContainerView.addSubview(emailTextField)
        emailTextField.anchor(top: nameTextField.bottomAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.5)
        emailTextFieldHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(separator2)
        separator2.setDimension(hConst: 1)
        separator2.anchor(top: emailTextField.bottomAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.5)
        passwordTextFieldHeightAnchor?.isActive = true
    }
}
