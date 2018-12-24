//
//  AnsweredCardsReusableViews.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/20.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

// header
let answeredCardsHeaderID = "answered Cards Header Identifier"
class AnsweredCardsHeader: UICollectionReusableView {
    fileprivate let titleLabel = UILabel()
    fileprivate let cardsBar = AnsweredCardsBar()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel.text = "Card Score Ranking Distribution"
        addSubview(titleLabel)
        addSubview(cardsBar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 345
        titleLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.3)
        cardsBar.frame = CGRect(x: 0, y: titleLabel.frame.maxY, width: bounds.width, height: bounds.height - titleLabel.frame.maxY)
        titleLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: UIFont.Weight.semibold)
        cardsBar.setNeedsDisplay()
    }
    
    func configureWithDrawInfo(_ drawInfo: [(number: Int, color: UIColor)], totalNumber: Int, focusing: Int) {
        if focusing < 0 || focusing >= drawInfo.count {
            return
        }
        cardsBar.setupWithDrawInfo(drawInfo, totalNumber: totalNumber, focusIndex: focusing)
    }
    
}
