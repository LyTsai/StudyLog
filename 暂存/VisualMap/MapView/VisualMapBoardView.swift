//
//  VisualMapBoardView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/23.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
// boardType
enum VisualMapType {
    case symptoms
    case riskFactors
    case riskClass
}

class VisualMapBoardView: UIView {
    // sub views
    fileprivate let backShape = CAShapeLayer()
    fileprivate let titleLabel = UILabel()
    fileprivate let map = VisualMap()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // back
        backShape.fillColor = UIColor.white.withAlphaComponent(0.85).cgColor
        layer.addSublayer(backShape)
        
        // top
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: UIFont.Weight.semibold)
        titleLabel.textColor = UIColorGray(138)
        addSubview(titleLabel)
        
        // middle
        addSubview(map)
        
        // shadow
        layer.shadowRadius = 5 * fontFactor
        layer.shadowOpacity = 0.6
        layer.shadowOffset = CGSize(width: 0, height: 5 * fontFactor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupWithFrame(_ frame: CGRect, fillColor: UIColor, borderColor: UIColor, shadowColor: UIColor, mapType: VisualMapType) {
        self.frame = frame
        map.basicType = mapType
        
        let cornerRadius = 12 * fontFactor
        let lineWidth = 3 * fontFactor
        
//        var titles = [String]()
        switch mapType {
        case .symptoms:
            titleLabel.text = "Symptoms Categories"
        case .riskFactors:
            titleLabel.text = "Risk Factors Categories"
        case .riskClass:
            titleLabel.text = "Total ScoreCard At-a-Glance"
        }
        
     
        // back shape
        let backRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.92).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        backShape.path = UIBezierPath(roundedRect: backRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius,height: cornerRadius)).cgPath
        backShape.lineWidth = lineWidth
        backShape.strokeColor = borderColor.cgColor
        
        // top
        let xMargin = lineWidth * 3
        let mainWidth = bounds.width - 2 * xMargin
        titleLabel.frame = CGRect(x: xMargin, y: xMargin, width: mainWidth, height: bounds.height * 0.08)
       
        // scrollView
        map.frame = CGRect(x: xMargin, y: titleLabel.frame.maxY, width: mainWidth, height: backRect.maxY - titleLabel.frame.maxY - lineWidth * 0.5)
     
        // colors
        backgroundColor = fillColor.withAlphaComponent(0.6)
        addBorder(borderColor, cornerRadius: cornerRadius, borderWidth: lineWidth, masksToBounds: false)
        
        layer.shadowColor = shadowColor.cgColor
        
        // init state
        map.loadBasicNodes()
    }
    
    func setupTilted(_ tilted: Bool) {
        if tilted {
            var transform = CATransform3DIdentity
            transform.m34 = -1 / (5 * bounds.height)
            transform = CATransform3DRotate(transform, CGFloat(Double.pi) * 0.42, 1, 0, 0)
            transform = CATransform3DScale(transform, 0.85, 0.8, 1)
            layer.transform = transform
           
            // hide back and node can not be tapped
            backShape.isHidden = true
            map.isUserInteractionEnabled = false
        }else {
            layer.transform = CATransform3DIdentity
            backShape.isHidden = false
            map.isUserInteractionEnabled = true
        }
    }
}
