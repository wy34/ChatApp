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
    var messageVC: MessageVC?
    
    // MARK: - Subviews
    private let backgroundImageView = UIImageView()
    private let profileImageView = UIImageView()
    private let titleLabel = UILabel()
    private let loginRegisterSementedControl = LoginRegisterSegmentedControl(items: ["Login", "Register"])
    private let inputContainerView = UIView()
    private let loginRegisterButton = LoginButton(type: .system)
    private let nameTextField = InputTextField(placeholder: "Name")
    private let separator1 = SeparatorView()
    private let emailTextField = InputTextField(placeholder: "Email")
    private let separator2 = SeparatorView()
    private let passwordTextField = InputTextField(placeholder: "Password")
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    // MARK: - Subview configuration methods
    func setupSubviews() {
        setupBackgroundImageView()
        setupTitleLabel()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
        setupInputContainerView()
        setupLoginRegisterButton()
        setupInputTextFields()
        setupInputSeparators()
    }
    
    func setupBackgroundImageView() {
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.alpha = 0.5
        
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
    }
    
    func setupTitleLabel() {
        titleLabel.text = "Welcome to PokeChat"
        titleLabel.textColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 0.8)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        titleLabel.adjustsFontSizeToFitWidth = true
        
        view.addSubview(titleLabel)
        titleLabel.center(x: view.centerXAnchor)
        titleLabel.center(to: view, by: .centerY, withMultiplierOf: 0.5)
    }
    
    func setupProfileImageView() {
        profileImageView.image = UIImage(systemName: "plus.square")
        profileImageView.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.701171875)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePickerView)))
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true

        view.addSubview(profileImageView)
        profileImageView.alpha = 0
        profileImageView.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.4, hMult: 0.4)
        profileImageView.center(x: view.centerXAnchor)
        profileImageView.center(to: view, by: .centerY, withMultiplierOf: 0.5)
    }
    
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSementedControl.addTarget(self, action: #selector(handleSegmentSwitch), for: .valueChanged)
        
        view.addSubview(loginRegisterSementedControl)
        loginRegisterSementedControl.center(x: view.centerXAnchor, y: view.centerYAnchor, yPadding: -15)
        loginRegisterSementedControl.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.9, hMult: 0.04)
    }
    
    func setupInputContainerView() {
        inputContainerView.backgroundColor = Constants.Color.gray75Opacity
        inputContainerView.layer.cornerRadius = 10
        
        view.addSubview(inputContainerView)
        inputContainerView.anchor(top: loginRegisterSementedControl.bottomAnchor, paddingTop: 15)
        inputContainerView.setDimension(width: loginRegisterSementedControl.widthAnchor)
        inputContainerView.center(x: view.centerXAnchor)
        inputContainerHeightAnchor = inputContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.1)
        inputContainerHeightAnchor?.isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        view.addSubview(loginRegisterButton)
        loginRegisterButton.anchor(top: inputContainerView.bottomAnchor, paddingTop: 15)
        loginRegisterButton.setDimension(width: loginRegisterSementedControl.widthAnchor, height: view.heightAnchor, hMult: 0.05)
        loginRegisterButton.center(x: view.centerXAnchor)
    }
    
    func setupInputTextFields() {
        inputContainerView.addSubview(nameTextField)
        nameTextField.anchor(top: inputContainerView.topAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(emailTextField)
        emailTextField.anchor(top: nameTextField.bottomAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.5)
        emailTextFieldHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(passwordTextField)
        passwordTextField.anchor(top: emailTextField.bottomAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor)
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 0.5)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    func setupInputSeparators() {
        inputContainerView.addSubview(separator1)
        separator1.alpha = 0
        separator1.setDimension(hConst: 1)
        separator1.anchor(top: nameTextField.bottomAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor, paddingRight: 5, paddingLeft: 5)
        
        inputContainerView.addSubview(separator2)
        separator2.setDimension(hConst: 1)
        separator2.anchor(top: emailTextField.bottomAnchor, right: inputContainerView.rightAnchor, left: inputContainerView.leftAnchor, paddingRight: 5, paddingLeft: 5)
    }
    
    // MARK: - Selectors
    @objc func handleSegmentSwitch() {
        nameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        profileImageView.image = UIImage(systemName: "plus.square")
        
        let selectedIndex = loginRegisterSementedControl.selectedSegmentIndex
        
        loginRegisterButton.setTitle(loginRegisterSementedControl.titleForSegment(at: selectedIndex), for: .normal)
        
        titleLabel.alpha = selectedIndex == 0 ? 1 : 0
        
        profileImageView.alpha = selectedIndex == 0 ? 0 : 1
        
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
    
    @objc func showImagePickerView() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true)
    }
    
    @objc func handleLoginRegister() {
        if loginRegisterSementedControl.selectedSegmentIndex == 0 {
            login()
        } else {
            register()
        }
    }
    
    // MARK: - Login/Register functions
    func login() {
        guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else { return }
        Authentication.shared.signIn(withEmail: email, andPassword: password) { (result) in
            switch result {
                case .success(_):
                    self.dismiss(animated: true, completion: nil)
                    self.messageVC?.getCurrentUser()
                    self.messageVC?.getAllMessages()
                case .failure(let error):
                    print(error.rawValue)
            }
        }
    }
    
    func register() {
        guard let image = profileImageView.image, let name = nameTextField.text, let email = emailTextField.text, let password = passwordTextField.text,
        !name.isEmpty, !email.isEmpty, !password.isEmpty else { return }
        Authentication.shared.register(withName: name, email: email, password: password, andImage: image) { (result) in
            switch result {
                case .success(_):
                    self.dismiss(animated: true, completion: nil)
                    self.messageVC?.getCurrentUser()
                    self.messageVC?.getAllMessages()
                case .failure(let error):
                    print(error.rawValue)
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate
extension LoginRegisterVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        self.profileImageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
}
