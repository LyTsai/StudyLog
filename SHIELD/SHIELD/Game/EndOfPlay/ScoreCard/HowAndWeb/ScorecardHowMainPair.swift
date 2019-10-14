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
    
    fileprivate let iconButton = UIButton(type: .custom)
    fileprivate let titleLabel = StrokeLabel()
    fileprivate let pairShape = CAShapeLayer()
    func addPairOnView(_ view: UIView, icon: UIImage?, title: String, color: UIColor) {
        // views
        iconButton.setBackgroundImage(icon, for: .normal)
        iconButton.backgroundColor = UIColor.white
        iconButton.layer.masksToBounds = true
        
        setTitle(title)
        
        // layers
        pairShape.fillColor = color.cgColor
        
        // add all
        view.layer.addSublayer(pairShape)
        view.addSubview(iconButton)
        view.addSubview(titleLabel)
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setMainColor(_ color: UIColor) {
        pairShape.fillColor = color.cgColor
    }
    
    func enableLeftAction() {
        iconButton.addTarget(self, action: #selector(buttonIsTouched), for: .touchUpInside)
    }
    
    @objc func buttonIsTouched() {
        leftIsTouched?()
    }
  
    // remove all
    func clearPair() {
        pairShape.removeFromSuperlayer()
        iconButton.removeFromSuperview()
        titleLabel.removeFromSuperview()
    }
    
    // layout
    func layoutWithFrame(_ frame: CGRect, rightStartX: CGFloat) {
        let lineWidth = min(frame.height / 55, (frame.maxX - rightStartX) / 133)
        
        // 55 * 55
        let leftRect = CGRect(x: frame.minX, y: frame.minY, width: frame.height, height: frame.height)
        
        // MWidth * 9
        let middleX = leftRect.maxX - 4 * lineWidth
        let middleRect = CGRect(x: middleX, y: frame.midY - 4.5 * lineWidth, width: rightStartX - middleX, height: 9 * lineWidth)
        // LWidth * 45
        let rightRect = CGRect(x: rightStartX, y: frame.minY, width: frame.maxX - rightStartX, height: frame.height).insetBy(dx: 0, dy: lineWidth * 5)
        
        // background
        let radius = 4 * lineWidth
        let shapePath = UIBezierPath(ovalIn: leftRect)
        shapePath.append(UIBezierPath(rect: middleRect))
        shapePath.append(UIBezierPath(roundedRect: rightRect, cornerRadius: radius))
        pairShape.path = shapePath.cgPath
        
        // subviews
        let leftInset = 5 * lineWidth
        iconButton.frame = leftRect.insetBy(dx: leftInset, dy: leftInset)
        iconButton.layer.cornerRadius = iconButton.bounds.width * 0.5
        titleLabel.frame = rightRect.insetBy(dx: radius, dy: lineWidth)
        titleLabel.font = UIFont.systemFont(ofSize: 14 * lineWidth, weight: .medium)
    }
}
