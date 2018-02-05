//
//  CoreTextArcView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/1.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

// https://developer.apple.com/library/content/samplecode/CoreTextArcCocoa/Introduction/Intro.html

import Foundation
import CoreText
import UIKit

class CoreTextArcView: UIView {
    // open
    var font = UIFont.systemFont(ofSize: 64)
    var text = "Curvaceous Type"
    var textColor = UIColor.black
    
    var attributedString : NSAttributedString! {
        /*
         NSLigatureAttributeName 该属性所对应的值是一个 NSNumber 对象(整数)。连体字符是指某些连在一起的字符，它们采用单个的图元符号。0 表示没有连体字符。1 表示使用默认的连体字符。2表示使用所有连体符号。默认值为 1（注意，iOS 不支持值为 2
         NSKernAttributeName(字间距)
         NSStrikethroughStyleAttributeName(删除线)， NSStrikethroughColorAttributeName 设置删除线颜色
         */
        let attributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: textColor, NSLigatureAttributeName: NSNumber(value: 0)] as [String : Any]
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    var radius: CGFloat = 150
    var arcCenter = CGPoint.zero
    
    var showsGlyphBounds = false
    var showsLineMetrics = false
    var dimsSubstitutedGlyphs = false
    
    // fileprivate
    fileprivate var glyphArcInfo = [(width: CGFloat, angle: CGFloat)]() // angle in radius
 
}

extension CoreTextArcView {
fileprivate func prepareGlyphArcInfo(_ line: CTLine, glyphCount: CFIndex) {
        let runArray = CTLineGetGlyphRuns(line) as! Array<CTRun>
        
        // Examine each run in the line, updating glyphOffset to track how far along the run is in terms of glyphCount.
        for run in runArray {
            let runGlyphCount = CTRunGetGlyphCount(run)
            
            // Ask for the width of each glyph in turn.
            for runGlyphIndex in 0..<runGlyphCount {
                let width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(runGlyphIndex, 1), nil, nil, nil))
                glyphArcInfo.append((width, 0))
            }
        }
        
        let lineLength = CTLineGetTypographicBounds(line, nil, nil, nil)
        var prevHalfWidth = glyphArcInfo[0].width / 2.0
        glyphArcInfo[0].angle = CGFloat(Double(prevHalfWidth) / lineLength * Double.pi)
        
        // Divide the arc into slices such that each one covers the distance from one glyph's center to the next.
        for lineGlyphIndex in 1..<glyphCount {
            let halfWidth = glyphArcInfo[lineGlyphIndex].width / 2.0
            let prevCenterToCenter = prevHalfWidth + halfWidth
            
            glyphArcInfo[lineGlyphIndex].angle = CGFloat((Double(prevCenterToCenter) / lineLength) * Double.pi)
            prevHalfWidth = halfWidth
        }
    }
}

