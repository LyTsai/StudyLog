//
//  DashBorderView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/15.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class DashBorderView: UIView {
    var borderColor = UIColorFromHex(0x7CC953)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasicViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBasicViews()
    }
    
    func addBasicViews() {
        backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        let one = bounds.width / 335
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: one, dy: one), cornerRadius: 8 * one)
        path.lineWidth = one * 2
        path.setLineDash([5 * one, one], count: 1, phase: 1)
        UIColor.white.setFill()
        path.fill()
        borderColor.setStroke()
        path.stroke()
    }
    
}
