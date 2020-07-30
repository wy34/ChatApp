//
//  RegisterVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/29/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class RegisterNameVC: UIViewController {
    // MARK: - Subviews
    private let instructionLabel: UILabel = {
        let label = UILabel()
        var attributedText = NSMutableAttributedString(string: "What is your name?", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)])
        label.attributedText = attributedText
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configNavbar()
        layoutInstructionLabel()
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
    // MARK: - Selectors
    @objc func goBack() {
        navigationController?.popViewController(animated: true)
    }
}
