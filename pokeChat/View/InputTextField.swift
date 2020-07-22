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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String) {
        super.init(frame: .zero)
        configure(placeholder: placeholder)
    }
    
    // MARK: - Configure method
    func configure(placeholder: String) {
        textColor = .white
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: frame.size.height))
        leftView = padding
        leftViewMode = .always
        
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        attributedPlaceholder = attributedPlaceholder
    }
}
