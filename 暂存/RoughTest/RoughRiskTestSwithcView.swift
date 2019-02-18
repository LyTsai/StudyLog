//
//  RoughRiskTestViews.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/19.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class GenderSwitch: UIView {

    // switch
    var totalEdgeInsets = UIEdgeInsets(top: 15, left: 30, bottom: 15, right: 30)
    var lineWidth: CGFloat = 1.5
    var barPicProportion: CGFloat = 0.56
    
    fileprivate var imageWidth: CGFloat = 50
    fileprivate var barFrame =  CGRect.zero // must reset

    var switchBackColor = UIColor.lightGray
    var thumbColor = darkGreenColor
    var borderColor = UIColor.darkGray
    
    var isMale = true
    var animationDuration: TimeInterval = 0.3
    let imagesAndTitle = ImagesAndTitles()
    
    // MARK: method for creating the view
    fileprivate let switchControl = CAShapeLayer()
    func addSwitchBar() {
        layoutSubviews()
        
        backgroundColor = UIColor.clear
        let radius = barFrame.height * 0.5 - lineWidth
        let roundedRectPath = UIBezierPath(roundedRect: barFrame.insetBy(dx: lineWidth, dy: lineWidth), cornerRadius: radius)
        let backgroundLayer = CAShapeLayer()
        backgroundLayer.fillColor = switchBackColor.cgColor
        backgroundLayer.strokeColor = borderColor.cgColor
        backgroundLayer.lineWidth = lineWidth
        backgroundLayer.path = roundedRectPath.cgPath
        layer.addSublayer(backgroundLayer)
        
        let innerLineWidth = barFrame.height - lineWidth + 1
        let switchControlPath = UIBezierPath()
        switchControlPath.move(to: CGPoint(x: barFrame.minX + radius, y: barFrame.midY))
        switchControlPath.addLine(to: CGPoint(x: barFrame.maxX - radius, y: barFrame.midY))
        switchControl.path = switchControlPath.cgPath
        switchControl.lineCap = kCALineCapRound
        switchControl.lineWidth = innerLineWidth
        switchControl.strokeColor = thumbColor.cgColor
        switchControl.fillColor = UIColor.clear.cgColor
        switchControl.strokeEnd = 0.4
        layer.addSublayer(switchControl)
        
        imagesAndTitle.backgroundColor = UIColor.clear
        imagesAndTitle.thumbColor = thumbColor
        imagesAndTitle.lineWidth = lineWidth
        imagesAndTitle.borderColor = borderColor
        
        imagesAndTitle.barFrame = barFrame
        imagesAndTitle.imageSize = CGSize(width: imageWidth, height: imageWidth)
        imagesAndTitle.isMale = isMale
        
        addSubview(imagesAndTitle)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeGender))
        addGestureRecognizer(tapGesture)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        imageWidth = bounds.height - totalEdgeInsets.top - totalEdgeInsets.bottom
        let barHeight = imageWidth * barPicProportion
    
        barFrame = CGRect(x: totalEdgeInsets.left + imageWidth * 0.5, y: totalEdgeInsets.top + imageWidth * 0.5 - barHeight * 0.5 , width: bounds.width - totalEdgeInsets.left - totalEdgeInsets.right - imageWidth, height: barHeight)
        imagesAndTitle.frame = bounds
        imagesAndTitle.setNeedsDisplay()
    }
    
    func changeGender() {
        isMale = !isMale
        imagesAndTitle.isMale = isMale
        
        valueChangedWithAnimationDuration(animationDuration)
        imagesAndTitle.setNeedsDisplay()
    }
    
    fileprivate func valueChangedWithAnimationDuration(_ duration: TimeInterval) {
        let times = [0,0.49,0.51,1]
        
        let switchControlStrokeStart = CAKeyframeAnimation(keyPath: "strokeStart")
        switchControlStrokeStart.values = isMale ? [1, 0, 0 , 0] : [0, 0, 0, 0.5]
        switchControlStrokeStart.keyTimes = times as [NSNumber]?
        switchControlStrokeStart.duration = duration
        switchControlStrokeStart.isRemovedOnCompletion = true // if not set, will not influent the result

        let switchControlStrokeEnd = CAKeyframeAnimation(keyPath: "strokeEnd")
        switchControlStrokeEnd.values = isMale ? [1, 1, 1, 0.4] : [0, 1, 1, 1]
        switchControlStrokeEnd.keyTimes = times as [NSNumber]?
        switchControlStrokeEnd.duration = duration
        switchControlStrokeEnd.isRemovedOnCompletion = true

        // animationGroup
        let switchControlAnimation : CAAnimationGroup = CAAnimationGroup()
        switchControlAnimation.animations = [switchControlStrokeStart,switchControlStrokeEnd]
        switchControlAnimation.fillMode = kCAFillModeForwards
        switchControlAnimation.isRemovedOnCompletion = false
        switchControlAnimation.duration = duration

        let animationKey = isMale ? "Male" : "Female"
        switchControl.add(switchControlAnimation, forKey: animationKey)
    }
    
}

