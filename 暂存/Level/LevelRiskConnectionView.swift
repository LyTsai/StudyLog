//
//  LevelRiskConnectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/5.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// vertical bar
// barStyle: vertical
class RiskGradientBar: UIView {
    // size
    var barThumbRatio: CGFloat = 0.5
    var barBorderWidth: CGFloat = 3 // of the bar and thumb
    var thumbBorderWidth: CGFloat = 3.25
    var middleColorPosition: CGFloat = 0.15
    
    // colors
    var fullColor = UIColorFromRGB(255, green: 61, blue: 0)
    var middleColor = UIColorFromRGB(255, green: 234, blue: 0)
    var zeroColor = UIColorFromRGB(100, green: 221, blue: 23)
    var barFillColor = UIColorFromRGB(155, green: 155, blue: 155)
    var barBorderColor = UIColorFromRGB(224, green: 224, blue: 224)
    var thumbBorderColor = UIColor.darkGray
    var thumbFillColor = UIColorFromRGB(254, green: 254, blue: 255)
    
    // text
    fileprivate var thumbText = "100%x" // attributedString??
    var value: CGFloat = 0.8 {
        didSet{
            thumbText = "\(value * 100)%X"
            // thumb, mask
        }
    }
    
    // calculted
    fileprivate var barWidth: CGFloat {
        return barThumbRatio * bounds.width
    }
    fileprivate var barHeight: CGFloat {
        return bounds.height - bounds.width
    }
    
    fileprivate var barFrame: CGRect {
        return CGRect(x: (bounds.width - barWidth) * 0.5, y: bounds.width * 0.5, width: barWidth, height: barHeight)
    }
    // layers

        
    // MARK: -------- methods
    func updateUI() {
        setupBarLayer()
        setupGradientLayer()
        setupThumbLayer()
    }
    
    fileprivate func setupGradientLayer(){
        let innerFrame = barFrame.insetBy(dx: barBorderWidth, dy: barBorderWidth)
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [zeroColor.cgColor, middleColor.cgColor, fullColor.cgColor]
        gradientLayer.locations = [0, middleColorPosition as NSNumber,1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0, y: 0)
        
        gradientLayer.frame = innerFrame
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: innerFrame.height * (1 - value), width: innerFrame.width, height: innerFrame.height * value), cornerRadius: innerFrame.midX).cgPath
        gradientLayer.mask = maskLayer
        layer.addSublayer(gradientLayer)
    }
    
    fileprivate func setupBarLayer(){
        let barLayer = CALayer()
        barLayer.frame = barFrame
        barLayer.cornerRadius = barWidth * 0.5
        barLayer.borderWidth = barBorderWidth
        barLayer.borderColor = barBorderColor.cgColor
        barLayer.backgroundColor = barFillColor.cgColor
        
        layer.addSublayer(barLayer)
    }
    
    fileprivate func setupThumbLayer(){
        let thumbLayer = CALayer()
        thumbLayer.frame = CGRect(x: 0, y: bounds.height * (1 - value) ,width: bounds.width, height: bounds.width)
        thumbLayer.cornerRadius = bounds.width * 0.5
        thumbLayer.borderWidth = thumbBorderWidth
        thumbLayer.borderColor = thumbBorderColor.cgColor
        thumbLayer.backgroundColor = thumbFillColor.cgColor
        
        layer.addSublayer(thumbLayer)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}
