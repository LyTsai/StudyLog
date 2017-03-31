//
//  PieView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/8.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class PieView: UIView {
    // for slices
    var buttonsOnView: [UIButton] {
        return buttons
    }
    fileprivate var buttons = [UIButton]()
    
    fileprivate var sectorLayer = CAShapeLayer()
    var selectedIndex: Int = 0 {
        didSet{
            if selectedIndex < 0 || selectedIndex >= numberOfSlices {
                return
            }
            
            if selectedIndex != oldValue {
                let current = buttons[selectedIndex]
                let old = buttons[oldValue]
                
                UIView.animate(withDuration: 0.6, animations: {
                    current.transform = current.transform.translatedBy(x: 0, y: -self.translate)
                    current.transform = current.transform.scaledBy(x: 1 / 0.8, y: 1 / 0.8)

                    old.transform = old.transform.scaledBy(x: 0.8, y: 0.8)
                    old.transform = old.transform.translatedBy(x: 0, y: self.translate)
                    
                    self.drawSectors()
                })
            }
        }
    }
    
    fileprivate var numberOfSlices: Int = 0
    fileprivate var innerRadius: CGFloat = 0
    fileprivate var enlargeAngle: CGFloat = 0
    
    fileprivate var sectorRadius: CGFloat = 0
    fileprivate var angleGap: CGFloat {
        return CGFloat(2 * M_PI) / CGFloat(numberOfSlices)
    }
    
    fileprivate var viewCenter: CGPoint {
        return  CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // for adjust frame of buttons
    fileprivate var middleAngles = [CGFloat]()
    fileprivate var translate: CGFloat = 0
    
    func setupWithFrame(_ frame: CGRect, innerRadius: CGFloat, numberOfSlices: Int, enlargeAngle: CGFloat)  {
        // assign for draw
        self.numberOfSlices = numberOfSlices
        self.innerRadius = innerRadius
        self.enlargeAngle = enlargeAngle
        
        // basic UI
        self.frame = frame
        let size = bounds.size
        backgroundColor = UIColor.white
        
        // angle and position
        let radius = min(size.width, size.height) / 2
        sectorRadius = radius - 3.4 * innerRadius
        if sectorRadius <= 0 {
            print("please reset radius")
        }
        
        // sector
        sectorLayer.frame = bounds
        sectorLayer.lineWidth = 1
        sectorLayer.strokeColor = UIColor.lightGray.cgColor
        sectorLayer.fillColor = UIColor.white.cgColor
        drawSectors()
        sectorLayer.addBlackShadow(2)
        
        layer.addSublayer(sectorLayer)
        
        // buttons
        for i in 0..<numberOfSlices {
            let startAngle = enlargeAngle + (CGFloat(i) - 0.5) * angleGap
            let middleAngle = startAngle + angleGap * 0.5
            middleAngles.append(middleAngle)
            
            let button = UIButton(type: .custom)
            
            let vertex = Calculation().getPositionByAngle(middleAngle, radius: innerRadius, origin: viewCenter)
            button.frame = Calculation().inscribeSqureRect(angleGap, startAngle: startAngle, radius: sectorRadius, vertex: vertex)
            translate = 2.15 * innerRadius - button.frame.width * 0.1
            
            let rotation = CGAffineTransform(rotationAngle: CGFloat(M_PI)/2 + middleAngle)
            let scale = (i == 0 ? rotation : rotation.scaledBy(x: 0.8, y: 0.8))
            let transform = (i == 0 ? scale.translatedBy(x: 0, y: -translate) : scale)
            
            button.transform = transform
            
            buttons.append(button)
            addSubview(button)
        }
    }
  
    fileprivate func drawSectors() {
        let sectorPath = UIBezierPath()
        
        for i in 0..<numberOfSlices {
            let startAngle = enlargeAngle + (CGFloat(i) - 0.5) * angleGap
            let endAngle = startAngle + angleGap
            
            let vertex = Calculation().getPositionByAngle(startAngle + angleGap * 0.5, radius: innerRadius, origin: viewCenter)
            let path = UIBezierPath(arcCenter: vertex, radius: (i == selectedIndex ? (sectorRadius + innerRadius * 2.15): sectorRadius), startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addLine(to: vertex)
            path.close()
            
            sectorPath.append(path)
        }
        
        sectorLayer.path = sectorPath.cgPath
    }
    
    // rotation
    fileprivate var rAngle: CGFloat = 0
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        
        let lastPoint = touches.first!.previousLocation(in: self)
        let angle = Calculation().angleOfPoint(currentPoint, center: viewCenter) - Calculation().angleOfPoint(lastPoint, center: viewCenter)
        transform = transform.rotated(by: angle)
        rAngle += angle
        
        var index = 0
        let total = rAngle / angleGap
        index = (total > 0 ? Int(total + 0.5) : Int(total - 0.5)) % numberOfSlices
        index = (index > 0 ? (numberOfSlices - index) : -index)
        
        selectedIndex = index
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        adjustAngle()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        adjustAngle()
    }
    
    // scroll to center
    fileprivate func adjustAngle() {
        var adjust: CGFloat = 0
        
        let turn = rAngle.truncatingRemainder(dividingBy: angleGap)
        if abs(turn) <= angleGap * 0.5 {
            // still this slice selected
            adjust = -turn
        }else {
            // next one is selected
            if turn > 0 {
                adjust = angleGap - turn
            }else {
                adjust = -angleGap - turn
            }
        }

        transform = transform.rotated(by: adjust)
        rAngle += adjust
    }
}
