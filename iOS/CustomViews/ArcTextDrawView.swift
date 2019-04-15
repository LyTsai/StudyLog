//
//  ArcTextDrawView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/4.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ArcTextDrawView: UIView {
    var text = "" {
        didSet{
            if text != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    var attributedString: NSMutableAttributedString {
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    fileprivate var attributes: [String: Any]!
    fileprivate var leftAngle = CGFloat(Double.pi)
    fileprivate var rightAngle = CGFloat(0)
    fileprivate var minRadius: CGFloat = 0
    func setTopArcWithFrame(_ frame: CGRect, angle: CGFloat, minRadius: CGFloat, attributes: [String: Any]) {
        self.backgroundColor = UIColor.clear
        
        self.frame = frame
        self.attributes = attributes
        self.minRadius = minRadius
        
        rightAngle = (CGFloat(Double.pi) - angle) * 0.5 * 180 / CGFloat(Double.pi)
        leftAngle = rightAngle - angle * 180 / CGFloat(Double.pi)
    }
    
    override func draw(_ rect: CGRect) {
        if text == "" {
            return
        }
        
        // text length
        let glyphCount = attributedString.length
        // TODO: -------- remove if the bug is fixed
        let angleOffset: CGFloat = glyphCount > 30 ? 3 : 0
        let drawLeftAngle = -leftAngle + angleOffset
        let drawRightAngle = -rightAngle + angleOffset
        
        // add border of glyph
        let totalRange = NSMakeRange(0, glyphCount)
        let strokeString = attributedString
        strokeString.addAttribute(NSStrokeColorAttributeName, value: UIColor.black, range: totalRange)
        strokeString.addAttribute(NSStrokeWidthAttributeName, value: NSNumber(value: 15), range: totalRange)
        ANCircleText().paintCircleText(UIGraphicsGetCurrentContext()!, text: strokeString, style: .alignMiddle, radius: minRadius, width: bounds.height * 0.5 - minRadius, left: drawLeftAngle, right: drawRightAngle, center: CGPoint(x: bounds.midX, y: bounds.midY))
        
        ANCircleText().paintCircleText(UIGraphicsGetCurrentContext()!, text: attributedString, style: .alignMiddle, radius: minRadius, width: bounds.height * 0.5 - minRadius, left: drawLeftAngle, right: drawRightAngle, center: CGPoint(x: bounds.midX, y: bounds.midY))
    }
}
