//
//  LoginRegisterVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/21/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class LoginRegisterVC: UIViewController {
    // MARK: - Subviews
    private let backgroundImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "background")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to PokeChat"
        label.textColor = .systemYellow
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let loginRegisterSementedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.backgroundColor = Constants.Color.lightGray75Opacity
        sc.selectedSegmentIndex = 0
        let whiteText = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let grayText = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        sc.setTitleTextAttributes(whiteText, for: .normal)
        sc.setTitleTextAttributes(grayText, for: .selected)
        return sc
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        layoutViews()
    }
    
    // MARK: - Layout methods
    func layoutViews() {
        view.addSubview(backgroundImageView)
        backgroundImageView.anchor(top: view.topAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, left: view.leftAnchor)
        
        view.addSubview(titleLabel)
        titleLabel.setDimension(width: view.widthAnchor, wMult: 0.85)
        titleLabel.center(x: view.centerXAnchor)
        titleLabel.center(to: view, by: .centerY, withMultiplierOf: 0.5)
        
        view.addSubview(loginRegisterSementedControl)
        loginRegisterSementedControl.center(x: view.centerXAnchor, y: view.centerYAnchor, yPadding: -15)
        loginRegisterSementedControl.setDimension(hConst: 50)
        loginRegisterSementedControl.setDimension(width: view.widthAnchor, wMult: 0.8)
    }
}
