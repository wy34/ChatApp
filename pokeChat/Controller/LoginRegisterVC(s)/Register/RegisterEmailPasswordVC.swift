//
//  RegisterEmailPasswordVC.swift
//  pokeChat
//
//  Created by William Yeung on 7/29/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class RegisterEmailPasswordVC: ClearNavBarViewController{
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configNavbar(withButtonImageName: "xmark.circle", andButtonAction: #selector(goBack))
    }
    
    @objc func goBack() {
        print("Going back")
    }
}
