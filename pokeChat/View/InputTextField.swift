//
//  InputTextField.swift
//  pokeChat
//
//  Created by William Yeung on 7/22/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class InputTextField: UITextField {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        configure()
    }
    
    // MARK: - Configure method
    func configure() {
        textColor = .white
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.size.height))
        leftView = padding
        leftViewMode = .always
    }
}
