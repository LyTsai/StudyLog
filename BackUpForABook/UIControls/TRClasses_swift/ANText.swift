//
//  ANText.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class ANText: NSObject {
    var show: Bool?
    var textAttributeDic: [String: Any]?
    var text: String?
    var shadow: Bool?
    var blurColor: UIColor?
    var blurSize: CGSize?
    var blurRadius: Float?
    
    var attributedText: NSMutableAttributedString{
        get{
            let attString = NSMutableAttributedString.init(string: text!, attributes: textAttributeDic)
            return attString
        }
    }
    init(_ font: String, size: Float, shadow: Bool, underline: Bool) {
        super.init()
        show = true
        textAttributeDic = [String : Any]()
        setTextFont(font, size: size)
        text = ""
        self.shadow = shadow
        setDefaultFont0(underline)
    }
    
    func setTextFont(_ font: String, size: Float){
        let lbFont = CTFontCreateWithName(font as CFString, CGFloat(size), nil)
        textAttributeDic?[NSFontAttributeName] = lbFont
    }
    
    func setDefaultFont0(_ underline: Bool){
        textAttributeDic?[NSForegroundColorAttributeName] = UIColor.darkText
        textAttributeDic?[NSStrokeColorAttributeName] = UIColor.gray
        textAttributeDic?[NSStrokeWidthAttributeName] = NSNumber(value: -3)
        if underline == true{
            textAttributeDic?[NSUnderlineStyleAttributeName] = NSNumber(value: 2)
        }
        blurColor = UIColor.gray
        blurSize = CGSize(width: 0.0, height: 3.0)
        blurRadius = 3.0
    }
    
    func paint(_ ctx: CGContext, rect: CGRect){
        if show == false || text == nil{
            return
        }else if text!.characters.count <= 0{
            return
        }
        
        // draw text inside rect
        let path = CGMutablePath()
        path.addRect(rect)
        
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attributedText.length), path, nil)
        ctx.saveGState()
        
        if blurRadius! > 0.0 && shadow == true{
            ctx.setShadow(offset: blurSize!, blur: CGFloat(blurRadius!), color: blurColor!.cgColor)
        }
        
        // paint the label
        ctx.textMatrix = CGAffineTransform(scaleX: 1.0, y: -1.0)
        CTFrameDraw(frame, ctx)
        ctx.restoreGState()
    }

}
