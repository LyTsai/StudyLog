//
//  HexView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/10/16.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class HexView: UIView {
    var hexBorder = UIColorFromHex(0xF5A623)
    let button = CustomButton()

    func setupWithFrame(_ frame: CGRect, metric: MetricObjModel) {
        self.frame = frame
        backgroundColor = UIColor.clear
        addSubview(button)
        
        let lineWidth = 2 * bounds.width / 65
        let innerRadius = bounds.height * 0.5 - lineWidth * 2
        let buttonW = sqrt(3) * innerRadius * 0.8
        let buttonY = innerRadius * 0.29
        let buttonH = innerRadius * 1.7 - buttonY
        
        button.frame = CGRect(x: bounds.midX - 0.5 * buttonW, y: bounds.midY - innerRadius + buttonY, width: buttonW, height: buttonH)
        button.fontRatio = 0.35
        button.verticalWithImage(metric.imageUrl, title: metric.name, heightRatio: 0.82)
        setNeedsDisplay()
    }
    
    // hex border
    override func draw(_ rect: CGRect) {
        let lineWidth = 2 * bounds.width / 65
        let radius = bounds.height * 0.5 - lineWidth * 1.5
        
        let path = UIBezierPath()
        let angleGap = CGFloat(Double.pi) * 2 / 6
        var angle = -CGFloat(Double.pi) * 0.5
        for i in 0..<6 {
            let vertex = CGPoint(x: radius * cos(angle) + bounds.midX, y: radius * sin(angle) + bounds.midY)
            i == 0 ? path.move(to: vertex) : path.addLine(to: vertex)
            angle += angleGap
        }
        
        path.close()
        path.lineWidth = lineWidth
        path.lineJoinStyle = .round
        
        hexBorder.setStroke()
        UIColor.white.setFill()
        
        path.fill()
        path.stroke()
    }
}
