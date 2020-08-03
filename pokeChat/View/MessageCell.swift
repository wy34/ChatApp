//
//  MessageCell.swift
//  pokeChat
//
//  Created by William Yeung on 8/2/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    // MARK: - Properties
    static let reuseId = "messageCell"
    
    // MARK: - Subviews
    let messageLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .gray
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout views method
    func layoutViews() {
        addSubview(messageLabel)
        messageLabel.anchor(top: topAnchor, right: rightAnchor, bottom: bottomAnchor, left: leftAnchor, paddingTop: 30, paddingRight: 30, paddingBottom: 30, paddingLeft: 30)
    }
}
