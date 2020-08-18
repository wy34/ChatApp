//
//  Ext - UIImageView.swift
//  pokeChat
//
//  Created by William Yeung on 8/17/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit

extension UIImageView {
    func enablePinchToZoom() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        self.isUserInteractionEnabled = true
        addGestureRecognizer(pinch)
    }
    
    @objc func handlePinch(gesture: UIPinchGestureRecognizer) {
        let scaleResult = gesture.view?.transform.scaledBy(x: gesture.scale, y: gesture.scale)
        guard let scale = scaleResult, scale.a > 1, scale.d > 1 else { return }
        gesture.view?.transform = scale
        gesture.scale = 1
    }
}
