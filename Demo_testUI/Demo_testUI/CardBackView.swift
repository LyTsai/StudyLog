//
//  CardBackView.swift
//  Demo_testUI
//
//  Created by iMac on 2018/2/7.
//  Copyright © 2018年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class CardBackView: UIView {
    // state
    var isChosen = false {
        didSet{
            backgroundColor = chosenColor
        }
    }
    
    // decos
    var chosenColor = UIColor.blue
    var mainColor = UIColor.magenta
//    var decoImage: UIImage!
    
    // frames
//    var top: CGFloat = 6
//    var margin: CGFloat = 10
//    var titleSize = CGSize(width: 192, height: 56)
    
    
    var rimFrame = CGRect(x: 20, y: 40, width: 300, height: 500) // center of rim
    
//    var borderCornerRadius: CGFloat = 8
    var innerCornerRadius: CGFloat = 4
    var rimLineWidth: CGFloat = 4
//    var titleLineWidth: CGFloat = 2

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubs()
    }
    

    fileprivate func setupSubs() {
        backgroundColor = UIColor.white
    }
    
    
    override func draw(_ rect: CGRect) {
        // left-top
        let path = UIBezierPath(arcCenter: rimFrame.origin, radius: innerCornerRadius, startAngle: CGFloat(Double.pi) * 0.5, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: rimFrame.maxX - innerCornerRadius, y: rimFrame.minY))
        // right-top
        path.addArc(withCenter: CGPoint(x: rimFrame.maxX, y: rimFrame.minY), radius: innerCornerRadius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi) * 0.5, clockwise: false)
        path.addLine(to: CGPoint(x: rimFrame.maxX, y: rimFrame.maxY - innerCornerRadius))
        // right-bottom
        path.addArc(withCenter: CGPoint(x: rimFrame.maxX, y: rimFrame.maxY), radius: innerCornerRadius, startAngle: CGFloat(Double.pi) * 1.5, endAngle: CGFloat(Double.pi), clockwise: false)
        path.addLine(to: CGPoint(x: rimFrame.minX + innerCornerRadius, y: rimFrame.maxY))
        // left-bottom
        path.addArc(withCenter: CGPoint(x: rimFrame.minX, y: rimFrame.maxY), radius: innerCornerRadius, startAngle: 0, endAngle: CGFloat(Double.pi) * 1.5, clockwise: false)
        path.close()
        
        // radial gradient
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        ctx?.addPath(path.cgPath)
        ctx?.clip()
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace, colors: [UIColor.white.cgColor, mainColor.cgColor] as CFArray, locations: [0, 1])
        
        let radialCenter = CGPoint(x: rimFrame.midX, y: rimFrame.minY + rimFrame.height * 0.2)
        let startRadius = max(rimFrame.height * 0.5, rimFrame.width * 0.5)
        ctx?.drawRadialGradient(gradient!, startCenter: radialCenter, startRadius:  startRadius, endCenter: radialCenter, endRadius: rimFrame.height * 1.5, options: .drawsBeforeStartLocation)
        
        ctx?.restoreGState()
        
        // rim line
        mainColor.setStroke()
        path.lineWidth = rimLineWidth
        path.stroke()
    }
}
