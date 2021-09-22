//
//  SpeechButton.swift
//  MapniPhi
//
//  Created by L on 2021/8/31.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class SpeechButton: UIButton {
    var buttonIsTouched: (() -> Void)?
    
    var speechDidStart: (() -> Void)?
    var speechDidFinished: (() -> Void)?
    
    // 1. speech process indicator
    // 2. speech start and end control
    // 3. speaking (if speech string is not nil)
    var speechString: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBasic()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        self.addTarget(self, action: #selector(speechButtonIsTouched), for: .touchUpInside)
        self.setBackgroundImage(UIImage(named: "voice_none"), for: .selected)
        self.setToNormalState()
    }
    
    @objc func speechButtonIsTouched() {
        if speechString != nil {
            if speechSynthesizer != nil && speechSynthesizer.isSpeaking {
                stopSpeaking()
            }else {
                startSpeaking()
            }
        }
        
        buttonIsTouched?()
    }
    
    func setToSpeakingState() {
        self.setBackgroundImage(UIImage.animatedImageNamed("voice_", duration: 0.5), for: .normal)
    }
    
    func setToNormalState() {
        self.setBackgroundImage(UIImage(named: "voice_2"), for: .normal)
    }
    
    
    fileprivate var speechSynthesizer: AVSpeechSynthesizer!
    func startSpeaking() {
        guard speechString != nil else {
            return
        }
        if speechSynthesizer == nil {
            speechSynthesizer = AVSpeechSynthesizer()
            speechSynthesizer.delegate = self
        }
        
        let utterance = AVSpeechUtterance(string: speechString!)
        utterance.rate = 0.4
        
        // voice
        let voice = AVSpeechSynthesisVoice(language: nil) // use default
        utterance.voice = voice
        
        // speak
        speechSynthesizer.speak(utterance)
    }
    
    func stopSpeaking() {
        if speechSynthesizer != nil {
            speechSynthesizer.stopSpeaking(at: .immediate)
        }
    }
    
}

extension SpeechButton: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didStart utterance: AVSpeechUtterance) {
        speechDidStart?()
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        speechDidFinished?()
    }
}
