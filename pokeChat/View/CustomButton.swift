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
    init(title: String, textColor: UIColor = .white, bgColor: UIColor = .clear) {
        super.init(frame: .zero)
        setTitle(title, for: .normal)
        backgroundColor = bgColor
        layer.cornerRadius = 20
        setTitleColor(textColor, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 16)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
