//
//  ANNamedText.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/24.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class ANNamedText: NSObject {
    var name: String?
    var text: String?
    var nameAttrDic: [String: Any]?
    var textAttrDic: [String: Any]?
    var blurRadius: Float?
    var shadow: Bool?
    var blurColor: UIColor?
    var blurSize: CGSize?
    
    init(_ font: String, size: Float, shadow: Bool, underline: Bool, name: String, text: String) {
        super.init()
        nameAttrDic = [String: Any]()
        textAttrDic = [String: Any]()
        
        // set name font
        let lbFont = CTFontCreateWithName(font as CFString?, CGFloat(size), nil)
        nameAttrDic?[NSFontAttributeName] = lbFont
        
        // set text font
        let lbFont1 = CTFontCreateWithName(font as CFString?, CGFloat(size), nil)
        textAttrDic?[NSFontAttributeName] = lbFont1
        
        self.name = name
        self.text = text
        self.shadow = shadow
        
        // name defalut font
        nameAttrDic?[NSForegroundColorAttributeName] = UIColor.darkText.cgColor
        nameAttrDic?[NSStrokeColorAttributeName] = UIColor.gray.cgColor
        nameAttrDic?[NSStrokeWidthAttributeName] = NSNumber.init(value: -3.0)
        if underline == true{
            nameAttrDic?[NSUnderlineStyleAttributeName] = NSNumber.init(value: 2)
        }
        
        // text defalut font
        textAttrDic?[NSForegroundColorAttributeName] = UIColor.darkText.cgColor
        textAttrDic?[NSStrokeColorAttributeName] = UIColor.gray.cgColor
        textAttrDic?[NSStrokeWidthAttributeName] = NSNumber.init(value: -3.0)
        if underline == true{
            textAttrDic?[NSUnderlineStyleAttributeName] = NSNumber.init(value: 2)
        }
        
        blurColor = UIColor.gray
        blurSize = CGSize(width: 0, height: 3.0)
        blurRadius = 3.0
        
    }
    
    // return attributed string of combined name and text
    func attributedNameAndText() -> NSMutableAttributedString{
        // create attributed string for drawing 
        let nameText = name!.appending(text!)
        
        //attribured string with name attributes
        let attString = NSMutableAttributedString.init(string: nameText, attributes:nameAttrDic!)
        
        // apply text attribute 
        attString.addAttributes(textAttrDic!, range: NSMakeRange(name!.characters.count, attString.length - name!.characters.count))
        return attString
    }

}
