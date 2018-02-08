//
//  CardTagView.swift
//  Demo_testUI
//
//  Created by iMac on 2018/2/8.
//  Copyright © 2018年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class CardTagView: UIView {
    var mainColor = UIColor.magenta
    var decoImage: UIImage! = #imageLiteral(resourceName: "icon3")
    var borderWidth: CGFloat = 4
    var cornerRadius: CGFloat = 8
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubs()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubs()
    }
    
    fileprivate func setupSubs() {
        backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: bounds.insetBy(dx: borderWidth * 0.5, dy: borderWidth * 0.5), byRoundingCorners: [.bottomLeft, .bottomRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        path.lineCapStyle = .round
        path.lineJoinStyle = .round
        
        // white back
        UIColor.white.setFill()
        path.fill()
        
        // linear gradient
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        ctx?.addPath(path.cgPath)
        ctx?.clip()

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient(colorsSpace: colorSpace,  colors:[mainColor.withAlphaComponent(0.2).cgColor, mainColor.withAlphaComponent(0.7).cgColor] as CFArray, locations: [0, 1])
        ctx?.drawLinearGradient(gradient!, start: CGPoint(x: bounds.midX, y: 0), end: CGPoint(x: bounds.midX, y: bounds.height), options: .drawsBeforeStartLocation)

        // decoImage
        if decoImage != nil {
            let whRatio = decoImage.size.width / decoImage.size.height
            decoImage.changeImageSizeTo(CGSize(width: bounds.height * 0.3 * whRatio, height: bounds.height * 0.3)).drawAsPattern(in: bounds)
        }
        
        ctx?.restoreGState()
        
        
        // border
        mainColor.setStroke()
        path.lineWidth = borderWidth
        path.stroke()
    }
}