extension CoreTextArcView {
    override func draw(_ rect: CGRect) {
        // font and text can never be nil, so skip the "if nil return" part
        
        // Initialize the text matrix to a known value
        let context = UIGraphicsGetCurrentContext()
        context?.textMatrix = CGAffineTransform.identity
        
        // Draw a white background
        UIColor.white.set()
        UIRectFill(rect)
        
        let line = CTLineCreateWithAttributedString(attributedString as CFAttributedString)
        let glyphCount = CTLineGetGlyphCount(line)
        if glyphCount == 0 {
            return
        }
        
        glyphArcInfo.removeAll()
        prepareGlyphArcInfo(line, glyphCount: glyphCount)
        
        // Move the origin from the lower left of the view nearer to its center.
        context?.saveGState()
        context?.translateBy(x: rect.midX, y: rect.midY - radius * 0.5)
        
        // Stroke the arc in red for verification.
        context?.beginPath()
        context?.addArc(center: CGPoint(x: 0, y: 0), radius: radius, startAngle: CGFloat(Double.pi), endAngle: 0, clockwise: true)
        context?.setStrokeColor(red: 1, green: 0, blue: 0, alpha: 1)
        context?.strokePath()
        
        // Rotate the context 90 degrees counterclockwise.
        context?.rotate(by: CGFloat(Double.pi / 2))
        
        /*
         Now for the actual drawing. The angle offset for each glyph relative to the previous glyph has already been calculated; with that information in hand, draw those glyphs overstruck and centered over one another, making sure to rotate the context after each glyph so the glyphs are spread along a semicircular path.
         */
        var textPosition = CGPoint(x: 0, y: radius)
        context?.textPosition = textPosition
        
        let runArray = CTLineGetGlyphRuns(line) as! Array<CTRun>
        var glyphOffset: CFIndex = 0
        for run in runArray {
            
            let runGlyphCount = CTRunGetGlyphCount(run)
            var drawSubstitutedGlyphsManually = false
            let dic = CTRunGetAttributes(run) as Dictionary
            let runFont = dic[kCTFontAttributeName] as! CTFont

            /*
             Determine if we need to draw substituted glyphs manually. Do so if the runFont is not the same as the overall font.
             */
            if dimsSubstitutedGlyphs && !(font.isEqual(runFont)) {                 drawSubstitutedGlyphsManually = true
            }
            
            for runGlyphIndex in 0..<runGlyphCount {
                let glyphRange = CFRangeMake(runGlyphIndex, 1)
                context?.rotate(by: -glyphArcInfo[runGlyphIndex + glyphOffset].angle)
                
                // Center this glyph by moving left by half its width.
                let glyphWidth = glyphArcInfo[runGlyphIndex + glyphOffset].width
                let halfGlyphWidth = glyphWidth / 2.0
                let poisitonForThisGlyph = CGPoint(x: textPosition.x - halfGlyphWidth, y: textPosition.y)
                
                // Glyphs are positioned relative to the text position for the line, so offset text position leftwards by this glyph's width in preparation for the next glyph.
                textPosition.x -= glyphWidth
                
                var textMatrix = CTRunGetTextMatrix(run)
                textMatrix.tx = poisitonForThisGlyph.x
                textMatrix.ty = poisitonForThisGlyph.y
                context?.textMatrix = textMatrix
                
                if !drawSubstitutedGlyphsManually {
                    CTRunDraw(run, context!, glyphRange)
                }else {
                    // 画了灰色的文字，没有执行
                    /*
                     We need to draw the glyphs manually in this case because we are effectively applying a graphics operation by setting the context fill color. Normally we would use kCTForegroundColorAttributeName, but this does not apply as we don't know the ranges for the colors in advance, and we wanted demonstrate how to manually draw.
                     */
                    let cgFont = CTFontCopyGraphicsFont(runFont, nil)
                    var glyph: CGGlyph = 0
                    var position = CGPoint.zero
                    CTRunGetGlyphs(run, glyphRange, &glyph)
                    CTRunGetPositions(run, glyphRange, &position)
                    
                    context?.setFont(cgFont)
                    context?.setFontSize(CTFontGetSize(runFont))
                    context?.setFillColor(red: 0.25, green: 0.25, blue: 0.25, alpha: 0.5)
                    context?.showGlyphs([glyph], at: [position])
                    //    CGContextShowGlyphsAtPositions(context, &glyph, &position, 1);
        
                }
                
                // Draw the glyph bounds
                // 文字的方形边框，最小包围了文字
                if showsGlyphBounds {
                    let glyphBounds = CTRunGetImageBounds(run, context, glyphRange)
                    
                    context?.setStrokeColor(red: 0, green: 0, blue: 1, alpha: 1)
                    context?.stroke(glyphBounds)
                }
                
                // Draw the bounding boxes defined by the line metrics
                // 文字边框，底部是齐的
                if showsLineMetrics {
                    var lineMetrics = CGRect.zero
                    var ascent: CGFloat = 0
                    var descent: CGFloat = 0
                    
                    CTRunGetTypographicBounds(run, glyphRange, &ascent, &descent, nil)
                    
                    // The glyph is centered around the y-axis
                    lineMetrics.origin.x = -halfGlyphWidth
                    lineMetrics.origin.y = poisitonForThisGlyph.y - descent
                    lineMetrics.size.width = glyphWidth
                    lineMetrics.size.height = ascent + descent
                    
                    context?.setStrokeColor(red: 0, green: 1, blue: 0, alpha: 1)
                    context?.stroke(lineMetrics)
                }
            }

            glyphOffset += runGlyphCount
        }
        
        context?.restoreGState()
    }
}
