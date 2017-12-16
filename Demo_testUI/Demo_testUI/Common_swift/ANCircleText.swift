//
//  ANCircleText.swift
//  ANBookPad
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

//全局函数角度转弧度
func DEGREE_TO_RADIANS(_ degree:CGFloat) -> CGFloat{return (CGFloat(M_PI) * degree) / 180.0}


enum RingTextStyle:Int{
    case none = 0x00
    case alignTop = 0x01
    case alignMiddle = 0x02
    case alignBottom = 0x04
    case ori_Circle = 0x10
    case ori_Left2Right = 0x20
}
// 环形字体画法
class ANCircleText: NSObject {
    
    //space between charactors
    var space :Int!
    
    override init() {
        super.init()
        space = 1
    }
    
    // Method parameter :
    // radius - position of inner ring edge
    // width  - size of ring. radius + size produce the outer ring edge
    // left   - left angel (in degree)
    // right  - right angel (in degree)
    // center - ring center
    func paintCircleText(_ ctx: CGContext,
                          text: NSMutableAttributedString,
                         style: RingTextStyle,
                        radius: CGFloat,
                         width: CGFloat,
                          left: CGFloat,
                         right: CGFloat,
                        center: CGPoint){
        
        var newRadius = radius
        
        // 1.make adjustment on radius depends on style
        if (style.rawValue & RingTextStyle.alignBottom.rawValue) != 0x00{
            newRadius += text.size().height - width * 0.5
        }else if (style.rawValue & RingTextStyle.alignMiddle.rawValue) != 0x00{
            newRadius += width * 0.5
        }else if (style.rawValue & RingTextStyle.alignTop.rawValue) != 0x00{
            newRadius += width
        }
        
        // 2.paint with different RingTextStyle_Ori
        if (style.rawValue & RingTextStyle.ori_Left2Right.rawValue) != 0x00{
            // first half clockwise
            drawCircleText(ctx, text: text, radius: newRadius, width: width, left: left, right: right, center: center, clockWise: (left + right) * 0.5 < 180.0)
        }else{
            drawCircleText(ctx, text: text, radius: newRadius, width: width, left: left, right: right, center: center, clockWise: true)
        }
    }
    
    func drawCircleText(_ ctx: CGContext,
                         text: NSMutableAttributedString,
                       radius: CGFloat,
                        width: CGFloat,
                         left: CGFloat,
                        right: CGFloat,
                       center: CGPoint,
                    clockWise: Bool){
        var newRadius = radius
        // allowed title range in begin and end radians
        let rL = DEGREE_TO_RADIANS(left)
        let rR = DEGREE_TO_RADIANS(right)
        // setup drawing mode
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        text.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, text.length))
        // total size of title string
        let size = text.size()
        var rect = CGRect.init()
        if clockWise == true{
            // paint the label in the middle ring position
            newRadius += size.height * 0.5
            // go over each letters and draw string letters centered within left and right
            let circumference = 2 * newRadius * CGFloat(M_PI)
            // total title length in radian unit
            let rTitleLen = CGFloat(M_PI) * 2 / circumference * size.width
            // paint the string one charactor at a time starting from the left most position
            var aChar = (rL + rR) * 0.5 + rTitleLen * 0.5
            for i in 0..<text.length {
                // one charactor at a time
                let range = NSMakeRange(i, 1)
                let oneCharString = text.attributedSubstring(from: range)
                
                // calculate character drawing point .center of charactor
                let charPoint = CGPoint(x: newRadius * cos(-aChar) + center.x, y: center.y
                 + newRadius * sin(-aChar))
                // save the current context and do the character rotation magic
                ctx.saveGState()
                ctx.translateBy(x: charPoint.x , y: charPoint.y)
                let textTransform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2) - aChar)
                ctx.concatenate(textTransform)
                ctx.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
                ctx.translateBy(x: -charPoint.x, y: -charPoint.y)
                
                rect.origin = charPoint
                rect.origin.y += 0.5 * size.height
                rect.size.height = size.height + 2
                rect.size.width = size.width
                
                let path = CGMutablePath()
                path.addRect(rect)
                let framesetter = CTFramesetterCreateWithAttributedString(oneCharString)
                let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, oneCharString.length), path, nil)
                
                // paint the label, if larger than rl then will not paint
                if aChar >= rR && aChar <= rL{
                    CTFrameDraw(frame, ctx)
                }
                
                // restore context to make sure the rotation is only applied to this character
                ctx.restoreGState()
                
                // start angle for next charactor
                aChar -= CGFloat(M_PI) * 2 / circumference * (oneCharString.size().width + CGFloat(space!))
            }
        }else{
            newRadius -= size.height * 0.5
            let circumference = 2 * newRadius * CGFloat(M_PI)
            let rTitleLen = CGFloat(M_PI) * 2 / circumference * size.width
            var aChar = (rL + rR) * 0.5 - rTitleLen * 0.5
            for charIndex in 0..<text.length {
                let range = NSMakeRange(charIndex, 1)
                let oneCharString = text.attributedSubstring(from: range)
                let charPoint = CGPoint.init(x: newRadius * cos(-aChar) + center.x, y: center.y + newRadius * sin(-aChar))
                ctx.saveGState()
                ctx.translateBy(x: charPoint.x, y: charPoint.y)
                let textTransform = CGAffineTransform.init(rotationAngle: -CGFloat(M_PI_2) - aChar)
                ctx.concatenate(textTransform)
                ctx.textMatrix = CGAffineTransform.init(scaleX: 1.0, y: -1.0)
                ctx.translateBy(x: -charPoint.x, y: -charPoint.y)
                
                rect.origin = charPoint
                rect.origin.y += 0.5 * size.height
                rect.size.height = size.height + 2
                rect.size.width = size.width
                
                let path = CGMutablePath()
                path.addRect(rect)
                let framesetter = CTFramesetterCreateWithAttributedString(oneCharString)
                let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, oneCharString.length), path, nil)
                CTFrameDraw(frame, ctx)
                ctx.saveGState()
                aChar += CGFloat(M_PI) * 2 / circumference * (oneCharString.size().width + CGFloat(space!))
                
            }
        }
    }
}
