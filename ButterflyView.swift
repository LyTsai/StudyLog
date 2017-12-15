//
//  ButterflyView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/7.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class ButterflyView: UIView {
    let butterflyImageView = UIImageView()
    let label = UILabel()
    let thickCircle = ThickCircleView()
    
    var currentAngle: CGFloat = 0
    fileprivate let butterfly = ProjectImages.sharedImage.butterfly
    class func createWithFrame(_ frame: CGRect, angle: CGFloat, text: String) -> ButterflyView {
        let view = ButterflyView(frame: frame)
        view.setupWithAngle(angle, text: text)
        
        return view
    }
    
    fileprivate func setupWithAngle(_ angle: CGFloat, text: String) {
        // frames
        let standW = bounds.width / 153
        butterflyImageView.frame = bounds
        
        let viewCenter = CGPoint(x: bounds.midX, y: bounds.height * 78 / 121)
        thickCircle.frame = CGRect(center: viewCenter, length: 90 * standW)
        thickCircle.outerWidth = 2 * standW
        thickCircle.circleWidth = 6 * standW
        thickCircle.backgroundColor = UIColor.clear
        
        thickCircle.setNeedsDisplay()
        
        label.frame = CGRect(center: viewCenter, width: 67 * standW, height: 30 * standW)
        
        // setup
        butterflyImageView.image = butterfly
        
        thickCircle.layer.addBlackShadow(standW * 3)
        thickCircle.layer.shadowOffset = CGSize(width: 0, height: standW)
        
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11 * standW, weight: UIFontWeightSemibold)
        
        // add
        addSubview(butterflyImageView)
        addSubview(thickCircle)
        addSubview(label)
        
        // transform
        resetViewToAngle(angle)
    }
    
    func resetViewToAngle(_ angle: CGFloat)  {
        self.currentAngle = angle
        thickCircle.transform = CGAffineTransform.identity
        transform = CGAffineTransform(rotationAngle: angle)
        label.transform = CGAffineTransform(rotationAngle: -angle)
    }
    
    func addToRotation(_ angle: CGFloat)  {
        self.currentAngle = angle
        thickCircle.transform = CGAffineTransform.identity
        transform = transform.rotated(by: angle)
        label.transform = CGAffineTransform(rotationAngle: -angle)
    }
  
}
