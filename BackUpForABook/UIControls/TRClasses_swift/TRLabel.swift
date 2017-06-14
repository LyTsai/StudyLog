//
//  TRLabel.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRLabel: NSObject {
    var fontSizeLarge: Float?
    var fontSizeSmall: Float?
    var fontSize_Remainder: Float?
    var maxNumberOfFullSizeLetters: Int?
    var attrDictionary: [String : Any]?
    var attrRemainderDictionary: [String : Any]?
    var underLine: Bool?
    var blurColor: UIColor?
    var blurSize: CGSize?
    var blurRadius: Float?
    var shortString: String?
    var fullString: String?
    
    override init() {
        super.init()
        attrDictionary = [String: Any]()
        attrRemainderDictionary = [String: Any]()
        fontSizeLarge = 10.0
        fontSizeSmall = 8.0
        fontSize_Remainder = 8.0
        maxNumberOfFullSizeLetters = 28
        setDefaultLabelStyle6()
    }
    
    
    func updateAttributedString(){
        setDefaultLabelStyle6()
    }
    
    func setDefaultLabelStyle6(){
        let lbFont = CTFontCreateWithName("Helvetica-Bold" as CFString, CGFloat(fontSizeLarge!), nil)
        attrDictionary?[NSFontAttributeName] = lbFont
        underLine = true
        attrDictionary?[NSForegroundColorAttributeName] = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.9)
        attrDictionary?[NSStrokeColorAttributeName] = UIColor.darkGray
        
        let lbFont1 = CTFontCreateWithName("Helvetica" as CFString, CGFloat(fontSizeSmall!), nil)
        attrRemainderDictionary?[NSFontAttributeName] = lbFont1
        attrRemainderDictionary?[NSForegroundColorAttributeName] = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.9)
        attrRemainderDictionary?[NSStrokeColorAttributeName] = UIColor.darkGray
        
        blurColor = UIColor.lightGray
        blurSize = CGSize(width: 0.0, height: 1.0)
        blurRadius = 2.0
    }
}
