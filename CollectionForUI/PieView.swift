//
//  PieView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/8.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

@objc protocol PieViewDelegate {
    @objc optional func pieView(_ pie: PieView, didSelect index: Int)
//    @objc optional func pieView(_ pie: PieView, didScroll angle:)
}

class PieView: UIView {
    // delegate
    weak var hostLandingPage: LandingPageTireView!
    
    // when set, transform and redraw layer path only
    var selectedIndex: Int = 0 {
        didSet{
            if selectedIndex < 0 || selectedIndex >= numberOfSlices {
                return
            }
            
            if selectedIndex != oldValue {
                let current = buttons[selectedIndex]
                let old = buttons[oldValue]
                
                // old go back, then draw, then current enlarge
                UIView.animate(withDuration: 0.3, animations: { 
                    old.transform = old.transform.scaledBy(x: 0.8, y: 0.8)
                    old.transform = old.transform.translatedBy(x: 0, y: self.translate)
                }, completion: { (ture) in
                    UIView.animate(withDuration: 0.3, animations: {
                        self.drawSectors()
                        current.transform = current.transform.translatedBy(x: 0, y: -self.translate)
                        current.transform = current.transform.scaledBy(x: 1 / 0.8, y: 1 / 0.8)
                    })
                })
                
//                UIView.animate(withDuration: 0.6, animations: {
//                    old.transform = old.transform.scaledBy(x: 0.8, y: 0.8)
//                    old.transform = old.transform.translatedBy(x: 0, y: self.translate)
//                    
//                    current.transform = current.transform.translatedBy(x: 0, y: -self.translate)
//                    current.transform = current.transform.scaledBy(x: 1 / 0.8, y: 1 / 0.8)
//                    
//                    self.drawSectors()
//                })
//                
                // TODO: -------- using protocal or closure for it
                if hostLandingPage != nil {
                    hostLandingPage.title = current.itemTitle
                    RiskMetricCardsCursor.sharedCursor.selectedRiskClassKey = hostLandingPage.tireThree[selectedIndex].key
                }
            }
        }
    }

    
    // for slices
    var buttonsOnView: [CustomButton] {
        return buttons
    }
    // subviews
    fileprivate var buttons = [CustomButton]()
    fileprivate let sectorLayer = CAShapeLayer()
    fileprivate let selectedLayer = CAShapeLayer()
    // properties of plate
    fileprivate var numberOfSlices: Int = 0
    /** normal radius */
    fileprivate var innerRadius: CGFloat = 0
    /** selected radius */
    fileprivate var outerRadius: CGFloat = 0
    /** the angle of enlarge*/
    fileprivate var enlargeAngle: CGFloat = 0
    
    var angleGap: CGFloat {
        return CGFloat(2 * Double.pi) / CGFloat(numberOfSlices)
    }
    
