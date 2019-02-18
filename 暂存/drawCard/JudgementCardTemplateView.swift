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
    
    override var selected:Bool {
        didSet{
            descriptionView.selected = selected
        }
    }
        // MARK: ----- init -------
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
   
    fileprivate var attachImageView = UIImageView()
    fileprivate func loadView() {
        backgroundColor = UIColor.clear
//        backImage.image = UIImage(named:"card_normalBack")
//        addSubview(backImage)
//        backImage.contentMode = .scaleToFill

        descriptionView = PlainCardView.createWithText("judgement card", prompt: "no detail now", image: nil)
        addSubview(descriptionView)
        descriptionView.backgroundColor = UIColor.white
        
        // buttons
        setupBasic()
        
        attachImageView.image = UIImage(named: "card_attach")
        addSubview(attachImageView)
    }
    
    // MARK: ---------- layout of subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutJudgementCard()
    }
    
    fileprivate func layoutJudgementCard() {
        descriptionView.frame = bounds

        let bottom = descriptionView.bottomForMore * bounds.height
        let vMargin = descriptionView.vMargin
        let hMargin = descriptionView.hMargin
        
        // size
        let buttonGap = 0.01 * bounds.width
        let buttonX = 0.8 * hMargin
        
        var buttonWidth = (bounds.width - 2 * buttonX - buttonGap) * 0.5
        let ratio: CGFloat = 134 / 48
        let buttonHeight = min(buttonWidth / ratio, bottom)
        buttonWidth = buttonHeight * ratio
        let buttonY = bounds.height - vMargin * 0.5 - buttonHeight
        
        // buttons
        confirmButton.frame = CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        denyButton.frame = CGRect(x: bounds.width - buttonWidth - buttonX, y: buttonY, width: buttonWidth, height: buttonHeight)
        let flipOffset = hMargin * 0.16
        flipButton.frame = CGRect(center: CGPoint(x: bounds.maxX - flipOffset, y: flipOffset), length: hMargin)

        // attachView
        let attachWidth = 0.6 * hMargin
        let attachHeight = attachWidth * 184 / 46
        attachImageView.frame = CGRect(x: bounds.width - attachWidth, y: bounds.height - attachHeight - hMargin, width: attachWidth, height: attachHeight)
    }
    

    // MARK: ----- data  -------
    func setJudgementCardData(_ option: VOptionModel?) {
        if option == nil { return }
        
        descriptionView.title = option?.statement ?? ""
        descriptionView.prompt = option?.info ?? ""
        descriptionView.mainImage = option?.image ?? UIImage(named: "Coming Soon.png")
    }
    
    fileprivate func setJudgementCardData(_ optionIndex: Int) {
        let matchOption = vCard?.matchOptions
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
    override func setCardContent(_ card: VCardModel, defaultSelection: VOptionModel?) {
        super.setCardContent(card, defaultSelection: defaultSelection)
        // TODO:  -------- color ---------
//        descriptionView.fillColor = vCard.color!
        setJudgementCardData(defaultSelection)
    }
}
