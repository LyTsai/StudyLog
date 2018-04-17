//
//  CardsDistributionNode.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/8.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class CardsDistributionNode: UIView {
    // for !riskClass, no useful data, but not nil
    var connectedNode = VisualMapNode()
    
    var cardKeys = [String]() {
        didSet{
            var sorted = [UIColor: Int]()
            for key in cardKeys {
                if let card = collection.getCard(key) {
                    if let iden = card.currentIdentification() {
                        let color = MatchedCardsDisplayModel.getColorOfIden(iden)
                        if sorted[color] == nil {
                            sorted[color] = 1
                        }else {
                            sorted[color] = sorted[color]! + 1
                        }
                    }
                }
            }
            
            // TODO: ------- remove later
            if cardKeys.count != 0 {
                distribution = sorted
            }
        }
    }
    
    var distribution = [UIColor.red: 2, UIColor.yellow: 3, UIColor.green: 5] {
        didSet{
            if distribution != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override var frame: CGRect {
        didSet{
            if frame != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    var innerRadius: CGFloat = 0 {
        didSet{
            if innerRadius != oldValue {
                setNeedsDisplay()
            }
        }
    }
    
    // draw
    override func draw(_ rect: CGRect) {
        // adjust frame
        let radius = min(rect.midY, rect.midX) - fontFactor * 0.5
        let cardCenter = CGPoint(x: rect.midX, y: rect.midY)
        let rectForDraw = CGRect(center: cardCenter, length: radius * 2)
        
        // rim
        let oct = UIBezierPath()
        oct.move(to: CGPoint(x: rectForDraw.maxX, y: rectForDraw.midY))
        for i in 1...7 {
            let angle = CGFloat(i) * CGFloat(Double.pi / 4)
            oct.addLine(to: Calculation().getPositionByAngle(angle, radius: radius, origin: cardCenter))
        }
        
        oct.close()
        oct.lineWidth = fontFactor
        UIColorFromRGB(163, green: 177, blue: 255).setStroke()
        oct.stroke()
        
        // dots
        if innerRadius >= radius {
            innerRadius = 0
        }
        let dotRadius = (radius - innerRadius) * 0.06
        let maxConfine = radius * cos(CGFloat(Double.pi) / 8) - dotRadius
        let minConfine = dotRadius + innerRadius
        for (color, number) in distribution {
            color.setFill()
            for _ in 0..<number {
                // r and theta
                let randomAngle: CGFloat = 2 * CGFloat(arc4random() % 180) / 180 * CGFloat(Double.pi)
                let randomRadius: CGFloat = (maxConfine - minConfine) * sqrt(CGFloat(arc4random() % 50) / 50) + minConfine
                
                let dotCenter = CGPoint(x: randomRadius * cos(randomAngle) + cardCenter.x, y: randomRadius * sin(randomAngle) + cardCenter.y)
                let path = UIBezierPath(arcCenter: dotCenter, radius: dotRadius, startAngle: 0, endAngle: CGFloat(Double.pi * 2), clockwise: true)
                
                path.fill()
            }
        }
    }
}
