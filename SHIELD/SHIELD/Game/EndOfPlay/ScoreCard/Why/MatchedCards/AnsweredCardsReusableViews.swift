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
    fileprivate let idenLine = UIView()
    fileprivate let idenBlock = UIView()
    fileprivate let cardsBar = AnsweredCardsBar()
    fileprivate let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        idenBlock.layer.borderColor = UIColor.black.cgColor

        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.locations = [0.1, 0.9]
        
        // add views
        addSubview(idenLine)
        addSubview(idenBlock)
        addSubview(cardsBar)
        layer.addSublayer(gradientLayer)
        addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.height / 25
        idenBlock.frame = CGRect(x: 0, y: 0, width: 10 * one, height: bounds.height).insetBy(dx: one * 0.5, dy: one * 0.5)
        idenBlock.layer.borderWidth = one
        idenBlock.layer.cornerRadius = 2 * one
        
        idenLine.frame = CGRect(x: idenBlock.frame.maxX, y: bounds.height - 2 * one, width: bounds.width - idenBlock.frame.maxX, height: one)
        
        titleLabel.frame = CGRect(x: idenBlock.frame.maxX + 2 * one, y: 0, width: bounds.width - (idenBlock.frame.maxX + 2 * one), height: idenLine.frame.minY)
        titleLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .semibold)
        
        cardsBar.frame = bounds
        cardsBar.setNeedsDisplay()
        
        gradientLayer.frame = bounds
    }
    
    // scoreCardHeader
    func configureWithDrawInfo(_ drawInfo: [(number: Int, color: UIColor)], totalNumber: Int, focusing: Int) {
        if focusing < 0 || focusing >= drawInfo.count {
            return
        }
        showForDistribution(true)
        gradientLayer.isHidden = true
        cardsBar.setupWithDrawInfo(drawInfo, totalNumber: totalNumber, focusIndex: focusing)
    }
    
    // complementaryCardHeader
    func configureWithIden(_ iden: String) {
        showForDistribution(false)
        gradientLayer.isHidden = true
        
        let color = MatchedCardsDisplayModel.getColorOfIden(iden)
        idenBlock.backgroundColor = color
        idenLine.backgroundColor = color
        titleLabel.text = MatchedCardsDisplayModel.getNameOfIden(iden)
    }
    
    fileprivate func showForDistribution(_ distribution: Bool) {
        idenLine.isHidden = distribution
        idenBlock.isHidden = distribution
        titleLabel.isHidden = distribution
        cardsBar.isHidden = !distribution
    }
    
    // ActionHeader
    func configureForActionWithIden(_ iden: String) {
        gradientLayer.isHidden = false
        idenLine.isHidden = true
        idenBlock.isHidden = true
        titleLabel.isHidden = false
        cardsBar.isHidden = true
        
        let color = MatchedCardsDisplayModel.getColorOfIden(iden)
        gradientLayer.colors = [color.cgColor, color.withAlphaComponent(0.5).cgColor]
        titleLabel.text = MatchedCardsDisplayModel.getRecomendataionOfIden(iden)
        titleLabel.textColor = UIColor.black
    }
}
