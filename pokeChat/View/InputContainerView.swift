//
//  InputContainerView.swift
//  pokeChat
//
//  Created by William Yeung on 7/27/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

protocol InputContainerViewDelegate {
    func send(message: String, inputField: UITextField)
}

class InputContainerView: UIView {
    // MARK: - Properties
    var delegate: InputContainerViewDelegate?
    
    // MARK: - Subviews
    private let textFieldButtonContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 19
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        button.layer.cornerRadius = 14
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    private lazy var inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a message..."
        tf.delegate = self
        return tf
    }()
    
    private let photoPickerButton: UIButton = {
        let button = UIButton(type: .system)
        let largeFont = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
        button.setImage(UIImage(systemName: "photo", withConfiguration: largeFont), for: .normal)
        return button
    }()
    
    private let inputContainerBorder = SeparatorView(backgroundColor: .lightGray)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View layout
    func layoutViews() {
        addSubview(textFieldButtonContainer)
        textFieldButtonContainer.center(to: self, by: .centerY, withMultiplierOf: 0.8)
        textFieldButtonContainer.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.8, hMult: 0.5)
        textFieldButtonContainer.anchor(right: rightAnchor, paddingRight: 15)
        
        textFieldButtonContainer.addSubview(sendButton)
        sendButton.setDimension(width: textFieldButtonContainer.heightAnchor, height: textFieldButtonContainer.heightAnchor, wMult: 0.8, hMult: 0.8)
        sendButton.anchor(right: textFieldButtonContainer.rightAnchor, paddingRight: 5)
        sendButton.center(y: textFieldButtonContainer.centerYAnchor)
        
        textFieldButtonContainer.addSubview(inputTextField)
        inputTextField.anchor(right: sendButton.leftAnchor, left: textFieldButtonContainer.leftAnchor, paddingRight: 15, paddingLeft: 15)
        inputTextField.center(y: textFieldButtonContainer.centerYAnchor)
        
        addSubview(photoPickerButton)
        photoPickerButton.anchor(right: textFieldButtonContainer.leftAnchor, left: leftAnchor, paddingRight: 10, paddingLeft: 10)
        photoPickerButton.center(y: textFieldButtonContainer.centerYAnchor)
        
        addSubview(inputContainerBorder)
        inputContainerBorder.anchor(top: topAnchor, right: rightAnchor, left: leftAnchor)
        inputContainerBorder.setDimension(hConst: 0.5)
    }
    
    // MARK: - Selectors
    @objc func handleSend() {
        if let message = inputTextField.text, !message.isEmpty {
            delegate?.send(message: message, inputField: inputTextField)
        }
    }
}

// MARK: - UITextfieldDelegate
extension InputContainerView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
