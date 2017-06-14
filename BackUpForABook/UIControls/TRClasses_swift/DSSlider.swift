//
//  DSSlider.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class DSSlider: NSObject {
    var length: Float?
    var height: Float?
    var space: Int?
    var faceColor: UIColor?
    
    override init() {
        super.init()
        length = 30
        height = 8
        space = 8
        faceColor = UIColor(red: 0, green: 0.45, blue: 0.94, alpha: 0.8)
    }
    
    func paint(_ ctx: CGContext){
        paintBar(ctx)
        paintArrows(ctx)
    }
    
    func paintBar(_ ctx: CGContext){
        ctx.saveGState()
        let slider = CGRect(x: CGFloat(-length! * 0.5), y: CGFloat(-height! * 0.5), width: CGFloat(length!), height: CGFloat(height!))
        let aPath = UIBezierPath(roundedRect: slider, cornerRadius: CGFloat(height! / 2.0))
        ctx.addPath(aPath.cgPath)
        // fill the slider area
        ctx.setFillColor(faceColor!.cgColor)
        ctx.addPath(aPath.cgPath)
        ctx.fillPath()
        // add a highlight over the bar
        let highlight = CGRect(x: CGFloat(-length! * 0.5 + height! * 0.5), y: 0.0, width: CGFloat(length! - height!), height: CGFloat(height! * 0.5))
        let aHighlightPath = UIBezierPath(roundedRect: highlight, cornerRadius: highlight.size.height * 1.0 / 2.0)
        ctx.addPath(aHighlightPath.cgPath)
        ctx.setFillColor(UIColor(white: 1.0, alpha: 0.4).cgColor)
        ctx.fillPath()
        // inner shadow
        ctx.setShadow(offset: CGSize.init(width: 0, height: 2.0), blur: 3.0, color: UIColor.gray.cgColor)
        ctx.addPath(aPath.cgPath)
        ctx.setStrokeColor(UIColor.gray.cgColor)
        ctx.strokePath()
        // outline the slider
        ctx.addPath(aPath.cgPath)
        ctx.setStrokeColor(UIColor.darkGray.cgColor)
        ctx.setLineWidth(0.5)
        ctx.strokePath()
        ctx.restoreGState()
    }
    
    func paintArrows(_ ctx: CGContext){
        let arrowSize = height! * 0.5
        let leftArrowPositon = CGPoint(x: CGFloat(0 - length! * 0.5 - Float(space!)), y: 0.0)
        let rightArrowPosition = CGPoint(x: CGFloat(0 + length! * 0.5 + Float(space!)), y: 0.0)
        // left arrow
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x: leftArrowPositon.x + CGFloat(arrowSize), y: leftArrowPositon.y - CGFloat(arrowSize)))
        arrowPath.addLine(to: leftArrowPositon)
        arrowPath.addLine(to: CGPoint(x: leftArrowPositon.x + CGFloat(arrowSize), y: leftArrowPositon.y + CGFloat(arrowSize)))
        ctx.addPath(arrowPath.cgPath)
        ctx.setShadow(offset: CGSize.init(width: 0, height: 2.0), blur: 3.0, color: UIColor.gray.cgColor)
        ctx.setStrokeColor(faceColor!.cgColor)
        ctx.setLineWidth(2.0)
        ctx.strokePath()
        
        // right arrow
        arrowPath.removeAllPoints()
        arrowPath.move(to: CGPoint(x: rightArrowPosition.x - CGFloat(arrowSize), y: rightArrowPosition.y - CGFloat(arrowSize)))
        arrowPath.addLine(to: rightArrowPosition)
        arrowPath.addLine(to: CGPoint(x: rightArrowPosition.x - CGFloat(arrowSize), y: rightArrowPosition.y + CGFloat(arrowSize)))
        ctx.addPath(arrowPath.cgPath)
        ctx.strokePath()
    }

}
