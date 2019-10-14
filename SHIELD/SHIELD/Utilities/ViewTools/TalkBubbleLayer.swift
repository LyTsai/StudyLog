//
//  TalkBubbleLayer.swift
//  AnnielyticX
//
//  Created by iMac on 2018/10/29.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class TalkBubbleLayer: CAShapeLayer {
    /*
        topSpace
            triE * 0.5
     tirH
            triE * 0.5
     
     */
    func setRightBubbleWithFrame(_ frame: CGRect, bubbleRadius: CGFloat, topSpace: CGFloat, triE: CGFloat, triH: CGFloat) {
        let mainRect = CGRect(x: frame.minX, y: frame.minY, width: frame.width - triH, height: frame.height)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: mainRect.minX + bubbleRadius, y: mainRect.minY + bubbleRadius), radius: bubbleRadius, startAngle: -CGFloat(Double.pi) * 0.5, endAngle: -CGFloat(Double.pi), clockwise: false)
        path.addLine(to: CGPoint(x: mainRect.minX, y: mainRect.maxY - bubbleRadius))
        path.addArc(withCenter: CGPoint(x: mainRect.minX + bubbleRadius, y: mainRect.maxY - bubbleRadius), radius: bubbleRadius, startAngle: -CGFloat(Double.pi), endAngle: CGFloat(Double.pi) * 0.5, clockwise: false)
        path.addLine(to: CGPoint(x: mainRect.maxX - bubbleRadius, y: mainRect.maxY))
        path.addArc(withCenter: CGPoint(x: mainRect.maxX - bubbleRadius, y: mainRect.maxY - bubbleRadius), radius: bubbleRadius, startAngle: CGFloat(Double.pi) * 0.5, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: mainRect.maxX, y: mainRect.minY + topSpace + triE))
        path.addLine(to: CGPoint(x: frame.maxX, y: mainRect.minY + topSpace + triE * 0.5))
        path.addLine(to: CGPoint(x: mainRect.maxX, y: mainRect.minY + topSpace))
        path.addLine(to: CGPoint(x: mainRect.maxX, y: mainRect.minY + bubbleRadius))
        path.addArc(withCenter: CGPoint(x: mainRect.maxX - bubbleRadius, y: mainRect.minY + bubbleRadius), radius: bubbleRadius, startAngle: 0, endAngle: -CGFloat(Double.pi) * 0.5, clockwise: false)
        path.close()
        
        self.path = path.cgPath
    }
    
    func setLeftBubbleWithFrame(_ frame: CGRect, bubbleRadius: CGFloat, topSpace: CGFloat, triE: CGFloat, triH: CGFloat) {
        let mainRect = CGRect(x: frame.minX + triH, y: frame.minY, width: frame.width - triH, height: frame.height)
        
        let path = UIBezierPath(arcCenter: CGPoint(x: mainRect.minX + bubbleRadius, y: mainRect.minY + bubbleRadius), radius: bubbleRadius, startAngle: -CGFloat(Double.pi) * 0.5, endAngle: -CGFloat(Double.pi), clockwise: false)
        path.addLine(to: CGPoint(x: mainRect.minX, y: mainRect.minY + topSpace))
        path.addLine(to: CGPoint(x: frame.minX, y: mainRect.minY + topSpace + triE * 0.5))
        path.addLine(to: CGPoint(x: mainRect.minX, y: mainRect.minY + topSpace + triE))
        path.addLine(to: CGPoint(x: mainRect.minX, y: mainRect.maxY - bubbleRadius))
        
        path.addArc(withCenter: CGPoint(x: mainRect.minX + bubbleRadius, y: mainRect.maxY - bubbleRadius), radius: bubbleRadius, startAngle: -CGFloat(Double.pi), endAngle: CGFloat(Double.pi) * 0.5, clockwise: false)
        path.addLine(to: CGPoint(x: mainRect.maxX - bubbleRadius, y: mainRect.maxY))
        path.addArc(withCenter: CGPoint(x: mainRect.maxX - bubbleRadius, y: mainRect.maxY - bubbleRadius), radius: bubbleRadius, startAngle: CGFloat(Double.pi) * 0.5, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: mainRect.maxX, y: mainRect.minY + bubbleRadius))
        path.addArc(withCenter: CGPoint(x: mainRect.maxX - bubbleRadius, y: mainRect.minY + bubbleRadius), radius: bubbleRadius, startAngle: 0, endAngle: -CGFloat(Double.pi) * 0.5, clockwise: false)
        path.close()
        
        self.path = path.cgPath
    }
}
