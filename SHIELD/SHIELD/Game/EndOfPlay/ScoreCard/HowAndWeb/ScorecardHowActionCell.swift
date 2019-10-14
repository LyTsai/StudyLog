//
//  ScorecardHowActionCell.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/26.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

let scorecardHowActionCellID = "Scorecard How Action Cell Identifier"
class ScorecardHowActionCell: UICollectionViewCell {
    var isChecked = false {
        didSet{
            checkLayer.isHidden = !isChecked
        }
    }
    
    var isCurrent = true {
        didSet{
            backShape.strokeColor = isCurrent ? UIColor.black.cgColor : UIColor.clear.cgColor
        }
    }
    
    fileprivate let topic = UILabel()
    fileprivate let backShape = CAShapeLayer()
    fileprivate let checkLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        topic.backgroundColor = UIColor.white
        topic.numberOfLines = 0
        topic.textAlignment = .center
        topic.layer.masksToBounds = true
  
        checkLayer.backgroundColor = UIColorFromHex(0x83E445).withAlphaComponent(0.7).cgColor
        checkLayer.strokeColor = UIColor.white.cgColor
        checkLayer.fillColor = UIColor.clear.cgColor
        
        contentView.layer.addSublayer(backShape)
        contentView.addSubview(topic)
        contentView.layer.addSublayer(checkLayer)
        
        layer.addBlackShadow(3 * fontFactor)
        checkLayer.isHidden = true
        backShape.strokeColor = UIColor.black.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWithColor(_ color: UIColor, title: String)  {
        backShape.fillColor = color.cgColor
        topic.text = title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth = bounds.height / 65
        backShape.path = UIBezierPath(roundedRect: bounds.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5), cornerRadius: 6 * lineWidth).cgPath
        backShape.lineWidth = lineWidth
        
        topic.frame = bounds.insetBy(dx: 5 * lineWidth, dy: 5 * lineWidth)
        topic.layer.cornerRadius = 4 * lineWidth
        topic.font = UIFont.systemFont(ofSize: 10 * fontFactor)
        
        checkLayer.frame = bounds.insetBy(dx: lineWidth, dy: lineWidth)
        checkLayer.cornerRadius = 6 * lineWidth
        
        let checkPath = UIBezierPath()
        checkPath.move(to: CGPoint(x: bounds.midX - 12 * lineWidth, y: bounds.midY))
        checkPath.addLine(to: CGPoint(x: bounds.midX, y: bounds.midY + 10 * lineWidth))
        checkPath.addLine(to: CGPoint(x: bounds.midX + 24 * lineWidth, y: bounds.midY - 10 * lineWidth))
        checkPath.lineCapStyle = .round
        
        checkLayer.path = checkPath.cgPath
        checkLayer.lineWidth = 5 * lineWidth
    }
}
