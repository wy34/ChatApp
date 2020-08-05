//
//  InputContainerView.swift
//  pokeChat
//
//  Created by William Yeung on 7/27/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

protocol InputContainerViewDelegate {
    func send(message: String, inputField: UITextView)
    func moveMessagesAboveInputContainer()
}

class MessageInputContainerView: UIView {
    // MARK: - Properties
    var delegate: InputContainerViewDelegate?
    var inputTextViewBottomAnchor: NSLayoutConstraint?
    
    // MARK: - Subviews
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.up")?.withTintColor(.white, renderingMode: .alwaysOriginal), for: .normal)
        button.backgroundColor = Constants.Color.customGray
        button.layer.cornerRadius = 12.5
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter a message"
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.textColor = .lightGray
        label.sizeToFit()
        return label
    }()
    
    private lazy var inputTextView: UITextView = {
        let tv = UITextView()
        tv.delegate = self
        tv.font = UIFont.preferredFont(forTextStyle: .headline)
        tv.isScrollEnabled = false
        tv.layer.cornerRadius = 18
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.textContainerInset = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 35)
        return tv
    }()
    
    private let photoPickerButton: UIButton = {
        let button = UIButton(type: .system)
        let largeFont = UIImage.SymbolConfiguration(font: UIFont.systemFont(ofSize: 20))
        button.setImage(UIImage(systemName: "photo", withConfiguration: largeFont), for: .normal)
        button.tintColor = Constants.Color.customGray
        return button
    }()
    
    private let inputContainerBorder = SeparatorView(backgroundColor: .lightGray)
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
        addSwipeDownToKB()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View layout
    func layoutViews() {
        addSubview(inputTextView)
        inputTextView.anchor(top: topAnchor, paddingTop: 10)
        inputTextView.setDimension(width: widthAnchor, wMult: 0.8)
        inputTextView.center(to: self, by: .centerX, withMultiplierOf: 1.13)
        inputTextViewBottomAnchor = inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        inputTextViewBottomAnchor?.isActive = true
        
        
        addSubview(placeholderLabel)
        placeholderLabel.center(y: inputTextView.centerYAnchor)
        placeholderLabel.anchor(left: inputTextView.leftAnchor, paddingLeft: 15)
        
        addSubview(sendButton)
        sendButton.setDimension(wConst: 27, hConst: 27)
        sendButton.anchor(right: inputTextView.rightAnchor, bottom: inputTextView.bottomAnchor, paddingRight: 5, paddingBottom: 5)
        
        addSubview(photoPickerButton)
        photoPickerButton.anchor(right: inputTextView.leftAnchor, bottom: inputTextView.bottomAnchor, left: leftAnchor, paddingRight: 10, paddingBottom: 5, paddingLeft: 10)

        addSubview(inputContainerBorder)
        inputContainerBorder.anchor(top: topAnchor, right: rightAnchor, left: leftAnchor)
        inputContainerBorder.setDimension(hConst: 0.5)
    }
    
    // MARK: - Gesture Recognizer
    func addSwipeDownToKB() {
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeDown))
        swipeDown.direction = .down
        addGestureRecognizer(swipeDown)
    }
    
    // MARK: - Selectors
    @objc func handleSend() {
        if let message = inputTextView.text, !message.isEmpty {
            delegate?.send(message: message, inputField: inputTextView)
        }
    }
    
    @objc func handleSwipeDown() {
        inputTextView.resignFirstResponder()
    }
}

// MARK: - UITextViewDelegate
extension MessageInputContainerView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        inputTextViewBottomAnchor?.isActive = false
        inputTextViewBottomAnchor = inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        inputTextViewBottomAnchor?.isActive = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        inputTextViewBottomAnchor?.isActive = false
        inputTextViewBottomAnchor = inputTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30)
        inputTextViewBottomAnchor?.isActive = true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let estimatedSize = textView.sizeThatFits(CGSize(width: frame.width, height: .infinity))
        
        inputTextView.constraints.forEach { (constraints) in
            if constraints.firstAttribute == .height {
                constraints.constant = estimatedSize.height
                delegate?.moveMessagesAboveInputContainer()
            }
        }
        
        placeholderLabel.isHidden = !inputTextView.text.isEmpty
    }
}
