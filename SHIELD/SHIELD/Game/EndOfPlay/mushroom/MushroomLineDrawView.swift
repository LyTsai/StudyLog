//
//  MushroomLineDrawView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/10/17.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class MushroomLineDrawView: UIView {
    var pathInfo = [(UIBezierPath, UIColor)]() {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        for info in pathInfo {
            info.1.setStroke()
            info.0.stroke()
        }
    }
}