    fileprivate var viewCenter: CGPoint {
        return  CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // for adjust frame of buttons
    fileprivate var middleAngles = [CGFloat]()
    fileprivate var translate: CGFloat = 0
    
    func setupWithFrame(_ frame: CGRect, outerRadius: CGFloat, innerRadius: CGFloat, numberOfSlices: Int, enlargeAngle: CGFloat)  {
        // assign for draw
        self.numberOfSlices = numberOfSlices
        self.innerRadius = innerRadius
        self.outerRadius = outerRadius
        self.enlargeAngle = enlargeAngle
        
        // basic UI
        self.frame = frame
        backgroundColor = UIColor.clear
        
        // angle and position
        let lineColor = UIColorFromRGB(178, green: 188, blue: 202).cgColor
        // sector
        sectorLayer.lineWidth = 1.4
        sectorLayer.strokeColor = lineColor
        sectorLayer.fillColor = UIColor.white.cgColor
        sectorLayer.addBlackShadow(2)
        // selected
        selectedLayer.lineWidth = 2
        selectedLayer.strokeColor = lineColor
        selectedLayer.fillColor = UIColor.white.cgColor
        selectedLayer.addBlackShadow(4)
        selectedLayer.shadowOffset = CGSize.zero
//        selectedLayer.shadowColor = textTintGray.cgColor
        
        layer.addSublayer(sectorLayer)
        layer.addSublayer(selectedLayer)
        drawSectors()
        
        // buttons
        for i in 0..<numberOfSlices {
            let startAngle = enlargeAngle + (CGFloat(i) - 0.5) * angleGap
            let middleAngle = startAngle + angleGap * 0.5
            middleAngles.append(middleAngle)
            
            // add buttons
            let button = CustomButton(type: .custom)
            button.tag = 300 + i
            button.frame = Calculation().inscribeSqureRect(angleGap, startAngle: startAngle, radius: innerRadius, vertex: viewCenter)
            translate = (outerRadius - innerRadius)
            
            let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi)/2 + middleAngle)
            let scale = (i == 0 ? rotation : rotation.scaledBy(x: 0.8, y: 0.8))
            let transform = (i == 0 ? scale.translatedBy(x: 0, y: -translate) : scale)
            
            button.transform = transform
            
            buttons.append(button)
            addSubview(button)
        }
    }
  
    // assgin sector path
    fileprivate func drawSectors() {
        let sectorPath = UIBezierPath()
        var selectedPath = UIBezierPath()
        
        // path
        for i in 0..<numberOfSlices {
            let startAngle = enlargeAngle + (CGFloat(i) - 0.5) * angleGap
            let endAngle = startAngle + angleGap
            
            // arc and one radius line
            if i == selectedIndex {
                selectedPath = UIBezierPath(arcCenter: viewCenter, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                selectedPath.addLine(to: viewCenter)
                selectedPath.close()
            }else {
                let path = UIBezierPath(arcCenter: viewCenter, radius: innerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                path.addLine(to: viewCenter)
                path.close()
                
                sectorPath.append(path)
            }
        }
        
        sectorLayer.path = sectorPath.cgPath
        selectedLayer.path = selectedPath.cgPath
    }
    
    // rotation angle
    var rotationAngle: CGFloat {
        return rAngle
    }
    fileprivate var rAngle: CGFloat = 0
    
    // touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let currentPoint = touches.first!.location(in: self)
        
        let lastPoint = touches.first!.previousLocation(in: self)
        let angle = Calculation().angleOfPoint(currentPoint, center: viewCenter) - Calculation().angleOfPoint(lastPoint, center: viewCenter)
        tuneWithAngle(angle)
    }
    
    func tuneWithAngle(_ angle: CGFloat)  {
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
    func adjustAngle() {
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
    
    // touch to scroll
    func scrollToAngle(_ index: Int) {
        if index == selectedIndex {
            print("current slice is selected")
            return
        }
        
        rAngle = -CGFloat(index) * angleGap

        UIView.animate(withDuration: 0.5, animations: {
            self.transform = CGAffineTransform(rotationAngle: self.rAngle)
            
        }) { (true) in
            self.selectedIndex = index
            self.adjustAngle()
        }
    }


    // MARK: ---------- for colorful background
    fileprivate var numbers = [Int]()
    fileprivate var colors = [UIColor]()
    fileprivate var titles = [String]()
    fileprivate let circleShadow = CAShapeLayer()
    func setupWithGroups(_ groups: [(title: String?, number: Int, color: UIColor)]) {
        // number of slices
        var total = 0
        for group in groups {
            total += group.number
        }
        
        if total != numberOfSlices {
            print("wrong number")
            return
        }
        
        // border(make like gradient)
        // maskToBounds is set, so mask is not needed
        if circleShadow.superlayer == nil {
            layer.insertSublayer(circleShadow, below: sectorLayer)
        }
        
        let gap = outerRadius - innerRadius
        circleShadow.shadowColor = UIColor.black.cgColor
        circleShadow.shadowOffset = CGSize.zero
        circleShadow.shadowOpacity = 0.75
        circleShadow.shadowRadius = gap * 0.45
        
        let outerRect = CGRect(center: viewCenter, length: outerRadius * 2)
        let path = UIBezierPath(ovalIn: outerRect)
        path.append(UIBezierPath(ovalIn: outerRect.insetBy(dx: -gap, dy: -gap)))
        circleShadow.path = path.cgPath
        circleShadow.fillRule = kCAFillRuleEvenOdd // innner not filled
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(ovalIn: outerRect).cgPath
        circleShadow.mask = maskLayer
        
        // set up
        numbers.removeAll()
        colors.removeAll()
        titles.removeAll()
        
        // assign
        for group in groups {
            numbers.append(group.number)
            colors.append(group.color)
            titles.append(group.title ?? "Bold")
        }
        
        // draw rect
        setNeedsDisplay()
    }
    
    // test
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()!
        let gap = outerRadius - innerRadius
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: gap * 0.65), NSForegroundColorAttributeName: UIColor.black]
        let circleText = ANCircleText()
        
        // draw
        var cursor = 0
        var angles = [(start: CGFloat, end: CGFloat)]()
        for (i, number) in numbers.enumerated() {
            let startAngle = enlargeAngle + (CGFloat(cursor) - 0.5) * angleGap
            let endAngle = startAngle + angleGap * CGFloat(number)
            cursor += number
            angles.append((startAngle, endAngle))
            
            // colors
            let path = UIBezierPath(arcCenter: viewCenter, radius: 0.5 * (innerRadius + outerRadius), startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.lineWidth = gap
            colors[i].setStroke()
            path.stroke()
        }
        
        // texts
        for (i, title) in titles.enumerated() {
            let leftAngle = -angles[i].start * 180 / CGFloat(Double.pi)
            let rightAngle = -angles[i].end * 180 / CGFloat(Double.pi)
            
            // draw
            let string = NSMutableAttributedString(string: title, attributes: attributes)
            circleText.paintCircleText(context, text: string, style: .alignMiddle, radius: innerRadius, width: gap, left: leftAngle, right: rightAngle, center: viewCenter)
        }
    }
    
    // draw text
    fileprivate func drawArcText(_ text: String, font: UIFont, textColor: UIColor, center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat) {
     
    }
    
    
}