class ImagesAndTitles: UIView {

    var thumbColor = UIColor.white
    var lineWidth: CGFloat = 1.5
    var borderColor = UIColor.darkGray
    
    var barFrame =  CGRect.zero
    var isMale = true
    
    // images and words
    var imageSize = CGSize(width: 50, height: 50)
    var leftImage = UIImage(named: "flowers")! // TODO: if nil , use default image
    var rightImage = UIImage(named: "flowers")!
    var leftTitle: NSString = "Male"
    var rightTitle: NSString = "Female"
    var titleFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    var gap: CGFloat = 4
    
    // calculated properties, private and read only
    fileprivate var leftImageFrame: CGRect {
        return CGRect(x: barFrame.minX - imageSize.width * 0.5, y: barFrame.midY - imageSize.height * 0.5, width: imageSize.width, height: imageSize.height)
    }
    fileprivate var rightImageFrame: CGRect {
        return CGRect(x: 2 * barFrame.midX - leftImageFrame.midX - leftImageFrame.width * 0.5, y: leftImageFrame.minY, width: leftImageFrame.width, height: leftImageFrame.height)
    }
    fileprivate var leftTitleColor: UIColor{
        return isMale ? UIColor.white : UIColor.darkGray
    }
    fileprivate var rightTitleColor: UIColor{
        return isMale ? UIColor.darkGray : UIColor.white
    }
    
    fileprivate var leftTitleFrame: CGRect {
        return CGRect(x: leftImageFrame.maxX + gap, y: barFrame.minY + gap, width: barFrame.width * 0.5, height: barFrame.height - 2 * gap)
    }
    
    fileprivate var rightTitleFrame: CGRect {
        return CGRect(x: barFrame.midX + gap, y: barFrame.minY + gap, width: barFrame.width * 0.5, height: barFrame.height - 2 * gap)
    }
    
    // draw layer
    override func draw(_ rect: CGRect) {
        // draw words
        let leftAttribute = [NSForegroundColorAttributeName: leftTitleColor, NSFontAttributeName: titleFont] as [String : Any]
        let rightAttribute = [NSForegroundColorAttributeName: rightTitleColor, NSFontAttributeName: titleFont] as [String : Any]
        leftTitle.draw(in: leftTitleFrame, withAttributes: leftAttribute)
        rightTitle.draw(in: rightTitleFrame, withAttributes: rightAttribute)
        
        // draw images
        let leftPath = UIBezierPath(ovalIn: leftImageFrame)
        let rightPath = UIBezierPath(ovalIn: rightImageFrame)
        leftPath.append(rightPath)
        leftPath.addClip()

        drawWithImageFrame(leftImageFrame, isColorful: isMale, image: leftImage)
        drawWithImageFrame(rightImageFrame, isColorful: !isMale, image: rightImage)
    }
    
    fileprivate func drawWithImageFrame(_ frame: CGRect, isColorful: Bool, image: UIImage){
        let borderPath = UIBezierPath(ovalIn: frame)
        
        let imageToDraw = isColorful ? image : image.convertImageToGrayScale()
        imageToDraw.draw(in: frame)
        (isColorful ? thumbColor : borderColor).setStroke()
        
        borderPath.lineWidth = lineWidth * 2
        borderPath.stroke()
    }
}
