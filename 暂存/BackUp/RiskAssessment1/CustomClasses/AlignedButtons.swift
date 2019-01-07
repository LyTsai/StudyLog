//
//  AlignedButtons.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/11.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class AlignedButtons: UIView {
    var buttons = [UIButton]()
    
    // only two buttons
    func addButtonsWithTitles(_ titles: [String], buttonWRatio: CGFloat, gap: CGFloat, edgeInsets: UIEdgeInsets) -> [UIButton] {
        backgroundColor = UIColor.white.withAlphaComponent(0.7)
        
        var buttons = [UIButton]()
        
        let buttonHeight = bounds.height - edgeInsets.top - edgeInsets.bottom
        let totalWidth = bounds.width - edgeInsets.left - edgeInsets.right - gap
        
        // only two
        if titles.count == 2 {
            // left
            let leftFrame = CGRect(x: edgeInsets.left, y: edgeInsets.top, width: totalWidth * buttonWRatio / (1 + buttonWRatio), height: buttonHeight)
            let leftButton = UIButton.customThickRectButton(titles.first!)
            leftButton.adjustThickRectButton(leftFrame)
            
            // right
            let rightFrame = CGRect(x: leftFrame.maxX + gap, y: edgeInsets.top, width: totalWidth - leftFrame.width, height: buttonHeight)
            let rightButton = UIButton.customThickRectButton(titles.last!)
            rightButton.adjustThickRectButton(rightFrame)
            
            addSubview(leftButton)
            addSubview(rightButton)
            
            buttons.append(leftButton)
            buttons.append(rightButton)
        }
        
        self.buttons = buttons
        
        return buttons
    }
}
