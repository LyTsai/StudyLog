//
//  TagLabel.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/27.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class TagLabel: UILabel {
//    var longText = false
    class func createTag() -> TagLabel {
        let tag = TagLabel()
        tag.textAlignment = .center
        tag.numberOfLines = 0
        tag.textColor = UIColor.white
        tag.layer.masksToBounds = true
        
        return tag
    }
    
    func setToCheckTag() {
        backgroundColor = UIColorFromHex(0x2AB062)
        layer.borderColor = UIColorFromHex(0xAEFFD0).cgColor
        text = "✓"
//        longText = false
    }
    
    func setToLatestTag(_ append: String?) {
        backgroundColor = UIColorFromHex(0x0072BA)
        layer.borderColor = UIColorFromHex(0xB1E1FF).cgColor
        
        var suffix = "Latest"
        if append != nil {
            suffix.append(" \(append!)")
        }
        
        self.text = suffix
//        longText = true
    }
    
    func setToNone() {
        backgroundColor = UIColor.clear
        layer.borderColor = UIColor.clear.cgColor
        text = ""
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.height / 30
        font = UIFont.systemFont(ofSize: one * 12, weight: .bold)
        layer.borderWidth = 3 * one
        layer.cornerRadius = 3.2 * one
    }
}
