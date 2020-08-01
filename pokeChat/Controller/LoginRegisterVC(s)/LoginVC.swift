//
//  LoginVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/31/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class LoginVC: ClearNavBarViewController{
    // MARK: - Subviews
    let instructionLabel: UILabel = {
        let label = UILabel()
        var attributedText = NSMutableAttributedString(string: "Enter your email and password", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let emailTextField = LoginRegisterTextField(placeholder: "Email", foregroundColor: .black)
    private let passwordTextField = LoginRegisterTextField(placeholder: "Password", foregroundColor: .black)
    lazy var continueButtonContainerView = ContinueButtonContainerView(title: "Submit", frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 55))

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        continueButtonContainerView.delegate = self
        configNavbar(withButtonImageName: "xmark.circle", andButtonAction: #selector(goBack))
        layoutInstructionLabel()
        layoutEmailTextfield()
        layoutPasswordTextField()
    }

    // MARK: - Input Accessory view
    override var inputAccessoryView: UIView? {
        get {
            return continueButtonContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Layout views
    func layoutInstructionLabel() {
        view.addSubview(instructionLabel)
        instructionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        instructionLabel.setDimension(width: view.widthAnchor, wMult: 0.8)
        instructionLabel.center(to: view, by: .centerX)
    }
    
    func layoutEmailTextfield() {
        emailTextField.delegate = self
        emailTextField.layer.borderWidth = 2
        emailTextField.returnKeyType = .next
        emailTextField.becomeFirstResponder()
        
        view.addSubview(emailTextField)
        emailTextField.center(x: view.centerXAnchor)
        emailTextField.center(to: view, by: .centerY, withMultiplierOf: 0.64)
        emailTextField.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.8, hMult: 0.07)
        emailTextField.addTarget(self, action: #selector(handleEnteringText), for: .editingChanged)
    }
    
    func layoutPasswordTextField() {
        passwordTextField.delegate = self
        passwordTextField.layer.borderWidth = 2
        passwordTextField.returnKeyType = .go
        
        view.addSubview(passwordTextField)
        passwordTextField.center(x: view.centerXAnchor)
        passwordTextField.center(to: view, by: .centerY, withMultiplierOf: 0.84)
        passwordTextField.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.8, hMult: 0.07)
        passwordTextField.addTarget(self, action: #selector(handleEnteringText), for: .editingChanged)
    }
    
    // MARK: - Selectors
    @objc func goBack() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleEnteringText() {
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            continueButtonContainerView.continueButton.alpha = 0.5
            continueButtonContainerView.continueButton.isEnabled = false
            return
        }
        continueButtonContainerView.continueButton.alpha = 1
        continueButtonContainerView.continueButton.isEnabled = true
    }
}

// MARK: - ContinueButtonContainerViewDelegate
extension LoginVC: ContinueButtonContainerViewDelegate {
    func goToNextPage() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
     
        AuthManager.shared.signIn(withEmail: email, andPassword: password) { (result) in
            switch result {
            case .success(_):
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print(error.rawValue)
            }
        }
    }
}

// MARK: - UITextfieldDelegate
extension LoginVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            goToNextPage()
        default:
            break
        }
        
        return true
    }
}
