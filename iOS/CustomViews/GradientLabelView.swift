//
//  GradientLabelView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/22.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class GradientLabelView: UIControl {
    fileprivate let gradientLayer = CAGradientLayer()
    let textLabel = UILabel()
    fileprivate let shapeLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBasic()
    }
    
    // add subviews(layer)
    fileprivate func addBasic() {
        // gradientBack
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.locations = [0.05, 0.95]
        gradientLayer.borderColor = UIColor.black.cgColor
        
        textLabel.numberOfLines = 0
        textLabel.textAlignment = .center
        
        layer.addSublayer(gradientLayer)
        addSubview(textLabel)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(shapeLayer)
    }
    
    func setupWithTopColor(_ topColor: UIColor, bottomColor: UIColor, text: String)  {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        textLabel.text = text
    }
    
    func setLeftAlignText(_ text: String, topColor: UIColor, bottomColor: UIColor) {
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        textLabel.text = text
        textLabel.textAlignment = .left
    }
    
    func addBorder(_ rounding: UIRectCorner, borderWidth: CGFloat, cornerRadius: CGFloat)  {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: rounding, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        shapeLayer.path = path.cgPath
        
        let gradientMask = CAShapeLayer()
        gradientMask.path = path.cgPath
        gradientLayer.mask = gradientMask
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let lineWidth = min(bounds.width / 165, bounds.height / 45)
        
        shapeLayer.lineWidth = lineWidth * 1.5
        gradientLayer.frame = bounds
        textLabel.frame = bounds.insetBy(dx: 4 * lineWidth, dy: lineWidth * 0.5)
        textLabel.font = UIFont.systemFont(ofSize: 14 * lineWidth, weight: .medium)
    }
}
