//
//  TRMLabels.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/24.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRMLabels: NSObject {
    var labels: [String: ANNamedText]?
    var keys: [String]?
    
    override init() {
        super.init()
        labels = [String : ANNamedText]()
        keys = [String]()
    }
    
    // add one label field
    func addLabel(_ key: String, label: ANNamedText){
        // already have one key
        if labels![key] != nil {return}
        
        // add key - label object pair
        labels?[key] = label
        keys?.append(key)
    }
    
    // get label object
    func getLabel(_ key: String) -> ANNamedText{
        return labels![key]!
    }
    
    
    // paint selected labels in the order of keys specified in the array, return end position
    func paint(_ ctx: CGContext, orderByKeys: [String], alignment: TRMTextAlignment,lineSpace: Float,position: CGPoint) -> CGPoint {
        if labels == nil {return position}
        print("-----begin paint date label-----")
        
        // alignment
        let paragraphStyle = NSMutableParagraphStyle()
        if alignment == TRMTextAlignment.left_top || alignment == TRMTextAlignment.left_bottom{
            paragraphStyle.alignment = .left
        }else{
            paragraphStyle.alignment = .right
        }
        
        var yOffset = position.y
        
        for key in orderByKeys{
            //  get line
            let oneLine = labels?[key]
            if oneLine == nil {continue}
            
            // attributed string
            let attString = oneLine?.attributedNameAndText()
            
            // alignment 
            attString?.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attString!.length))
            
            // rect area for drawing text
            let txtSize = attString?.size()
            
            // draw the string at rectOrigin position 
            var rect = CGRect(x: position.x, y: yOffset, width: txtSize!.width, height: txtSize!.height + 2)
            
            if alignment == TRMTextAlignment.right_top || alignment == TRMTextAlignment.right_bottom{
                rect.origin.x -= txtSize!.width
            }
            
            if alignment == TRMTextAlignment.left_bottom || alignment == TRMTextAlignment.right_bottom{
                rect.origin.y -= txtSize!.height
            }
            
            // draw text inside rect
            let path = CGMutablePath()
            path.addRect(rect)
            
            let framesetter = CTFramesetterCreateWithAttributedString(attString!)
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attString!.length), path, nil)
            ctx.saveGState()
            
            if oneLine!.blurRadius! > Float(0.0) && oneLine!.shadow! == true{
                ctx.setShadow(offset: oneLine!.blurSize!, blur: CGFloat(oneLine!.blurRadius!), color: oneLine!.blurColor!.cgColor)
            
            }
            
            // paint the label
            ctx.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
            CTFrameDraw(frame, ctx)
            ctx.restoreGState()
            
            // done update rect origin
            if alignment == TRMTextAlignment.left_top || alignment == TRMTextAlignment.right_top{
                yOffset += txtSize!.height
            }else{
                yOffset -= txtSize!.height
            }
        }
        return CGPoint(x: position.x, y: yOffset)
    }
    
  
}
