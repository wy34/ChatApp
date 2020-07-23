//
//  LoginButton.swift
//  pokeChat
//
//  Created by William Yeung on 7/22/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class LoginButton: UIButton {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure() {
        backgroundColor = Constants.Color.gray75Opacity
        layer.cornerRadius = 10
        setTitleColor(.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        setTitle("Login", for: .normal)
    }
}
