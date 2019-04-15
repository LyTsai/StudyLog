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
//        textLabel.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel.frame = bounds.insetBy(dx: bounds.width * 0.04, dy: 0)
           textLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.5, weight: UIFontWeightSemibold)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = " "
    }
    
    func configureWithText(_ text: String, textColor: UIColor) {
        textLabel.text = text
        textLabel.textColor = textColor
    }
}


// footer
let answeredCardsFooterID = "answered Cards Footer Identifier"
class AnsweredCardsFooter: UICollectionReusableView {
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
        addSubview(cardsBar)
        
        textLabel.backgroundColor = UIColor.clear
        textLabel.textAlignment = .right
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = bounds.width * 0.04
        let topH = bounds.height * 0.55
        cardsBar.frame = CGRect(x: 0, y: bounds.height * 0.05, width: bounds.width, height: topH).insetBy(dx: margin, dy: bounds.height * 0.1)
        cardsBar.setNeedsDisplay()
        
        // label
        textLabel.frame = CGRect(x: 0, y: topH, width: bounds.width, height: bounds.height - topH).insetBy(dx: margin, dy: 0)
        textLabel.font = UIFont.systemFont(ofSize: textLabel.frame.height * 0.7, weight: UIFontWeightMedium)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel.text = " "
    }
    
    func configureWithDrawInfo(_ drawInfo: [(number: Int, color: UIColor)], totalNumber: Int, focusing: Int) {
        if focusing < 0 || focusing >= drawInfo.count {
            return
        }
        cardsBar.setupWithDrawInfo(drawInfo, totalNumber: totalNumber, focusIndex: focusing)
        textLabel.text = "\(drawInfo[focusing].number)/\(totalNumber)"
    }
}
