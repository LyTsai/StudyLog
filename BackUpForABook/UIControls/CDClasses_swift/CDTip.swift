//
//  CDTip.swift
//  ANBookPad
//
//  Created by dingf on 16/12/12.
//  Copyright © 2016年 MH.dingf. All rights reserved.
//

import UIKit

class CDTip: NSObject {
    var showTip :Bool!
    var tip: String!
    var attrDictionary: NSMutableDictionary!
    // shadow color
    var blurColor: UIColor!
    var blurSize: CGSize!
    var blurRadius: CGFloat!
    
    override init() {
        super.init()
        showTip = true
        tip = "AnnieLyticx Connectivitymatrix"
        attrDictionary = NSMutableDictionary()
        let lbFont = CTFontCreateWithName("Helvetica" as CFString, 8.0, nil)
        attrDictionary[NSFontAttributeName] = lbFont
        attrDictionary[NSForegroundColorAttributeName] = UIColor.init(red: 0.0/255.0, green: 0.0/255.0, blue: 128.0/255.0, alpha: 0.6).cgColor
        attrDictionary[NSStrokeColorAttributeName] = UIColor.darkText.cgColor
        
        blurColor = UIColor.init(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 0.5)
        blurSize = CGSize.init(width: 0.0, height: 3.0)
        blurRadius = 3.0
    }
    

}
