//
//  ChatVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/26/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    // MARK: - Subviews
    private lazy var inputFieldContainer: InputContainerView = {
        let view = InputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        return view
    }()
    
    private let textFieldButtonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        return view
    }()
    
    private let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a message..."
        tf.layer.cornerRadius = 15
        tf.layer.borderWidth = 1
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        tf.leftView = view
        tf.leftViewMode = .always
        
        return tf
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.03921568627, green: 0.5176470588, blue: 1, alpha: 1)
        button.layer.cornerRadius = 15
        //button.backgroundColor = .orange
        return button
    }()
    
    private let inputContainerBorder = SeparatorView(backgroundColor: .lightGray)
    
    override var inputAccessoryView: UIView? {
        get {
            return inputFieldContainer
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        //layoutViews()
    }
    
    // MARK: - View layout functions
    func layoutViews() {
//        view.addSubview(inputFieldContainer)
//        inputFieldContainer.setDimension(height: view.heightAnchor, hMult: 0.085)
//        inputFieldContainer.anchor(right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
        
        inputFieldContainer.addSubview(textFieldButtonContainer)
        textFieldButtonContainer.center(y: inputFieldContainer.centerYAnchor)
        textFieldButtonContainer.setDimension(width: inputFieldContainer.widthAnchor, height: inputFieldContainer.heightAnchor, wMult: 0.73, hMult: 0.6)
        textFieldButtonContainer.anchor(left: inputFieldContainer.leftAnchor, paddingLeft: 15)
        
        inputFieldContainer.addSubview(sendButton)
        sendButton.anchor(right: inputFieldContainer.rightAnchor, left: inputTextField.rightAnchor, paddingRight: 15, paddingLeft: 15)
        sendButton.center(y: inputFieldContainer.centerYAnchor)
        
        inputFieldContainer.addSubview(inputContainerBorder)
        inputContainerBorder.anchor(top: inputFieldContainer.topAnchor, right: inputFieldContainer.rightAnchor, left: inputFieldContainer.leftAnchor)
        inputContainerBorder.setDimension(hConst: 0.5)
    }
}
