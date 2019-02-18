//
//  IntroPageRisksDisplayView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/25.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation
/*
 Situations:
 1. no risks: as tag? always shows
 2. less than 3: show/hide
 3. more than 3
 
 */
class IntroPageRisksDisplayView: UIView {
    var tableIsFolded = false
    var fillColor = UIColorFromRGB(139, green: 195, blue: 74).cgColor {
        didSet{
            backShape.fillColor = fillColor
        }
    }
    class func createWithFrame(_ frame: CGRect, riskNumber: Int) -> IntroPageRisksDisplayView {
        let displayView = IntroPageRisksDisplayView(frame: frame)
        displayView.addAndSetupWithNumber(riskNumber)
        
        return displayView
    }
    fileprivate let textLabel = UILabel()
    fileprivate let imageView = UIImageView(image: UIImage(named: "arrow_down_white"))
    fileprivate let backShape = CAShapeLayer()
    fileprivate func addAndSetupWithNumber(_ number: Int) {

        backgroundColor = UIColor.clear
        
        // topLine
        let topLine = UIView(frame: CGRect(x: 0 ,y: 0, width: bounds.width, height: fontFactor))
        topLine.backgroundColor = UIColor.white
        
        // back
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: 8 * fontFactor, height: 5 * fontFactor)).cgPath
        backShape.path = path
        backShape.fillColor = fillColor
        // shadow
        backShape.shadowPath = path
        backShape.shadowColor = UIColor.black.cgColor
        backShape.shadowOpacity = 0.7
        backShape.shadowRadius = 2 * fontFactor
        backShape.shadowOffset = CGSize(width: 0, height: 2 * fontFactor)
        
        // back and line
        layer.addSublayer(backShape)
        addSubview(topLine)
        
        // subview
        if number == 0 {
            // textLabel
            textLabel.frame = bounds.insetBy(dx: 10, dy: 1)
            textLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.65, weight: UIFontWeightMedium)
            textLabel.textAlignment = .center
            textLabel.textColor = UIColor.white
            textLabel.text = "No Algorithm"
            addSubview(textLabel)
        }else {
            // imageView
            imageView.contentMode = .scaleAspectFit
            imageView.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), width: bounds.height * 1.2, height: bounds.height * 0.45)
            setupState(false)
            addSubview(imageView)
        }
    }
    
    func setupState(_ cellFolded: Bool) {
        if cellFolded {
            imageView.transform = CGAffineTransform.identity
        }else {
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
        }
    }
}
