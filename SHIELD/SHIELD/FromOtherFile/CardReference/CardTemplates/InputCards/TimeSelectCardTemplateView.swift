//
//  TimeSelectCardTemplateView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/10.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class TimeSelectCardTemplateView: JudgementCardTemplateView {
    override func key() -> String {
        return TimeSelectCardTemplateView.styleKey()
    }
    
    override class func styleKey() -> String {
        return "3ca7341a-9aeb-11e6-9f33-a24fc0d9649c"
    }
    
    // MARK: ----- init -------
    let duration = Bundle.main.loadNibNamed("DurationSelectView", owner: self, options: nil)?.first as! DurationSelectView
    override func addBackAndUpdateUI() {
        super.addBackAndUpdateUI()
        
        // buttons
        leftButton.setupWithTitle("I don't know")
        rightButton.setupWithTitle("OK")
        
        descriptionView.mainImageView.isHidden = true
        
        addSubview(duration)
    }
    
    override func setUIForSelection(_ answer: Int?) {
        super.setUIForSelection(answer)
        
        leftButton.isSelected = false
        rightButton.isSelected = false
        descriptionView.isChosen = true

        if let result = vCard.currentInput() {
            let start = vCard.currentRefValue() ?? 0
            duration.startValue = start
            var end = start + result
            if end > 24 * 60 {
                end -= 24 * 60
            }
            duration.endValue = end
            duration.setupWithValues()
        }
    }
    
    
    // MARK: ---------- layout of subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let leftFrame = descriptionView.mainImageView.frame
        duration.frame = CGRect(center: CGPoint(x: leftFrame.midX, y: leftFrame.midY), width: descriptionView.rimFrame.width * 0.9, height: leftFrame.height)
    }
    
    
    // data
    override func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?) {
        super.setCardContent(card, defaultSelection: defaultSelection)
        
        if let match = defaultSelection?.match {
            // any detail?
            descriptionView.detail = card.title
            descriptionView.title = match.name
        }
    }
    

    override func rightButtonClicked() {
        vCard.saveInput(duration.result, matchKey: option.matchKey, refValue: duration.startValue)
        setUIForSelection(1)
        if actionDelegate != nil {
            actionDelegate.card?(self, chooseItemAt: 1)
        }
    }
}


