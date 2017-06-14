//
//  MatchedCardView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MatchedCardView: UIView {
    // backImage - planCard - filp - matched
    var matchedCard: MatchedCardModel! {
        didSet{
            if matchedCard !== oldValue {
                // set up
                plainView.title = matchedCard.title
                plainView.prompt = matchedCard.prompt
                plainView.side = matchedCard.side
                plainView.mainImage = matchedCard.image
                
                if matchedCard.matchedResult == nil {
                    matchedButton.isHidden = true
                }else {
                    matchedButton.isHidden = false
                    matchedButton.setTitle(matchedCard.matchedResult, for: .normal)
                }
                
                // set risks
                
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate let plainView = PlainCardView()
    fileprivate let backImageView = UIImageView(image: UIImage(named: "cardBack_normal_0"))
    fileprivate let flipButton = UIButton(type: .custom)
    fileprivate let matchedButton = UIButton(type: .custom)
    fileprivate func setupUI() {
        flipButton.setBackgroundImage(UIImage(named: "cardInfo"), for: .normal)
        matchedButton.setBackgroundImage(UIImage(named: "button_greenBG"), for: .normal)
        matchedButton.setTitleColor(UIColor.white, for: .normal)
        matchedButton.isUserInteractionEnabled = false
        
        // add
        addSubview(backImageView)
        addSubview(plainView)
        addSubview(flipButton)
        addSubview(matchedButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backImageView.frame = bounds
        plainView.frame = bounds
        
        let ratio: CGFloat = 134 / 48
        let buttonGap = 0.006 * bounds.width
        let buttonHeight = plainView.bottomForMore - 2 * buttonGap
        let buttonWidth = buttonHeight * ratio
        matchedButton.frame =  CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - plainView.bottomForMore * 0.5 - plainView.lineWidth - plainView.lineInsets.bottom), width: buttonWidth, height: buttonHeight)
        let hori = buttonHeight * 0.45
        matchedButton.titleEdgeInsets = UIEdgeInsets(top: buttonGap, left: hori, bottom: buttonGap, right: hori)
        matchedButton.titleLabel?.font = UIFont.systemFont(ofSize: buttonHeight * 0.4)
        
        let flipLength = buttonHeight * 0.8
        flipButton.frame = CGRect(center: CGPoint(x: bounds.maxX - flipLength * 0.6, y: flipLength * 0.8), length: flipLength)
    }
}
