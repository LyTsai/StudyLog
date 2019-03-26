//
//  ScorecardHowMainPair.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/26.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardHowMainPair {
    var leftIsTouched: (()->Void)?
    
    fileprivate let iconImageView = UIImageView()
    fileprivate let titleLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let pairShape = CAShapeLayer()
    func addPairOnView(_ view: UIView, icon: UIImage?, title: String, color: UIColor) {
        // views
        iconImageView.image = icon
        iconImageView.layer.masksToBounds = true
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = title
        
        // layers
        pairShape.fillColor = color.cgColor
        pairShape.strokeColor = UIColor.black.cgColor
        gradientLayer.colors = [UIColor.white.cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0, 1]
        
        // add all
        view.layer.addSublayer(pairShape)
        view.layer.addSublayer(gradientLayer)
        view.addSubview(iconImageView)
        view.addSubview(titleLabel)
    }
    
    // layout
    func layoutWithFrame(_ frame: CGRect, rightStartX: CGFloat) {
        let lineWidth = frame.height / 55
        
        let leftRect = CGRect(x: frame.minX, y: frame.minY, width: frame.height, height: frame.height).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)
        let rightRect = CGRect(x: rightStartX, y: frame.minY, width: frame.maxX - rightStartX, height: frame.height).insetBy(dx: lineWidth * 0.5, dy: lineWidth * 3)
        
        // background
        let shapePath = UIBezierPath(ovalIn: leftRect)
        shapePath.append(UIBezierPath(roundedRect: rightRect, cornerRadius: 4 * lineWidth))
        shapePath.move(to: CGPoint(x: leftRect.maxX, y: leftRect.midY))
        shapePath.addLine(to: CGPoint(x: rightRect.minX, y: leftRect.midY))
        
        pairShape.lineWidth = lineWidth
        pairShape.path = shapePath.cgPath
        
        gradientLayer.frame = CGRect(x: rightRect.minX, y: rightRect.minY, width: rightRect.width, height: rightRect.height * 0.6)
        // subviews
        iconImageView.frame = leftRect.insetBy(dx: 3 * lineWidth, dy: 3 * lineWidth)
        titleLabel.frame = rightRect.insetBy(dx: 5 * lineWidth, dy: 4 * lineWidth)
        titleLabel.font = UIFont.systemFont(ofSize: 14 * lineWidth, weight: .medium)
    }
}
