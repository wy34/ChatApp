//
//  ContinueButtonContainerView.swift
//  pokeChat
//
//  Created by William Yeung on 7/29/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

protocol ContinueButtonContainerViewDelegate {
    func goToNextPage()
}

class ContinueButtonContainerView: UIView {
    // MARK: - Properties
    var delegate: ContinueButtonContainerViewDelegate?
    
    // MARK: - Subviews
    lazy var continueButton: CustomButton = {
        let button = CustomButton()
        button.backgroundColor = Constants.Color.customGreen
        button.alpha = 0.5
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
        return button
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContinueButtonContainerView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, frame: CGRect) {
        super.init(frame: .zero)
        configureContinueButtonContainerView()
        self.frame = frame
        continueButton.setTitle(title, for: .normal)
    }
    
    // MARK: - Layout subviews
    func configureContinueButtonContainerView() {
        addSubview(continueButton)
        continueButton.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.8, hMult: 0.75)
        continueButton.center(x: centerXAnchor, y: centerYAnchor)
    }
    
    // MARK: - Selector
    @objc func handleContinueButton() {
        delegate?.goToNextPage()
    }
}
