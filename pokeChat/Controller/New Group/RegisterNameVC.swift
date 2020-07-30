//
//  RegisterVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/29/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class RegisterNameVC: UIViewController {
    var continueButtonContainerViewBottom: NSLayoutConstraint?
    
    // MARK: - Subviews
    private let instructionLabel: UILabel = {
        let label = UILabel()
        var attributedText = NSMutableAttributedString(string: "What is your name?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var continueButtonContainerView = ContinueButtonContainerView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 55))
    
    private let nameTextField = LoginRegisterTextField(placeholder: "Name", foregroundColor: .black)
    
    // MARK: - InputAccessory view
    override var inputAccessoryView: UIView? {
        get {
            return continueButtonContainerView
        }
    }

    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        continueButtonContainerView.delegate = self
        configNavbar()
        layoutInstructionLabel()
        layoutNameTextfield()
    }
    
    // MARK: - Config Navbar
    func configNavbar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(goBack))
        dismissButton.tintColor = .black
        navigationItem.leftBarButtonItems = [space, dismissButton]
    }
    
    // MARK: - Layout subviews
    func layoutInstructionLabel() {
        view.addSubview(instructionLabel)
        instructionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        instructionLabel.center(to: view, by: .centerX)
    }
    
    func layoutNameTextfield() {
        nameTextField.becomeFirstResponder()
        nameTextField.layer.borderWidth = 2
        
        view.addSubview(nameTextField)
        nameTextField.center(x: view.centerXAnchor)
        nameTextField.center(to: view, by: .centerY, withMultiplierOf: 0.7)
        nameTextField.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.8, hMult: 0.07)
        nameTextField.addTarget(self, action: #selector(handleEnteringText), for: .editingChanged)
    }
    
    // MARK: - Selectors
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleEnteringText() {
        guard let name = nameTextField.text else { return }
        let continueButton = continueButtonContainerView.continueButton
        
        if name.count >= 1 {
            continueButton.alpha = 1
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
}

// MARK: - ContinueButtonConatinerViewDelegate
extension RegisterNameVC: ContinueButtonContainerViewDelegate {
    func goToNextPage() {
        let registerEmailPasswordVC = RegisterEmailPasswordVC()
        navigationController?.pushViewController(registerEmailPasswordVC, animated: true)
    }
}
