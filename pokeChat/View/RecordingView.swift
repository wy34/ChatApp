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
    func presentFailureAlert(_ alert: UIAlertController)
}

class RecordingView: UIView {
    // MARK: - Constants/Variables
    var audioSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var delegate: RecordingViewDelegate?
    
    // MARK: - Subviews
    private let recordButton: CustomButton = {
        let button = CustomButton(title: "Tap to record", textColor: .white, bgColor: .gray)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        return button
    }()
    
    private let playbackButton: CustomButton = {
        let button = CustomButton(title: "Play", textColor: .white, bgColor: .systemGreen)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(playbackTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [recordButton])
        stack.distribution = .fillEqually
        stack.spacing = 10
        return stack
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.tintColor = .black
        button.layer.cornerRadius = 10
        button.isEnabled = false
        button.addTarget(self, action: #selector(sendRecording), for: .touchUpInside)
        return button
    }()
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        button.tintColor = .black
        button.addTarget(self, action: #selector(dismissRecordingWindow), for: .touchUpInside)
        return button
    }()
    
    private let recordingLabel: UILabel = {
        let label = UILabel()
//        label.text = "Recording..."
        label.isHidden = true
        label.textColor = .black
        return label
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        anchorSubviews()
        setupAudioSession()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
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
                if !granted {
                    DispatchQueue.main.async {
                        self.delegate?.dismiss(view: self)
                    }
                }
            }
        } catch {
            self.showFailureAlert(withTitle: "Try again", andMessage: "Please make sure you have microphone access enabled")
        }
    }
    
    // MARK: - Layout
    func anchorSubviews() {
        addSubview(recordingLabel)
        recordingLabel.center(x: centerXAnchor, y: centerYAnchor, yPadding: -10)
        
        addSubview(buttonStack)
        buttonStack.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.9, hMult: 0.2)
        buttonStack.anchor(bottom: bottomAnchor, paddingBottom: 20)
        buttonStack.center(x: centerXAnchor)
        
        addSubview(dismissButton)
        dismissButton.anchor(top: topAnchor, left: leftAnchor, paddingTop: 10, paddingLeft: 10)
        dismissButton.setDimension(width: widthAnchor, height: widthAnchor, wMult: 0.1, hMult: 0.1)
        
        addSubview(sendButton)
        sendButton.setDimension(width: widthAnchor, height: heightAnchor, wMult: 0.2, hMult: 0.15)
        sendButton.anchor(right: rightAnchor, paddingRight: 10)
        sendButton.center(to: dismissButton, by: .centerY)
    }
    
    // MARK: - Selector
    @objc func recordTapped() {
        if !isRecording {
            startRecording()
        } else {
            finishRecording(success: true)
        }
    }
    
    @objc func playbackTapped() {
        let audioUrl = generateAudioSaveUrl()
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: audioUrl)
            audioPlayer.play()
        } catch {
            showFailureAlert(withTitle: "Playback failed", andMessage: "There was a problem playing your whistle; please try re-recording.")
        }
    }
    
    @objc func sendRecording() {
        // get the url out of document directory and send to firebase storage
        print("Sending recording")
    }
    
    @objc func dismissRecordingWindow() {
        delegate?.dismiss(view: self)
    }
    
    // MARK: - Helper methods
    func showFailureAlert(withTitle title: String, andMessage message: String) {
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        delegate?.presentFailureAlert(ac)
    }
    
    func generateAudioSaveUrl() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        return documentDirectory.appendingPathComponent("audio.m4a")
    }
    
    func startRecording(){
        isRecording.toggle()
        recordingLabel.text = "Recording..."
        recordingLabel.isHidden = false
        recordButton.setTitle("Tap to stop", for: .normal)
        recordButton.backgroundColor = .black
        playbackButton.isHidden = true
        sendButton.isEnabled = false
        
        let audioUrl = generateAudioSaveUrl() // where to save audio
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: audioUrl, settings: settings)
            self.audioRecorder.record()
        } catch {
            finishRecording(success: false)
        }
    }
    
    func finishRecording(success: Bool) {
        isRecording.toggle()
        recordButton.backgroundColor = .gray
        
        if success {
            sendButton.isEnabled = true
            playbackButton.isHidden = false
            recordingLabel.text = "Finished!"
            recordButton.setTitle("Tap to re-record", for: .normal)
            buttonStack.addArrangedSubview(playbackButton)
        } else {
            recordingLabel.text = "Try again"
            recordButton.setTitle("Tap to Record", for: .normal)
        }
    }
}
