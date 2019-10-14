//
//  ScorecardResultBar.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/7.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardResultBar: UIView {
    var started = true
    
    var drawInfo = [(color: UIColor, number: Int)]()
    var totalNumber: Int = 0
 
    var drawScore = false
    var score: Float = 0
    var maxScore: Float = 0
    var scoreClassificationName = UnClassifiedIden
    var scoreBackColor = tabTintGreen
    
    override func draw(_ rect: CGRect) {
        let lineWidth = bounds.height / 44
        let bottomColor = UIColorGray(218)
        if drawScore {
            let mainRect = bounds.insetBy(dx: bounds.width * 0.05, dy: bounds.height * 0.05)
            let path = UIBezierPath(roundedRect: mainRect, cornerRadius: mainRect.height * 0.5)
            path.lineWidth = lineWidth
            
            if started {
                UIColor.black.setStroke()
                scoreBackColor.setFill()
            }else {
                UIColorGray(158).setStroke()
                bottomColor.setFill()
            }

            path.fill()
            path.stroke()
            
            let para = NSMutableParagraphStyle()
            para.alignment = .center
            drawString(NSAttributedString(string: started ? "\(score) out of \(maxScore), \(scoreClassificationName)" : "Not played", attributes: [.font: UIFont.systemFont(ofSize: mainRect.height * 0.34, weight: .semibold), .foregroundColor: UIColor.black, .paragraphStyle: para]), inRect: mainRect)
        }else {
            let top = bounds.height * 0.36 // half line gap
            let barRect = bounds.insetBy(dx: lineWidth * 0.5, dy: top + lineWidth)
            let barPath = UIBezierPath(roundedRect: barRect, cornerRadius: barRect.height * 0.5)
            barPath.lineWidth = lineWidth
            UIColorGray(158).setStroke()
            bottomColor.setFill()
            
            barPath.fill()
            barPath.stroke()
            
            let font = UIFont.systemFont(ofSize: top * 0.75, weight: .regular)
            
            if !started {
                drawString(NSAttributedString(string: "0%", attributes: [ .font: font,  .foregroundColor: UIColor.black]), inRect: CGRect(x: 0, y: bounds.height - top, width: bounds.width, height: top))
            }else {
                UIColor.black.setStroke()
                
                // startX of bar, text on top and bottom
                var barX = barRect.minX
                var topX: CGFloat = 0
                var bottomX: CGFloat = 0
                var addUp = 0
                for(offset: i, element: (color: color, number: number)) in drawInfo.enumerated() {
                    let ratio = CGFloat(number) / CGFloat(totalNumber)
                    let barLength = barRect.width * ratio

                    var roundingCorners: UIRectCorner = []
                    if drawInfo.count == 1 {
                        roundingCorners = [.allCorners]
                    }else if i == 0 {
                        roundingCorners = [.topLeft, .bottomLeft]
                    }else if i == drawInfo.count - 1 {
                        roundingCorners = [.bottomRight, .topRight]
                    }
                    
                    let barPath = UIBezierPath(roundedRect: CGRect(x: barX, y: barRect.minY, width: barLength, height: barRect.height), byRoundingCorners: roundingCorners, cornerRadii: CGSize(width: barRect.height * 0.5, height: barRect.height * 0.5))
    
                    color.setFill()
                    barPath.fill()
                    barPath.stroke()
                    
                    // text
                    let textX = i % 2 == 0 ? topX : bottomX
                    let textY = i % 2 == 0 ? 0 : bounds.height - top
                    
                    var number = Int(nearbyint(ratio * 100))
                    if i != drawInfo.count - 1 {
                        addUp += number
                    }else {
                        if addUp + number > 100 {
                            number = 100 - addUp
                        }
                    }
                    
                    drawString(NSAttributedString(string: "\(number)%", attributes: [ .font: font,  .foregroundColor: UIColor.black]), inRect: CGRect(x: textX, y: textY, width: barX + barLength - textX, height: top), alignment: .right)
                    
                    // prepare for next
                    barX += barLength
                    if i % 2 == 0 {
                        topX += barLength
                    }else {
                        bottomX += barLength
                    }
                }
            }
        }
    }
}
