//
//  BorderControl.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/25.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class BorderImageControl: UIControl {
    fileprivate let iconImageView = UIImageView()
    fileprivate func addBasic() {
        layer.borderColor = UIColor.black.cgColor
        layer.masksToBounds = true
        iconImageView.backgroundColor = UIColor.white
        iconImageView.contentMode = .scaleAspectFit
        addSubview(iconImageView)
    }
    
    class func createWithIcon(_ icon: UIImage?, circleColor: UIColor) -> BorderImageControl {
        let control = BorderImageControl()
        control.addBasic()
        control.setupWithIcon(icon, circleColor: circleColor)
        return control
    }
    
    func setupWithIcon(_ icon: UIImage?, circleColor: UIColor) {
        iconImageView.image = icon
        backgroundColor = circleColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.height / 55
        
        layer.borderWidth = one
        layer.cornerRadius = bounds.height * 0.5
        iconImageView.frame = bounds.insetBy(dx: 4 * one, dy: 4 * one)
        let imageMask = CAShapeLayer()
        imageMask.path = UIBezierPath(ovalIn: iconImageView.bounds).cgPath
        iconImageView.layer.mask = imageMask
    }
}

class BorderTextControl: UIControl {
    var text: String! {
        didSet{
            label.text = text
        }
    }
    
    fileprivate let label = UILabel()
    fileprivate let borderLayer = CAShapeLayer()
    fileprivate func addBasic() {
        self.backgroundColor = UIColor.white
        
        label.numberOfLines = 0
        addSubview(label)
        
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColor.black.cgColor
        layer.addSublayer(borderLayer)
    }
    
    class func createWithText(_ text: String, color: UIColor) -> BorderTextControl {
        let control = BorderTextControl()
        control.addBasic()
        control.text = text
        control.layer.borderColor = color.cgColor
        
        return control
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = min(bounds.height / 45, bounds.width / 175)
        
        borderLayer.lineWidth = one
        borderLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 4 * one).cgPath
        layer.borderWidth = one * 3
        layer.cornerRadius = 4 * one
        label.frame = bounds.insetBy(dx: 8 * one, dy: 5 * one)
        label.font = UIFont.systemFont(ofSize: 12 * one)
    }
}
