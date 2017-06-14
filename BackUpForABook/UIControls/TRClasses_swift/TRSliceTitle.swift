//
//  TRSliceTitle.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRSliceTitle: NSObject {
    var textPainter: ANCircleText?
    var size: Float?
    var style: RingTextStyle?
    var textAttributes = [String : Any]()
    var pointsPerFontSize: Float?
    var title: String?
    
    override init() {
        super.init()
        textPainter = ANCircleText.init()
        size = 18
        style = .alignMiddle
        textAttributes[NSFontAttributeName] = CTFontCreateWithName("Helvetica-Bold" as CFString, 10.0, nil)
        textAttributes[NSForegroundColorAttributeName] = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.4)
        textAttributes[NSStrokeColorAttributeName] = UIColor(red: 0.0, green: 0.8, blue: 0.0, alpha: 0.4)
        textAttributes[NSStrokeWidthAttributeName] = NSNumber(value: -3.0)
        pointsPerFontSize = 1.0
        
    }
    
    func setStringAttributes(_ font: String, size: Float, foregroundColor: UIColor, strokeColor: UIColor, strokeWidth: Float){
        let lbFont = CTFontCreateWithName(font as CFString, CGFloat(size), nil)
        textAttributes[NSFontAttributeName] = lbFont
        textAttributes[NSForegroundColorAttributeName] = foregroundColor.cgColor
        textAttributes[NSStrokeColorAttributeName] = strokeColor.cgColor
        textAttributes[NSStrokeWidthAttributeName] = NSNumber(value: strokeWidth)
        
    }
    
    // paint title at given position
    func paintSliceTitle(_ ctx: CGContext, radius: Float, left: Float, right: Float, center: CGPoint,height: Int){
        // make attributed string for the title 
        let attString = NSMutableAttributedString.init(string: title!, attributes: textAttributes)
        textPainter?.paintCircleText(ctx, text: attString, style: style!, radius: CGFloat(radius), width: CGFloat(size! * pointsPerFontSize!), left: CGFloat(left), right: CGFloat(right), center: center)
    }

}
