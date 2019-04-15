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
    fileprivate let textLabel = UILabel()
    fileprivate let cardsBar = AnsweredCardsBar()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        textLabel.backgroundColor = UIColor.clear
        addSubview(textLabel)
        addSubview(cardsBar)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let marginX = bounds.width * 0.04
        let topH = bounds.height * 0.52
        textLabel.frame = CGRect(x: marginX, y: 0, width: bounds.width - 2 * marginX, height: topH)
        textLabel.font = UIFont.systemFont(ofSize: topH * 0.6, weight: UIFontWeightSemibold)
        cardsBar.frame = CGRect(x: marginX, y: topH, width: bounds.width - 2 * marginX, height: bounds.height - topH)
        cardsBar.setNeedsDisplay()
    }
    
    func configureWithClassificationName(_ name: String, suffix: String, drawInfo: [(number: Int, color: UIColor)], totalNumber: Int, focusing: Int) {
        if focusing < 0 || focusing >= drawInfo.count {
            return
        }
        
        let attriS = NSMutableAttributedString(string: "\(name) \(suffix) ", attributes: [NSForegroundColorAttributeName: drawInfo[focusing].color])
        attriS.append(NSAttributedString(string:  "\(drawInfo[focusing].number)/\(totalNumber)", attributes: [NSForegroundColorAttributeName: UIColorGray(92)]))
        textLabel.attributedText = attriS
        
        cardsBar.setupWithDrawInfo(drawInfo, totalNumber: totalNumber, focusIndex: focusing)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = " "
    }
}
