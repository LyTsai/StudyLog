//
//  StrokeTextLabel.swift
//  Demo_testUI
//
//  Created by iMac on 2019/4/8.
//  Copyright © 2019年 LyTsai. All rights reserved.
//

import Foundation

class StrokeTextLabel: UILabel {
    var strokeColor = UIColor.black
    var strokeWidth: Float = 15
    
    func setupWithFont(_ font: UIFont, textAlignment: NSTextAlignment) {
        
    }
    
    override func draw(_ rect: CGRect) {
        if let labelText = text {
            let attributed = NSAttributedString(string: labelText, attributes: [.font : font, .strokeColor: strokeColor, .strokeWidth: NSNumber(value: strokeWidth)])
            drawString(attributed, inRect: bounds, alignment: textAlignment)
        }
    }
}
