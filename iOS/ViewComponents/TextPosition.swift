//
//  TextPosition.swift
//  MagniPhi
//
//  Created by L on 2021/4/2.
//  Copyright © 2021 MingHui. All rights reserved.
//

import Foundation
import UIKit

enum TextPosition: Int {
    case top, left, right, bottom, topLeft, topRight, bottomLeft, bottomRight
    
    var suggestedTextAlignment: NSTextAlignment {
        switch self {
        case .top, .bottom:
             return .center
        case .left, .topLeft, .bottomLeft:
             return .right
        case .right, .topRight, .bottomRight:
             return .left
        }
    }
    
    // side: image frame
    static func getFrame(_ textBounding: CGSize, sideFrame: CGRect, labelPosition: TextPosition, gap: CGFloat, verticalAdjustRatio: CGFloat) -> CGRect {
        let yAdjust = verticalAdjustRatio * sideFrame.height
        
        switch labelPosition {
        case .top:
            // frame
            return CGRect(origin: CGPoint(x: sideFrame.midX - textBounding.width * 0.5, y: -textBounding.height - gap), size: textBounding)
        case .bottom:
            return CGRect(origin: CGPoint(x: sideFrame.midX - textBounding.width * 0.5, y: textBounding.height + gap), size: textBounding)
        case .left:
            return CGRect(origin: CGPoint(x: sideFrame.minX - textBounding.width - gap, y: sideFrame.midY - textBounding.height * 0.5 + yAdjust), size: textBounding)
        case .right:
            return CGRect(origin: CGPoint(x: sideFrame.maxX + gap, y: sideFrame.midY - textBounding.height * 0.5 + yAdjust), size: textBounding)
        case .topLeft:
            return CGRect(origin: CGPoint(x: sideFrame.maxX - textBounding.width, y: -textBounding.height), size: textBounding)
        case .topRight:
            return CGRect(origin: CGPoint(x: sideFrame.minX, y: -textBounding.height), size: textBounding)
        case .bottomLeft:
            return CGRect(origin: CGPoint(x: sideFrame.maxX - textBounding.width, y: textBounding.height), size: textBounding)
        case .bottomRight:
            return CGRect(origin: CGPoint(x: sideFrame.minX, y: textBounding.height), size: textBounding)
        }
    }
    
    static func autoAdjust(_ arcCenter: CGPoint, viewCenter: CGPoint)-> (TextPosition, CGFloat)  {
        // top or bottom
        var labelPosition = TextPosition.top
        var verticalAdjustRatio: CGFloat = 0
        if abs(viewCenter.x - arcCenter.x) < 2 {
            if viewCenter.y > arcCenter.y {
                labelPosition = .bottom
            }else {
                labelPosition = .top
            }
        }else {
            let leftSign = viewCenter.x < arcCenter.x
            // left or right part
            labelPosition = leftSign ? .left : .right
            
            // more adjust
            var angle = Calculation.angleOfPoint(viewCenter, center: arcCenter)
            angle = angle < CGFloatPi ? abs(CGFloatPi * 0.5 - angle) : abs(CGFloatPi * 1.5 - angle)
            
            let topSign = viewCenter.y < arcCenter.y
            let moveSign: CGFloat = topSign ? -1 : 1
            
            // adjust if necessary
            if angle < CGFloatPi / 180 * 8 {
                if topSign {
                    labelPosition = leftSign ? .topLeft : .topRight
                }else {
                    labelPosition = leftSign ? .bottomLeft : .bottomRight
                }
            }else if angle < CGFloatPi / 180 * 15 {
                verticalAdjustRatio = 0.6 * moveSign
            }else if angle < CGFloatPi / 180 * 20 {
                verticalAdjustRatio = 0.5 * moveSign
            }else if angle < CGFloatPi / 180 * 35 {
                verticalAdjustRatio = 0.4 * moveSign
            }
        }
        
        return (labelPosition, verticalAdjustRatio)
    }
    
    static func getAutoAdjustRatioOfAngle(_ angle: CGFloat) -> (TextPosition, CGFloat) {
        var labelPosition = TextPosition.top
         var verticalAdjustRatio: CGFloat = 0
        
        let adjustedAngle = angle < CGFloatPi ? abs(CGFloatPi * 0.5 - angle) : abs(CGFloatPi * 1.5 - angle)
        
        let topSign = angle > CGFloatPi
        let leftSign = angle > CGFloatPi * 0.5 && angle < CGFloatPi * 1.5
        let moveSign: CGFloat = topSign ? -1 : 1
        
        // adjust if necessary
        if adjustedAngle < CGFloatPi / 180 * 10 {
            if topSign {
                labelPosition = leftSign ? .topLeft : .topRight
            }else {
                labelPosition = leftSign ? .bottomLeft : .bottomRight
            }
        }else if angle < CGFloatPi / 180 * 20 {
            verticalAdjustRatio = 0.5 * moveSign
        }else if angle < CGFloatPi / 180 * 35 {
            verticalAdjustRatio = 0.4 * moveSign
        }
        
        return (labelPosition, verticalAdjustRatio)
    }

}
