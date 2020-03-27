//
//  CoreTextArcView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/1.
//  Copyright © 2017年 LyTsai. All rights reserved.
//
/* 删减版本，只保持简单的纯色文字画出*/
// https://developer.apple.com/library/content/samplecode/CoreTextArcCocoa/Introduction/Intro.html

import Foundation
import UIKit

class CoreTextArcView: UIView {
    // open
    var textFont = UIFont.systemFont(ofSize: 32)
    var text = "Curvaceous Type"
    var textColor = UIColor.purple
    var attributedString : NSAttributedString!
   
    var radius: CGFloat = 150
    var arcCenter = CGPoint(x: 160, y: 250)
    var middleAngle: CGFloat = -CGFloat(Double.pi) / 2.0
    var arcAngle: CGFloat = CGFloat(Double.pi) * 0.8
}

extension CoreTextArcView {
    override func draw(_ rect: CGRect) {

        // Initialize the text matrix to a known value
        let context = UIGraphicsGetCurrentContext()
        context?.textMatrix = CGAffineTransform.identity
        
        // Draw a white background
        if attributedString == nil {
            attributedString = NSAttributedString(string: text, attributes: [.font: textFont, .foregroundColor: textColor])
        }
        
        let line = CTLineCreateWithAttributedString(attributedString as CFAttributedString)
        let glyphCount = CTLineGetGlyphCount(line)
        if glyphCount == 0 {
            return
        }
        
        let glyphArcInfo = prepareGlyphArcInfo(line, glyphCount: glyphCount)
        
        // Move the origin from the lower left of the view nearer to its center.
        context?.saveGState()
        context?.translateBy(x: arcCenter.x, y: arcCenter.y)
        context?.rotate(by: CGFloat(arcAngle / 2))
        
        /*
         Now for the actual drawing. The angle offset for each glyph relative to the previous glyph has already been calculated; with that information in hand, draw those glyphs overstruck and centered over one another, making sure to rotate the context after each glyph so the glyphs are spread along a semicircular path.
         */
        var textPosition = CGPoint(x: 0, y: radius)
        context?.textPosition = textPosition
        
        let runArray = CTLineGetGlyphRuns(line) as! Array<CTRun>
        var glyphOffset: CFIndex = 0
        for run in runArray {
            let runGlyphCount = CTRunGetGlyphCount(run)
            
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
                CTRunDraw(run, context!, glyphRange)
            }
            
            glyphOffset += runGlyphCount
            
        }
        
        context?.restoreGState()
    }
    
    // calculation
    fileprivate func prepareGlyphArcInfo(_ line: CTLine, glyphCount: CFIndex) -> [(width: CGFloat, angle: CGFloat)] {
        var glyphArcInfo = [(width: CGFloat, angle: CGFloat)]()
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
        glyphArcInfo[0].angle = CGFloat(prevHalfWidth / CGFloat(lineLength) * arcAngle)
        
        // Divide the arc into slices such that each one covers the distance from one glyph's center to the next.
        for lineGlyphIndex in 1..<glyphCount {
            let halfWidth = glyphArcInfo[lineGlyphIndex].width / 2.0
            let prevCenterToCenter = prevHalfWidth + halfWidth
            
            glyphArcInfo[lineGlyphIndex].angle = prevCenterToCenter / CGFloat(lineLength) * arcAngle
            prevHalfWidth = halfWidth
        }
        
        return glyphArcInfo
    }
}




