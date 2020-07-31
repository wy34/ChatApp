//
//  ViewController.swift
//  pokeChat
//
//  Created by William Yeung on 7/30/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class ClearNavBarViewController: UIViewController {
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
    
    // MARK: - Configure navbar
    func configNavbar(withButtonImageName imageName: String, andButtonAction action: Selector) {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let dismissButton = UIBarButtonItem(image: UIImage(systemName: imageName), style: .plain, target: self, action: action)
        dismissButton.tintColor = .black
        navigationItem.leftBarButtonItems = [space, dismissButton]
    }
}
