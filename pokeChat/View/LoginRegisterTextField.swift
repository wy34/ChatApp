//
//  InputTextField.swift
//  pokeChat
//
//  Created by William Yeung on 7/22/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class LoginRegisterTextField: UITextField {
    // MARK: - Initializers
    init(placeholder: String, foregroundColor: UIColor = .white, bgColor: UIColor = .white) {
        super.init(frame: .zero)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        textColor = foregroundColor
        backgroundColor = bgColor
        textAlignment = .center
        layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
