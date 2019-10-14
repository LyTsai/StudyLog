//
//  JudgementCardTemplateView.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 11/16/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class JudgementCardTemplateView: CardTemplateView {
    override func key() -> String {
        return JudgementCardTemplateView.styleKey()
    }
    
    class func styleKey() -> String {
        return judgementCardTemplateStyleTypeKey
    }
  
    // for special cards and so on
    // now used for tag
    var withPrompt = false
    
    var nameStatementName = false
    
    let descriptionView = PlainCardView()
    let flipButton = UIButton(type: .custom)
    let voiceButton = UIButton(type: .custom)
    
    // MARK: ----- init -------
    // for some extension, like change the buttons
    let baseline = UIImageView(image: #imageLiteral(resourceName: "baselineChoice")) // 115 * 28
    override func addBackAndUpdateUI() {
        addSubview(infoDetailView)

        // flip
        infoDetailView.backgroundColor = UIColor.white
  
        // backImageView
        backgroundColor = UIColor.clear
        addSubview(descriptionView)
        
        // buttons
        flipButton.setBackgroundImage(#imageLiteral(resourceName: "button_rectMark"), for: .normal)
        descriptionView.addSubview(flipButton)
        
        voiceButton.setBackgroundImage(#imageLiteral(resourceName: "voice_1"), for: .normal)
        voiceButton.setBackgroundImage(#imageLiteral(resourceName: "voice_none"), for: .selected)
        
        voiceButton.isSelected = !userDefaults.bool(forKey: allowVoiceKey)
        
        descriptionView.addSubview(voiceButton)
        voiceButton.addTarget(self, action: #selector(playVoice), for: .touchUpInside)
        
        leftButton = GradientBackStrokeButton(type: .custom)
        leftButton.isSelected = false
        leftButton.roundCorner = true
        leftButton.setupWithTitle("ME")
        
        rightButton = GradientBackStrokeButton(type: .custom)
        rightButton.isSelected = false
        rightButton.roundCorner = true
        rightButton.setupWithTitle("NOT ME")
        
        hintButton.setBackgroundImage(#imageLiteral(resourceName: "card_hint"), for: .normal)

        descriptionView.addSubview(leftButton)
        descriptionView.addSubview(rightButton)
        
        baseline.isHidden = true
        addSubview(baseline)
        
        addActions()
    }

    override func setUIForSelection(_ answer: Int?) {
        super.setUIForSelection(answer)
        
        leftButton.isSelected = (answer == 0)
        rightButton.isSelected = (answer == 1)
        
        descriptionView.isChosen = true
    }
    
    
    // MARK: ---------- layout of subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutJudgementCard()
    }
    
    let hintButton = UIButton(type: .custom)
    fileprivate func layoutJudgementCard() {
        let backTop = 5 * bounds.height / 446

        descriptionView.frame = CGRect(x: 0, y: backTop, width: bounds.width, height: bounds.height - backTop)
        descriptionView.rimFrame = descriptionView.bounds.insetBy(dx: backTop * 1.25, dy: backTop * 1.25)
        descriptionView.rimLineWidth = backTop * 0.5
    
        descriptionView.innerCornerRadius = backTop
        descriptionView.mainCornerRadius = backTop
        
        descriptionView.resetLayout()
        descriptionView.setNeedsDisplay()
        
        infoDetailView.frame = descriptionView.frame.insetBy(dx: 1, dy: 1)
        infoDetailView.layer.cornerRadius = backTop
        // size
        let buttonGap = 0.02 * bounds.width
        var buttonX = descriptionView.rimFrame.minX + descriptionView.rimLineWidth * 5
        
        var buttonWidth = (bounds.width - 2 * buttonX - buttonGap) * 0.5
        let ratio: CGFloat = 135 / 44
        let buttonHeight = min(buttonWidth / ratio, descriptionView.bottomForMore - buttonGap)
        buttonWidth = buttonHeight * ratio
        
        buttonX = (bounds.width - 2 * buttonWidth - buttonGap) * 0.5
        let buttonY = descriptionView.rimFrame.maxY - buttonHeight - descriptionView.rimLineWidth - buttonGap * 0.5
        
        // buttons
        leftButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        rightButton.frame = CGRect(x: bounds.width - buttonWidth - buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        
        // flip and hint
        let flipX = descriptionView.rimFrame.minX + descriptionView.rimLineWidth * 1.5
        let flipLength = (descriptionView.promptMargin - flipX) * 0.8
        flipButton.frame = CGRect(x: flipX, y: descriptionView.rimFrame.minY + descriptionView.frame.minY + descriptionView.rimLineWidth, width: flipLength, height: flipLength)
        voiceButton.frame = CGRect(x: flipX, y: flipButton.frame.maxY + descriptionView.rimLineWidth * 2, width: flipLength, height: flipLength * 24 / 22)
        
        let bH = buttonHeight
        baseline.frame = CGRect(x: -bH * 0.3, y: buttonY - buttonHeight, width: bH / 28 * 115, height: bH)
    }

    fileprivate var voicePlayer: AVPlayer!
    fileprivate var item: AVPlayerItem!
    fileprivate var voiceObserver: Any!
    fileprivate var voiceIconIndex = 0
    
    fileprivate func startVoicePlay() {
        let allowVoice = userDefaults.bool(forKey: allowVoiceKey)
        if voiceUrl != nil && allowVoice {
            voiceButton.isEnabled = false
            item = AVPlayerItem(url: voiceUrl)
            voicePlayer = AVPlayer(playerItem: item)
            voicePlayer.play()
            
            item.addObserver(self, forKeyPath:"status", options: .new, context: nil)
            voicePlayer.addPeriodicTimeObserver(forInterval: CMTime(value: 1, timescale: 1), queue: DispatchQueue.main) { (time) in
                self.voiceIconIndex += 1
                if self.voiceIconIndex == 3 {
                    self.voiceIconIndex = 0
                }
                let current = CMTimeGetSeconds(time)
                if current > 0 {
                    self.voiceButton.setBackgroundImage(UIImage(named: "voice_\(self.voiceIconIndex)"), for: .normal)
                }
            }
            
            NotificationCenter.default.addObserver(self, selector: #selector(playFinished), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
        }
    }
    
    @objc func playFinished() {
        voiceIconIndex = 2
        voiceButton.setBackgroundImage(UIImage(named: "voice_2"), for: .normal)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "status" {
            switch voicePlayer.status {
            case .failed: print("failed")
            case .readyToPlay: voiceButton.isEnabled = true
            case .unknown: print("unkown")
            @unknown default:
                break
            }
        }
    }
    
    deinit {
        if item != nil {
            item.removeObserver(self, forKeyPath: "status", context: nil)
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: item)
            voicePlayer.removeTimeObserver(voiceObserver!)
            voiceObserver = nil
        }
    }
    
    
    @objc func playVoice(_ button: UIButton) {
        let allowVoice = userDefaults.bool(forKey: allowVoiceKey)
        if allowVoice {
            // not allow
            voiceButton.isSelected = true
            if voicePlayer != nil {
                voicePlayer.pause()
            }
        }else {
            // open switch
            voiceButton.isSelected = false
            voiceButton.setBackgroundImage(UIImage(named: "voice_2"), for: .normal)
            if voicePlayer != nil {
                voicePlayer.seek(to: CMTimeMake(value: 0, timescale: 1))
                voicePlayer.play()
            }else {
                startVoicePlay()
            }
        }
        userDefaults.set(!allowVoice, forKey: allowVoiceKey)
        userDefaults.synchronize()
    }
    
    override func beginToShow() {
        startVoicePlay()
        descriptionView.startToDisplay()
    }
    
    
    override func endShow() {
        descriptionView.endDisplay()
        
        if voicePlayer != nil {
            voicePlayer.pause()
        }
    }
    
    // data
    fileprivate var voiceUrl: URL!
    override func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?) {
        super.setCardContent(card, defaultSelection: defaultSelection)
        
        leftButton.backgroundColor = WHATIF ? whatIfTintColor : baselineTintColor
        rightButton.backgroundColor = WHATIF ? whatIfTintColor : baselineTintColor
        
        if let riskTypeKey = collection.getRiskTypeOfCard(vCard.key) {
            if let riskType = collection.getRiskTypeByKey(riskTypeKey) {
                descriptionView.mainColor = riskType.realColor ?? tabTintGreen
                let name = riskType.name ?? "ira"
                descriptionView.stamp.text = String(name[0..<3])
            }
        }
        
        /*
            title
            detail
        */
        
        if let match = defaultSelection?.match {
            // any detail?
            flipButton.isHidden = (card.note == nil)
            infoDetailView.text = card.note
            descriptionView.title = match.name
            descriptionView.mainImageUrl = match.imageUrl
            
            // for example, iRa
            descriptionView.detail = match.statement
            
            // voice
            voiceUrl = nil
            if match.voiceUrl?.count ?? 0 > 3, let voice = match.voiceUrl {
                let encoded = voice.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
                voiceUrl = URL(string: encoded)
            }
            voiceButton.isHidden = (voiceUrl == nil)
            
            if withPrompt {
                descriptionView.detail = card.title
                descriptionView.tagUrl = match.classification?.imageUrl
            }
            
            // check if card style is iIa
            if card.cardStyleKey == iIaCardTemplateStyleTypeKey {
                // no need to set prompt since we include the card.title in descriptionView.detail
                withPrompt = false
                let risks = collection.getRisksContainsCard(card.key)
                if risks.count > 1 {
                    print("more than one is used")
                }
                let riskName = collection.getRisk(risks.first!).name ?? "it"
                
                // set descriptionView.detail to
                // match.classification.displayName + " of " + riskName + " on " + card.title
                // for example:
                // match.classification.displayName = I have 2nd hand experience or Indirectly aware
                // riskName = "Low Vitmin D impact"
                // card.title = "Premature aging"
                descriptionView.detail = ("\(match.classification?.displayName ?? "") of \(riskName) on \(card.title ?? "").")
                descriptionView.tagUrl = match.classification?.imageUrl
            }
        }
    }
}
