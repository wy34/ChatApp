//
//  ChatVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/26/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {
    // MARK: - Subviews
    private lazy var inputFieldContainer: InputContainerView = {
        let view = InputContainerView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
        return view
    }()

    override var inputAccessoryView: UIView? {
        get {
            return inputFieldContainer
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
}
