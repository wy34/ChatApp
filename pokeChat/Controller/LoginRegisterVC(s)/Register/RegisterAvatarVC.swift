//
//  RegisterNameAvatarVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/29/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class RegisterAvatarVC: ClearNavBarViewController {
    // MARK: - Subviews
    private let instructionLabel: UILabel = {
        let label = UILabel()
        var attributedText = NSMutableAttributedString(string: "Let's get started\n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        attributedText.append(NSAttributedString(string: "\nSelect a profile image", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]))
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    lazy var selectImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "addImage"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(openImageLibrary), for: .touchUpInside)
        button.layer.cornerRadius = (view.frame.width * 0.4) / 2
        button.layer.borderWidth = 2
        return button
    }()
    
    private let continueButton = CustomButton(title: "Continue", bgColor: Constants.Color.customGray)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavbar(withButtonImageName: "xmark.circle", andButtonAction: #selector(dismissPage))
        layoutInstructionLabel()
        layoutImagePickerButton()
        layoutContinueButton()
    }
    
    // MARK: - Layout subviews
    func layoutInstructionLabel() {
        view.addSubview(instructionLabel)
        instructionLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 15)
        instructionLabel.center(to: view, by: .centerX)
    }
    
    func layoutImagePickerButton() {
        view.addSubview(selectImageButton)
        selectImageButton.setDimension(width: view.widthAnchor, height: view.widthAnchor, wMult: 0.4, hMult: 0.4)
        selectImageButton.center(x: view.centerXAnchor)
        selectImageButton.center(to: view, by: .centerY, withMultiplierOf: 0.8)
    }
    
    func layoutContinueButton() {
        continueButton.layer.cornerRadius = (view.frame.height * 0.05) / 2
        continueButton.addTarget(self, action: #selector(goToNextPage), for: .touchUpInside)
        view.addSubview(continueButton)
        continueButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 15)
        continueButton.center(x: view.centerXAnchor)
        continueButton.setDimension(width: view.widthAnchor, height: view.heightAnchor, wMult: 0.85, hMult: 0.05)
    }
    
    // MARK: - Selectors
    @objc func dismissPage() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func openImageLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true)
    }
    
    @objc func goToNextPage() {
        if selectImageButton.imageView?.image == UIImage(named: "addImage") {
            let alert = UIAlertController(title: "Profile Image", message: "Are you sure you want to continue without a profile image? (You can always set it later.)", preferredStyle: .actionSheet)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: showRegisterNameVC(action:))
            let noAction = UIAlertAction(title: "No", style: .default, handler: nil)
            alert.addAction(yesAction)
            alert.addAction(noAction)
            present(alert, animated: true)
        } else {
            showRegisterNameVC(action: nil)
        }
    }
    
    func showRegisterNameVC(action: UIAlertAction?) {
        let registerNameVC = RegisterNameVC()
        registerNameVC.userImage = selectImageButton.imageView?.image
        navigationController?.pushViewController(registerNameVC, animated: true)
    }
}

// MARK: - UIImagePickerController
extension RegisterAvatarVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        selectImageButton.setImage(selectedImage.withRenderingMode(.alwaysOriginal), for: .normal)
        selectImageButton.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
}
