//
//  RoundedRectanglePageControl.swift
//  BrainSHIELD
//
//  Created by L on 2020/11/4.
//  Copyright © 2020 MingHui. All rights reserved.
//

import Foundation
import UIKit

class RoundedRectanglePageControl: UIView {
    var pageIsTouched: ((Int) -> Void)?
    var pageHRatio: CGFloat = 0.35
    var sizeRatio: CGFloat = 4.5
    
    fileprivate var number: Int = 0
    fileprivate var current: Int = 0
   
    func setWithNumber(_ number: Int, current: Int) {
        self.backgroundColor = UIColor.clear
        self.number = number
        
        focusOnPage(current)
        
        setNeedsDisplay()
    }
    
    func focusOnPage(_ index: Int) {
        current = index
        setNeedsDisplay()
    }
    
    // draw
    fileprivate var dotFrames = [CGRect]()
    override func draw(_ rect: CGRect) {
        dotFrames.removeAll()
        // more than 0
        guard number > 0 else {
            return
        }
        
        let floatN = CGFloat(number)
        // the height of page control
        var dotH = bounds.height * pageHRatio
        // total space needed
        var totalW = dotH * ((1 + sizeRatio) * floatN - 1)
        if totalW > bounds.width {
            // width is not enough
            dotH = bounds.width / ((1 + sizeRatio) * floatN - 1)
            totalW = bounds.width
        }
        
        for i in 0..<number {
            let dotFrame = CGRect(x: 0.5 * (bounds.width - totalW) + CGFloat(i) * (1 + sizeRatio) * dotH, y: bounds.midY - dotH * 0.5, width: dotH * sizeRatio, height: dotH)
           
            // path
            let dotPath = UIBezierPath(roundedRect: dotFrame, cornerRadius: dotH * 0.5)
            dotPath.lineWidth = dotH / 20
            
            UIColorGray(133).setStroke()
            let fillColor = (i == current) ? UIColorFromHex(0x00C853) : UIColorFromHex(0xF0F1F3)
            fillColor.setFill()
            
            dotPath.fill()
            dotPath.stroke()
            
            // data
            dotFrames.append(dotFrame)
        }
    }
    
    // action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let location = touches.first?.location(in: self) {
            for (i, dotFrame) in dotFrames.enumerated() {
                if dotFrame.contains(location) {
                    pageIsTouched?(i)
                    break
                }
            }
        }
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
    }
}
