//
//  CenteredView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/18.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// model
class DisplayModel {
    var image: UIImage!
    var color = UIColor.lightGray
    
    init(image: UIImage?, color: UIColor) {
        self.image = image
        self.color = color
    }
}

// view
class CenteredView: UIView {
    
    // subviews and data
    fileprivate var centerImageView = UIImageView()
    fileprivate var centerBackView = UIView()
    fileprivate var surroundings = [DisplayModel]()
    
    // create
    func setWithCenterImage(_ center: DisplayModel, surroundings: [DisplayModel]) {
        backgroundColor = UIColor.clear
        // center
        addSubview(centerBackView)
        centerBackView.addSubview(centerImageView)
        centerImageView.image = center.image
        centerBackView.layer.borderColor = center.color.cgColor
        centerBackView.backgroundColor = UIColor.white
        centerBackView.layer.shadowColor = UIColor.black.cgColor
        centerBackView.layer.shadowOffset = CGSize.zero
        centerBackView.layer.shadowRadius = 5
        centerBackView.layer.shadowOpacity = 0.8
        
        // surroundings
        self.surroundings = surroundings
    }
    
    // calculation
    fileprivate func randomBetween(_ a: CGFloat, b: CGFloat) -> CGFloat {
        let random = arc4random() % UInt32(abs(b - a))
        return min(a, b) + CGFloat(random)
    }
    fileprivate var centerRadius: CGFloat {
        return min(bounds.width, bounds.height) * 0.14
    }
    fileprivate var surroundingLength: CGFloat {
        return min(bounds.width, bounds.height) * 0.22
    }
    
    fileprivate var mainCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
//        return CGPoint(x: randomBetween(centerRadius, b: bounds.width - centerRadius), y: randomBetween(centerRadius, b: bounds.height - centerRadius))
    }
    
    fileprivate var centers = [CGPoint]()
    fileprivate func getSurroundingCenters() {
        centers.removeAll()
        let total = surroundings.count
        
        let leftPoint = CGPoint(x: randomBetween(surroundingLength * 0.5, b: mainCenter.x - centerRadius * 1.1 - surroundingLength * 0.5), y: randomBetween(surroundingLength * 0.5, b: bounds.height - surroundingLength * 0.5))
        let rightPoint = CGPoint(x: randomBetween(centerRadius * 1.2 + mainCenter.x + surroundingLength * 0.5, b: bounds.width - surroundingLength * 0.5), y: randomBetween(surroundingLength * 0.5, b: bounds.height - surroundingLength * 0.5))
        
        switch total {
        case 0: break
        case 1:
            centers = arc4random() % 2 == 0 ? [leftPoint] : [rightPoint]
        case 2:
            centers = [leftPoint, rightPoint]
        default:
            let angleGap = CGFloat(M_PI) * 2 / CGFloat(total)
            let startAngle = -angleGap / CGFloat(arc4random() % 3 + 1)// the first place
            let ovalA = bounds.midX - surroundingLength * 0.5
            let ovalB = bounds.midY - surroundingLength * 0.6

            for i in 0..<total {
                let angle = startAngle + CGFloat(i) * angleGap
                let radius = 1.0 / sqrt(cos(angle) * cos(angle) / (ovalA * ovalA) + sin(angle) * sin(angle) / (ovalB * ovalB))
                let position = CGPoint(x: radius * cos(angle) + bounds.midX, y: radius * sin(angle) + bounds.midY)
                centers.append(position)
            }
        }
    }
    
    // draw and layout
    override func layoutSubviews() {
        super.layoutSubviews()

        centerBackView.frame = CGRect(center: mainCenter, length: 2 * centerRadius)
        let inset = centerRadius * (1 - 1 / sqrt(2))
        centerImageView.frame = centerBackView.bounds.insetBy(dx: inset, dy: inset)
        centerBackView.layer.cornerRadius = centerRadius
        centerBackView.layer.borderWidth = centerRadius * 0.1
        
        getSurroundingCenters()
        setNeedsDisplay()
    }
    
    
    // draw
    override func draw(_ rect: CGRect) {
    
        for (i, position) in centers.enumerated() {
            let surrounding = surroundings[i]
            let sFrame = CGRect(center: position, length: surroundingLength)
            
            // line
            let path = UIBezierPath()
            path.lineWidth = 1.5
            path.move(to: mainCenter)
            path.addLine(to: position)
            surrounding.color.setStroke()
            path.stroke()
            
            // border
            let hexPath = getHexPath(position, radius: surroundingLength * 0.5)
            hexPath.lineWidth = 3
            hexPath.stroke()
            UIColor.white.setFill()
            hexPath.fill()
            
            // image
            let inset = surroundingLength * (1 - sqrt(6) / 4 ) * 0.5
            surrounding.image.draw(in: sFrame.insetBy(dx: inset, dy: inset))
        }
    }
    
    fileprivate func getHexPath(_ center: CGPoint, radius: CGFloat) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: center.x, y: center.y - radius))
        path.addLine(to: CGPoint(x: center.x + radius * sqrt(3) * 0.5, y: center.y - radius * 0.5))
        path.addLine(to: CGPoint(x: center.x + radius * sqrt(3) * 0.5, y: center.y + radius * 0.5))
        path.addLine(to: CGPoint(x: center.x, y: center.y + radius))
        path.addLine(to: CGPoint(x: center.x - radius * sqrt(3) * 0.5, y: center.y + radius * 0.5))
        path.addLine(to: CGPoint(x: center.x - radius * sqrt(3) * 0.5, y: center.y - radius * 0.5))
        path.close()
        
        return path
    }
    
}
