//
//  LoginRegisterSegmentedControl.swift
//  pokeChat
//
//  Created by William Yeung on 7/23/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class LoginRegisterSegmentedControl: UISegmentedControl {
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(items: [Any]?) {
        super.init(items: items)
        configure()
    }
    
    // MARK: - Configure
    func configure() {
        backgroundColor = Constants.Color.gray75Opacity
        selectedSegmentIndex = 0
        let whiteText = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let grayText = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        setTitleTextAttributes(whiteText, for: .normal)
        setTitleTextAttributes(grayText, for: .selected)
    }
}
