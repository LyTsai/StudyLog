//
//  CartSegmentView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/14.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// custom segment view
class CartSegmentView: UIView {
    fileprivate let label = UILabel()
    fileprivate let line = UIView()
    func setWithFrame(_ frame: CGRect, title: String, selected: Bool) {
        self.frame = frame
        
        label.frame = bounds
        label.text = title
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: bounds.height * 0.4, weight: UIFontWeightSemibold)
        
        addSubview(label)
        addSubview(line)
        
        setUIWithState(selected)
    }
    
    func setUIWithState(_ selected: Bool) {
        label.backgroundColor = selected ? UIColor.clear : UIColorFromRGB(240, green: 241, blue: 243)
        label.textColor = selected ? tabTintGreen : UIColorGray(155)
        
        let lineHeight: CGFloat = selected ? 3 : 1
        line.frame = CGRect(x: 0, y: bounds.height - lineHeight, width: bounds.width, height: lineHeight)
        line.backgroundColor = selected ? tabTintGreen : UIColorGray(216)
    }
}
