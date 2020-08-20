//
//  InputContainerView.swift
//  pokeChat
//
//  Created by William Yeung on 7/27/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation
import FirebaseStorage

protocol InputContainerViewDelegate {
    func send(message: String, inputField: UITextView)
    func moveMessagesAboveInputContainer()
    func present(imagePicker: UIImagePickerController)
    func dismissImagePicker()
    func present(optionSheet: UIAlertController)
}

class MessageInputContainerView: UIView {
    // MARK: - Properties
    var delegate: InputContainerViewDelegate?
    var inputTextViewBottomAnchor: NSLayoutConstraint?
    var chatPartner: User?
    
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
    
    lazy var inputTextView: UITextView = {
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
        button.addTarget(self, action: #selector(showImagePickerOptions), for: .touchUpInside)
        return button
    }()
    
    var loadingBackgroundView = UIView()
    
    private let loadingIndictaor: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = UIActivityIndicatorView.Style.large
        spinner.color = .white
        return spinner;
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
    
    // MARK: - Helper methods
    func open(_ sourceType: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType =  sourceType
        imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        delegate?.present(imagePicker: imagePicker)
    }
    
    func showLoadingScreen() {
        if let keyWindow = UIApplication.shared.windows.filter({$0.isKeyWindow}).first {
            loadingBackgroundView = UIView(frame: keyWindow.frame)
            loadingBackgroundView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.695125214)
            keyWindow.addSubview(loadingBackgroundView)
            loadingBackgroundView.center = keyWindow.center
            
            keyWindow.addSubview(loadingIndictaor)
            loadingIndictaor.center = keyWindow.center
            loadingIndictaor.startAnimating()
        }
    }
    
    func generateThumbnailImageForUrl(_ fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            let thumbnailImage = try imageGenerator.copyCGImage(at: CMTime(value: 1, timescale: 60), actualTime: nil)
            return UIImage(cgImage: thumbnailImage)
        } catch {
            print(error)
        }
        
        return nil
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
    
    @objc func showImagePickerOptions() {
        let alertController = UIAlertController(title: "Choose your Image", message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
            self.open(.photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take from Camera", style: .default) { (action) in
            self.open(.camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(libraryAction)
        alertController.addAction(cameraAction)
        alertController.addAction(cancelAction)
        
        delegate?.present(optionSheet: alertController)
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

// MARK: - UIImagePickerControllerDelegate/UINavigationControllerDelegate
extension MessageInputContainerView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        showLoadingScreen()
    
        if let videoUrl = info[.mediaURL] as? URL {
            let fileName = UUID().uuidString + ".mov"
            let storageRef = Storage.storage().reference().child("movie_messages").child("\(fileName)")
            
            if let videoData = try? Data(contentsOf: videoUrl) {
                let task = storageRef.putData(videoData, metadata: nil) { (metadata, error) in
                    if let _ = error {
                        print("error putting video data")
                        return
                    }
                    
                    storageRef.downloadURL { (url, error) in
                        if let _ = error {
                            print("error downloading video url")
                            return
                        }
                        
                        if let url = url {
                            if let thumbnailImage = self.generateThumbnailImageForUrl(videoUrl) {
                                DatabaseManager.shared.store(image: thumbnailImage, inDirectory: "videoThumbnail") { (result) in
                                    switch result {
                                        case .success(let imageUrlString):
                                            guard let chatPartnerId = self.chatPartner?.id else { return }
                                            let properties = ["thumbnailImageUrl": imageUrlString, "imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height, "videoUrl": url.absoluteString] as [String: AnyObject]
                                            DatabaseManager.shared.addMessage(withProperties: properties, toId: chatPartnerId) { (result) in
                                                switch result {
                                                case .success(_):
                                                    self.loadingIndictaor.stopAnimating()
                                                    self.loadingBackgroundView.removeFromSuperview()
                                                    self.delegate?.dismissImagePicker()
                                                case .failure(let error):
                                                    print(error.rawValue)
                                                }
                                        }
                                        case .failure(let error):
                                            print(error.rawValue)
                                        }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            guard let selectedImage = info[.originalImage] as? UIImage else { return }
            DatabaseManager.shared.store(image: selectedImage, inDirectory: "messageImages") { (result) in
                switch result {
                case .success(let imageUrlString):
                    guard let chatPartnerId = self.chatPartner?.id else { return }
                    let properties = ["imageUrl": imageUrlString, "imageHeight": selectedImage.size.height, "imageWidth": selectedImage.size.width] as [String: AnyObject]
                    DatabaseManager.shared.addMessage(withProperties: properties, toId: chatPartnerId) { (result) in
                        switch result {
                        case .success(_):
                            self.loadingIndictaor.stopAnimating()
                            self.loadingBackgroundView.removeFromSuperview()
                            self.delegate?.dismissImagePicker()
                        case .failure(let error):
                            print(error.rawValue)
                        }
                    }
                case .failure(let error):
                    print(error.rawValue)
                }
            }
        }
    }
}
