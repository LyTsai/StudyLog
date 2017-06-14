//
//  ANBezierText.swift
//  ANBookPad
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit
enum CurveTextAlignment: Int{
    case left = 1
    case center
    case right
}
enum BezierType: Int{
    case quad = 1
    case cubic
}
class ANBezierText : NSObject {
    var alignment: CurveTextAlignment!
    var type: BezierType!
    // test data
    var textString: NSAttributedString!
    override init() {
        super.init()
        type = BezierType.quad
        alignment = CurveTextAlignment.center
        createTestAttributedString()
    }
    func createTestAttributedString(){
        // test string
        let string:CFString = "a liberal education is an education to free the mind from ligatures, bold, color, and big text." as CFString
        
        // create the mutable attributed string
        let attrString = CFAttributedStringCreateMutable(nil, 0)
        CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), string)
        
        // set the base font
        let baseFont = CTFontCreateUIFontForLanguage(CTFontUIFontType.user, 10.0, nil)
        let length = CFStringGetLength(string)
        CFAttributedStringSetAttribute(attrString, CFRangeMake(0, length), kCTFontAttributeName, baseFont)
        
        // apply bold by finding the bold version of the current font
        let boldFont = CTFontCreateCopyWithSymbolicTraits(baseFont!, 0, nil, CTFontSymbolicTraits.boldTrait, CTFontSymbolicTraits.boldTrait)
        CFAttributedStringSetAttribute(attrString, CFStringFind(string, "bold" as CFString, CFStringCompareFlags.init(rawValue: 0)), kCTFontAttributeName, boldFont)
        
        // apply color
        let color = UIColor.red
        CFAttributedStringSetAttribute(attrString, CFStringFind(string, "color" as CFString, CFStringCompareFlags.init(rawValue: 0)), kCTForegroundColorAttributeName, color)
        
        // apply big text
        let bigFont = CTFontCreateUIFontForLanguage(CTFontUIFontType.user, 36.0, nil)
        CFAttributedStringSetAttribute(attrString, CFStringFind(string, "big text" as CFString, CFStringCompareFlags.init(rawValue: 0)), kCTFontAttributeName, bigFont)
        
        textString = attrString
    }
}
