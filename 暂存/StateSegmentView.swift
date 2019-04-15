//
//  StateSegmentView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/29.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class StateSegmentView: UIView {
    fileprivate var chosenIndex = -1 {
        didSet{
            let width = bottomBar.frame.width
            bottomBar.center = CGPoint(x: width * (0.5 + CGFloat(chosenIndex)), y: bottomBar.center.y)
            
            // change the view
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bottomBar.backgroundColor = UIColorFromRGB(255, green: 85, blue: 0)
        addSubview(bottomBar)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    fileprivate let bottomBar = UIView()
    fileprivate var buttons = [UIButton]()
    func setupWithTitles(_ titles: [String], chosen: Int, barColor: UIColor) {
        if chosen > titles.count - 1 || chosen < 0 {
            return
        }
        
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons.removeAll()
        
        let count = CGFloat(titles.count)
        let length = bounds.width / count
        bottomBar.frame = CGRect(x: 0, y: bounds.height - 3 * fontFactor, width: length * 0.96, height: 3 * fontFactor)
        bottomBar.backgroundColor = barColor
        
        // buttons
        for (i, title) in titles.enumerated() {
            let button = UIButton(frame: CGRect(x: CGFloat(i) * length, y: 0, width: length * 0.9 ,height: bounds.height - 3 * fontFactor))
            button.tag = 100 + i

            button.setImage(#imageLiteral(resourceName: "mapUnselected"), for: .normal)
            button.setImage(#imageLiteral(resourceName: "mapSelected"), for: .selected)
            button.setTitle(title, for: .normal)
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.font = UIFont.systemFont(ofSize: 10 * fontFactor, weight: UIFontWeightSemibold)
            button.setTitleColor(UIColor.black, for: .selected)
            button.setTitleColor(UIColorGray(200), for: .normal)
            button.contentHorizontalAlignment = .left
            
            button.addTarget(self, action: #selector(chooseSegment(_:)), for: .touchUpInside)
            
            buttons.append(button)
            addSubview(button)
        }
        
        chooseSegment(buttons[chosen])
    }
    
    func chooseSegment(_ button: UIButton)  {
        if (button.tag - 100) == chosenIndex {
            print("current is chosen")
            return
        }
        
        // change
        button.isSelected = true
        if chosenIndex != -1 {
            buttons[chosenIndex].isSelected = false
        }
        
        chosenIndex = button.tag - 100
    }
    
}
