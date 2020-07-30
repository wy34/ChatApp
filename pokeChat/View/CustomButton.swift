//
//  LoginButton.swift
//  pokeChat
//
//  Created by William Yeung on 7/22/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class CustomButton: UIButton {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    init(title: String, textColor: UIColor = .white, bgColor: UIColor = .clear) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        setTitleColor(textColor, for: .normal)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configure
    func configure() {
        layer.cornerRadius = 20
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }
}
