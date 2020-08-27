//
//  RecordingView.swift
//  pokeChat
//
//  Created by William Yeung on 8/26/20.
//  Copyright © 2020 William Yeung. All rights reserved.
//

import UIKit
import AVFoundation

protocol RecordingViewDelegate {
    func dismiss(view: RecordingView)
}

class RecordingView: UIView {
    // MARK: - Constants/Variables
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var delegate: RecordingViewDelegate?
    
    // MARK: - Subviews
    private let sendButton = CustomButton(title: "Send", textColor: .white, bgColor: .black)
    private let recordButton = CustomButton(title: "Tap to record", textColor: .white, bgColor: .black)
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(dismissRecordingWindow), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        anchorSubviews()
        
        sendButton.layer.cornerRadius = 10
        recordButton.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Set up Audio Session
    func setupAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playAndRecord)
            try audioSession.setActive(true)
            audioSession.requestRecordPermission { (granted) in
                if granted {
                    // allow user to continue
                } else {
                    // dismiss recording window without doing anything
                }
            }
        } catch {
            
        }
    }
    
    // MARK: - Layout
    func anchorSubviews() {
        addSubview(recordButton)
        recordButton.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.5, hMult: 0.2)
        recordButton.anchor(bottom: bottomAnchor, paddingBottom: 20)
        recordButton.center(x: centerXAnchor)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        dismissButton.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.1, hMult: 0.1)
        
        addSubview(sendButton)
        sendButton.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.2, hMult: 0.15)
        sendButton.anchor(right: rightAnchor, paddingRight: 10)
        sendButton.center(to: dismissButton, by: .centerY)
    }
    
    // MARK: - Selector
    @objc func dismissRecordingWindow() {
        delegate?.dismiss(view: self)
    }
}
