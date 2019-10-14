//
//  GradientProcessBar.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/12/14.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class GradientProcessBar: UIView {
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let maskLayer = CAShapeLayer()
    fileprivate let borderLayer = CAShapeLayer()
    fileprivate let light = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutSubviews()
    }
    
    class func createWithFrame(_ frame: CGRect, colors: [CGColor], locations: [NSNumber], value: CGFloat) -> GradientProcessBar {
        let bar = GradientProcessBar(frame: frame)
        bar.setupBasic()
        bar.setupWithColors(colors, locations: locations, value: value)
        
        return bar
    }
    // add sub
    fileprivate func setupBasic() {
        backgroundColor = UIColor.clear
        
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        layer.addSublayer(gradientLayer)
        
        maskLayer.fillColor = UIColor.red.cgColor
        maskLayer.strokeColor = UIColor.red.cgColor
        gradientLayer.mask = maskLayer
        
        borderLayer.lineWidth = fontFactor * 0.5
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(borderLayer)
        
        light.backgroundColor = UIColor.white.withAlphaComponent(0.35)
        addSubview(light)
    }
    
    // setup
    func setupWithColors(_ colors: [CGColor], locations:[NSNumber], value: CGFloat) {
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        setupWithValue(value)
    }
    
    func setupWithColor(_ color: CGColor, value: CGFloat) {
        borderLayer.fillColor = color
        gradientLayer.isHidden = true
        setupWithValue(value)
    }
    
    fileprivate var barValue: CGFloat = 0
    func setupWithValue(_ value: CGFloat) {
        barValue = max(min(value, 1), 0)
       
        borderLayer.isHidden = (barValue == 0)
        gradientLayer.isHidden = (barValue == 0)
        
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        let maskFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width * barValue, height: bounds.height))
        let path = UIBezierPath(roundedRect: maskFrame, cornerRadius: bounds.midY)
        maskLayer.path = path.cgPath
        borderLayer.path = path.cgPath
        light.frame = CGRect(x: bounds.midY, y: 2, width: min(15, bounds.width * barValue * 0.3), height: min(2, bounds.height * 0.2))
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0.5, width: bounds.width, height: bounds.height - 0.5), cornerRadius: bounds.midY - 0.25)
        UIColorGray(218).setFill()
        path.fill()
        
        // inner shadow
        path.append(UIBezierPath(roundedRect: bounds, cornerRadius: bounds.midY))
        UIColor.white.setFill()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        ctx.setShadow(offset: CGSize(width: 0, height: fontFactor), blur: 2 * fontFactor, color: UIColor.black.cgColor)
        path.usesEvenOddFillRule = true
        path.fill()
        
        ctx.restoreGState()
        
    }
    
}
