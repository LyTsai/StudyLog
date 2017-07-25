//
//  StackPageControl.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/18.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation


class StackPageControl: UIView {
    var currentIndex = 0 {
        didSet{
            if currentIndex != oldValue {
                pageControlTable.currentIndex = currentIndex
                textLabel.text = "\(currentIndex + 1) of \(totalNumber)"
            }
        }
    }
    
    fileprivate var pageControlTable: PageControlTableView!
    fileprivate let textLabel = UILabel()
    
    fileprivate var totalNumber = 0
    // create
    class func createWithFrame(_ frame: CGRect, totalNumber: Int) -> StackPageControl {
        let stackView = StackPageControl(frame: frame)
        stackView.backgroundColor = UIColor.clear
        stackView.totalNumber = totalNumber
        stackView.updateUI()
        
        return stackView
    }
    
    fileprivate let leftArrow = UIImageView(image: UIImage(named: "left_arrow"))
    fileprivate let rightArrow = UIImageView(image: UIImage(named: "right_arrow"))
    
    fileprivate func updateUI() {
        textLabel.textColor = UIColor.white
        textLabel.textAlignment = .center
        addSubview(textLabel)
        
        // no card
        if totalNumber <= 0 {
            textLabel.text = "no cards"
            textLabel.frame = bounds
            return
        }
        
        // with cards
        let pageHeight = bounds.height * 0.4
        let gap = pageHeight * 0.05
        let labelHeight = bounds.height - pageHeight - gap
        
        let arrowWidth = pageHeight * 6 / 9
        var pageWidth = bounds.width - 2 * (arrowWidth + gap)
        var maxOnShow = min(Int(pageWidth / (pageHeight * 1.3)), 9)
        if maxOnShow > totalNumber && maxOnShow % 2 == 0{
            maxOnShow -= 1
        }
        
        if maxOnShow <= 0 {
            print("the frame is not right")
        }
        
        // enough place
        let tableCenter = CGPoint(x: bounds.midX, y: pageHeight * 0.5)
        pageWidth = CGFloat(min(maxOnShow, totalNumber)) * pageHeight * 1.3
        
        let tableFrame = CGRect(x: tableCenter.x - pageHeight * 0.5, y: tableCenter.y - pageWidth * 0.5, width: pageHeight, height: pageWidth)
    
        pageControlTable = PageControlTableView.createWithFrame(tableFrame, totalNumber: totalNumber)
        pageControlTable.transform = CGAffineTransform(rotationAngle: -CGFloat(M_PI_2))
        addSubview(pageControlTable)
        
        textLabel.frame = CGRect(x: 0, y: pageHeight + gap, width: bounds.width, height: labelHeight)
        textLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.75)
        textLabel.text = "1 of \(totalNumber)"
        
        // with more to show
        if maxOnShow < totalNumber {
            let startX = bounds.midX - gap - arrowWidth - 0.5 * pageWidth
            leftArrow.frame = CGRect(x: startX, y: 0, width: arrowWidth, height: pageHeight)
            rightArrow.frame = CGRect(x: bounds.midX + gap + 0.5 * pageWidth, y: 0, width: arrowWidth, height: pageHeight)
            
            leftArrow.contentMode = .scaleAspectFit
            rightArrow.contentMode = .scaleAspectFit
            
            addSubview(leftArrow)
            addSubview(rightArrow)
        }
    }
}
