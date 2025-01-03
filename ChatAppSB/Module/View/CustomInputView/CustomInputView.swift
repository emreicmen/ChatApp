//
//  CustomInputView.swift
//  ChatAppSB
//
//  Created by Emre İÇMEN on 25.12.2024.
//

import Foundation
import UIKit


protocol CustomInputViewDelegate: AnyObject {
    func inputView(_ view: CustomInputView, wantUploadMessage message: String)
    func inputViewForAttachButton(_ view: CustomInputView)
    func inputViewForAudio(_ view: CustomInputView, audioURL: URL)
}


class CustomInputView: UIView {
    
    //MARK: - Properties
    weak var delegate: CustomInputViewDelegate?
    let inputTextView = InputTextView()
    private let postBackgroundColor: CustomImageView = {
        let gestureRecognizer = UITapGestureRecognizer(target: CustomInputView.self, action: #selector(sendMessage))
        let imageView = CustomImageView(width: 40, height: 40, backgroundColor: MAIN_COLOR, cornerRadius: 20)
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(gestureRecognizer)
        imageView.isHidden = true
        
        return imageView
    }()
    private lazy var sendButton: UIButton = {

        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.setDimensions(height: 30, width: 30)
        button.isHidden = true
        
        return button
    }()
    private lazy var attachMediaButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "paperclip"), for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.tintColor = MAIN_COLOR
        button.addTarget(self, action: #selector(attachButtonClicked), for: .touchUpInside)
        
        return button
    }()
    private lazy var recordVoiceButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "waveform"), for: .normal)
        button.setDimensions(height: 30, width: 30)
        button.tintColor = MAIN_COLOR
        button.addTarget(self, action: #selector(recordButtonClicked), for: .touchUpInside)
        
        return button
    }()
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [inputTextView, postBackgroundColor, attachMediaButton, recordVoiceButton])
        stackView.axis = .horizontal
        stackView.spacing = 6
        stackView.alignment = .center
        //stackView.distribution = .fillProportionally
        return stackView
    }()
    //Record Elements
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setDimensions(height: 40, width: 100)
        button.addTarget(self, action: #selector(cancelRecordVoice), for: .touchUpInside)
        return button
    }()
    private lazy var sendRecord: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        button.tintColor = .white
        button.backgroundColor = .red
        button.setDimensions(height: 40, width: 100)
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(sendRecordVoice), for: .touchUpInside)
        return button
    }()
    private let timerLabel = CustomLabel(text: "00:00")
    private lazy var recordElementsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [cancelButton, timerLabel, sendRecord])
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.isHidden = true
        return stackView
    }()
    var duration: CGFloat = 0.0
    var timer: Timer!
    var recorder = AKAudioRecorder.shared
    
    
    
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .white
        autoresizingMask = .flexibleHeight
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingLeft: 5, paddingRight: 5)
        addSubview(sendButton)
        sendButton.center(inView: postBackgroundColor)
        
        inputTextView.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: postBackgroundColor.leftAnchor, paddingTop: 12, paddingLeft: 8, paddingBottom: 5, paddingRight: 8)
        
        let dividerView = UIView()
        dividerView.backgroundColor = MAIN_COLOR
        addSubview(dividerView)
        dividerView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, height: 0.5)
        
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChangeProcess), name: InputTextView.textDidChangeNotification, object: nil)
        
        addSubview(recordElementsStackView)
        recordElementsStackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 15, paddingLeft: 15, paddingRight: 15)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    

    
    //MARK: - Helpers
    @objc func sendMessage() {
        delegate?.inputView(self, wantUploadMessage: inputTextView.text)
    }
    
    func clearTextView() {
        inputTextView.text = ""
        inputTextView.placeHolderLabel.isHidden = false
    }
    
    @objc func attachButtonClicked() {
        delegate?.inputViewForAttachButton(self)
    }
    
    @objc func textDidChangeProcess() {
        let isTextEmpty = inputTextView.text.isEmpty || inputTextView.text == ""
        sendButton.isHidden = isTextEmpty
        postBackgroundColor.isHidden = isTextEmpty
        attachMediaButton.isHidden = !isTextEmpty
        recordVoiceButton.isHidden = !isTextEmpty
    }
    
    //Record Voice stuff
    @objc func recordButtonClicked() {
        stackView.isHidden = true
        recordElementsStackView.isHidden = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
            self.recorder.myRecordings.removeAll()
            print(self.recorder.myRecordings.count)
            self.recorder.record()
            self.setTimer()
        })

    }
    
    @objc func cancelRecordVoice() {
        recordElementsStackView.isHidden = true
        stackView.isHidden = false
    }
    
    @objc func sendRecordVoice() {
        let name = recorder.getRecordings.last ?? ""
        guard let audioURL = recorder.getAudioURL(name: name) else { return }
        print("Audio URL:\(audioURL) + Audio name:\(name)")
        self.delegate?.inputViewForAudio(self, audioURL: audioURL)
        
        recorder.stopRecording()
        stackView.isHidden = false
        recordElementsStackView.isHidden = true
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if recorder.isRecording && !recorder.isPlaying {
            duration += 1
            self.timerLabel.text = duration.timeStringFormatter
        }else {
            timer.invalidate()
            duration = 0
            self.timerLabel.text = "00:00"
        }

    }

}
