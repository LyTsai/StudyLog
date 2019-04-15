//
//  ScorecardDetailView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/23.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardDetailView: UIView {
    fileprivate let titleLabel = UILabel()
    fileprivate let cardsView = AnsweredCardsCollectionView.createWithFrame(CGRect.zero)

    var autoPlay = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate let autoPlaySwitch = CustomSwitch()
    fileprivate let leftLabel = UILabel()
    fileprivate let rightLabel = UILabel()
    func updateUI() {
        backgroundColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.text = "You can find out how each of your card selection choice impact the overall score calculation"
        addSubview(titleLabel)
        
        let tapS = UITapGestureRecognizer(target: self, action: #selector(setupAutoPlayState))
        autoPlaySwitch.addGestureRecognizer(tapS)
        addSubview(autoPlaySwitch)
        
        addSubview(leftLabel)
        addSubview(rightLabel)
        leftLabel.textAlignment = .right
        leftLabel.text = "Autoplay ON"
        rightLabel.text = "OFF"
        
        leftLabel.textColor = autoPlay ? UIColor.black : UIColorGray(155)
        rightLabel.textColor = autoPlay ? UIColorGray(155) : UIColor.black
        
        cardsView.detailView = self
        addSubview(cardsView)
    }
    
    fileprivate var riskKey: String!
    func setupWithRisk(_ riskKey: String, userKey: String) {
        cardsView.riskKey = riskKey
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 345
        titleLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: UIFontWeightMedium)
        let gap = one * 5
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 1000)
        titleLabel.adjustWithWidthKept()
        
        
        let sHeight = 25 * one
        let lWidth = 180 * one
        let sWidth = 50 * one
        let rWidth = 30 * one
        let lGap = 2 * one
        leftLabel.frame = CGRect(x: bounds.width - gap - rWidth - 2 * lGap - sWidth - lWidth, y: titleLabel.frame.maxY, width: lWidth, height: sHeight)
        autoPlaySwitch.frame = CGRect(x: leftLabel.frame.maxX + lGap, y: titleLabel.frame.maxY, width: sWidth, height: sHeight)
        rightLabel.frame = CGRect(x: autoPlaySwitch.frame.maxX + lGap, y: titleLabel.frame.maxY, width: rWidth, height: sHeight)
        rightLabel.font = UIFont.systemFont(ofSize: 14 * one, weight: UIFontWeightMedium)
        leftLabel.font = UIFont.systemFont(ofSize: 14 * one, weight: UIFontWeightMedium)
        
        cardsView.frame = CGRect(x: 0, y: autoPlaySwitch.frame.maxY + gap, width: bounds.width, height: bounds.height - titleLabel.frame.height - gap)
    }
    
    // auto play
    func startAutoPlay() {
        cardsView.startAutoPlay()
    }
    
    func pause() {
        cardsView.pause()
    }
    
    func setupAutoPlayState() {
        autoPlay = !autoPlay
        autoPlaySwitch.changeValue()
        autoPlay ? startAutoPlay() : pause()
        leftLabel.textColor = autoPlay ? UIColor.black : UIColorGray(155)
        rightLabel.textColor = autoPlay ? UIColorGray(155) : UIColor.black
    }
}
