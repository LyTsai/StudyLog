//
//  JudgementCardTemplateView.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 11/16/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class JudgementCardTemplateView : CardTemplateView {
    override func key() -> String {
        return JudgementCardTemplateView.styleKey()
    }
    
    class func styleKey() -> String {
        return "3ca72cc2-9aeb-11e6-9f33-a24fc0d9649c"
    }
  
    var descriptionView: PlainCardView!
    
    // MARK: ----- init -------
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
   
    // for some extension, like change the buttons
    func loadView() {
        backgroundColor = UIColor.clear

//        backImages = backImagesStyle0
        descriptionView = PlainCardView.createWithText("judgement card", prompt: "no detail now", side: "disease ?", image: nil)
        addSubview(descriptionView)
        
        // buttons
        setupBasic()
    }
    
    // MARK: ---------- layout of subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutJudgementCard()
    }
    
    fileprivate func layoutJudgementCard() {
        descriptionView.frame = bounds

        // size
        let buttonGap = 0.008 * bounds.width
        var buttonX = descriptionView.lineInsets.left * 3 + descriptionView.lineWidth
        
        var buttonWidth = (bounds.width - 2 * buttonX - buttonGap) * 0.5
        let ratio: CGFloat = 134 / 48
        let buttonHeight = min(buttonWidth / ratio, descriptionView.bottomForMore - 2 * buttonGap)
        buttonWidth = buttonHeight * ratio
        
        buttonX = (bounds.width - 2 * buttonWidth - buttonGap) * 0.5
        let buttonY = bounds.height - buttonHeight - descriptionView.lineWidth - descriptionView.lineInsets.bottom - buttonGap
        
        // buttons
        confirmButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        denyButton.frame = CGRect(x: bounds.width - buttonWidth - buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        
        let flipLength = buttonHeight * 0.8
        flipButton.frame = CGRect(center: CGPoint(x: bounds.maxX - flipLength * 0.6, y: flipLength * 0.8), length: flipLength)
    }

    // MARK: ----- data  -------
    func setJudgementCardData(_ option: CardOptionObjModel?) {
        if option == nil { return }
        
        descriptionView.side = option?.match?.info ?? ""
        descriptionView.prompt = option?.match?.statement ?? ""
        descriptionView.title = vCard.title ?? "Disease"
        descriptionView.mainImage = option?.match?.imageObj ?? UIImage(named: "Coming Soon.png")
    }
    
    fileprivate func setJudgementCardData(_ optionIndex: Int) {
        let matchOption = vCard?.cardOptions
        if matchOption == nil || matchOption!.count == 0 {
            print("no options")
            return
        }
        
        var index = optionIndex
        
        if index < 0 || index > matchOption!.count - 1 {
            index = 0
        }
        
        let option = matchOption![index]
        
        setJudgementCardData(option)
    }
    
    // data
    override func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?) {
        super.setCardContent(card, defaultSelection: defaultSelection)
        setJudgementCardData(defaultSelection)
    }
}
