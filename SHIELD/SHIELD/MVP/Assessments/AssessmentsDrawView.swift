//
//  AssessmentsDrawView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/3.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class AssessmentsDrawView: UIView {
    func drawTopicState(_ center: CGPoint, radius: CGFloat) {
        let topicPath = UIBezierPath(ovalIn: CGRect(center: center, length: radius * 2))
        topicPath.lineWidth = fontFactor

        pathDrawInfo = [(topicPath, UIColorFromHex(0xC1E795), UIColor.white)]
        imageDrawInfo.removeAll()
        
        setNeedsDisplay()
    }
    
    func drawTopicChosen(_ topFrame: CGRect, bottomPoint: CGPoint, left: CGPoint, right: CGPoint) {
        let middlePath = UIBezierPath()
        middlePath.move(to: bottomPoint)
        middlePath.addLine(to: CGPoint(x: topFrame.midX, y: topFrame.midY))
        middlePath.lineWidth = 2 * fontFactor
        
        let sidePath = UIBezierPath()
        sidePath.move(to: left)
        sidePath.addLine(to: bottomPoint)
        sidePath.addLine(to: right)
        sidePath.lineWidth = fontFactor
        
        pathDrawInfo = [(middlePath, UIColorFromHex(0x00C853), nil), (sidePath, UIColorFromHex(0x9CCC65), nil)]
        
        imageDrawInfo = [(UIImage(named: "cyanButterfly_circle")!, topFrame)]
        
        setNeedsDisplay()
    }
    
    func clearBoard() {
        pathDrawInfo.removeAll()
        imageDrawInfo.removeAll()
        setNeedsDisplay()
    }
    
    // path, strokeColor, fillColor
    fileprivate var pathDrawInfo = [(path: UIBezierPath, strokeColor: UIColor, fillColor: UIColor?)]()
    fileprivate var imageDrawInfo = [(image: UIImage, imageFrame: CGRect)]()
    override func draw(_ rect: CGRect) {
        for pathInfo in pathDrawInfo {
            if pathInfo.fillColor != nil {
                pathInfo.fillColor!.setFill()
                pathInfo.path.fill()
            }
            pathInfo.strokeColor.setStroke()
            pathInfo.path.stroke()
        }
        
        for imageInfo in imageDrawInfo {
            imageInfo.image.draw(in: imageInfo.imageFrame)
        }
    }
}
