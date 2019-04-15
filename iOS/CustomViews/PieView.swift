//
//  PieView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/8.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class PieView: UIView {
    // delegate
    weak var hostLandingPage: LandingMainView!
    
    // when set, transform and redraw layer path only
    var selectedIndex: Int = -1 {
        didSet{
            if selectedIndex != oldValue {
                if selectedIndex < 0 || selectedIndex >= numberOfSlices {
                    if oldValue != -1 {
                       let old = buttons[oldValue]
                        UIView.animate(withDuration: 0.1, animations: {
                            old.transform = self.normalTransformForButtonOfIndex(oldValue)
                            self.drawSectors()
                        }, completion: { (ture) in
                        })
                    }
                    return
                }
                
                let current = buttons[selectedIndex]
                var old = CustomButton()
                if oldValue != -1 {
                    old = buttons[oldValue]
                }
                // old go back, then draw, then current enlarge
                UIView.animate(withDuration: 0.1, animations: {
                    old.transform = self.normalTransformForButtonOfIndex(oldValue)
                    current.transform = self.selectedTransformForButtonOfIndex(self.selectedIndex)
                    self.drawSectors()
                }, completion: { (ture) in
                })
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
    fileprivate var translate: CGFloat = 0
    fileprivate var scaleRatio: CGFloat = 1
    
    // lines
    fileprivate var normalLineWidth: CGFloat = 1
    fileprivate var selectedLineWidth: CGFloat = 1.5
    
    // the slices and shapes
    func setupWithFrame(_ frame: CGRect, outerRadius: CGFloat, innerRadius: CGFloat, numberOfSlices: Int, enlargeAngle: CGFloat)  {
        if numberOfSlices == 0 {
            return
        }
        
        // assign for draw
        self.numberOfSlices = numberOfSlices
        self.innerRadius = innerRadius - normalLineWidth * 0.5
        self.outerRadius = outerRadius - selectedLineWidth * 0.5
        self.enlargeAngle = enlargeAngle
        
        let selectedLength = Calculation().inscribeSqureLength(angleGap, radius: outerRadius)
        let normalLength = Calculation().inscribeSqureLength(angleGap, radius: innerRadius)
            
        self.scaleRatio = sqrt (selectedLength / normalLength)
        self.translate = (1 + 1 / tan(angleGap * 0.5)) * selectedLength / 2 -  (1 + 1 / tan(angleGap * 0.5)) * normalLength / 2
        
        // basic UI
        self.frame = frame
        backgroundColor = UIColor.clear
        
        // angle and position
        let lineColor = UIColorFromRGB(178, green: 188, blue: 202).cgColor
        // sector
        sectorLayer.lineWidth = normalLineWidth
        sectorLayer.strokeColor = lineColor
        sectorLayer.fillColor = UIColor.white.cgColor
        sectorLayer.addBlackShadow(2 * fontFactor)
        sectorLayer.shadowOffset = CGSize.zero
        
        // selected
        selectedLayer.lineWidth = selectedLineWidth
        selectedLayer.strokeColor = lineColor
        selectedLayer.fillColor = UIColor.white.cgColor
        selectedLayer.addBlackShadow(2 * fontFactor)
        selectedLayer.shadowOffset = CGSize.zero
      
        layer.addSublayer(sectorLayer)
        layer.addSublayer(selectedLayer)
        drawSectors()
        
        // buttons
        for i in 0..<numberOfSlices {
            let startAngle = enlargeAngle + (CGFloat(i) - 0.5) * angleGap
  
            // add buttons
            let button = CustomButton(type: .custom)
            button.tag = 300 + i
            button.frame = Calculation().inscribeSqureRect(angleGap, startAngle: startAngle, radius: innerRadius, vertex: viewCenter)
            
            button.transform = normalTransformForButtonOfIndex(i)
            // add
            buttons.append(button)
            addSubview(button)
        }
    }
    
    // transform
    fileprivate func normalTransformForButtonOfIndex(_ index: Int) -> CGAffineTransform {
        let middleAngle = enlargeAngle + CGFloat(index)  * angleGap
        let rotation = CGAffineTransform(rotationAngle: CGFloat(Double.pi) / 2 + middleAngle)
    
        return rotation
    }
    
    fileprivate func selectedTransformForButtonOfIndex(_ index: Int) -> CGAffineTransform {
        let rotation = normalTransformForButtonOfIndex(index)
        let scale = rotation.scaledBy(x: self.scaleRatio, y: self.scaleRatio)
        let transform = scale.translatedBy(x: 0, y: -translate)
        
        return transform
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
                let path = UIBezierPath(arcCenter: viewCenter, radius: innerRadius + 0.5 * normalLineWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
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
    fileprivate var rAngle: CGFloat = 0 {
        didSet{
            if rAngle > CGFloat(2 * Double.pi) {
                rAngle -= CGFloat(2 * Double.pi)
            }else if rAngle < -CGFloat(2 * Double.pi)  {
                rAngle += CGFloat(2 * Double.pi)
            }
        }
    }
    
    // touches
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hostLandingPage != nil && hostLandingPage.tierThreeTimer != nil {
            hostLandingPage.tierThreeTimer.invalidate()
            hostLandingPage.tierThreeTimer = nil
            hostLandingPage.shakeToRemind()
        }
        
        let currentPoint = touches.first!.location(in: self)
        
        let lastPoint = touches.first!.previousLocation(in: self)
        let angle = Calculation().angleOfPoint(currentPoint, center: viewCenter) - Calculation().angleOfPoint(lastPoint, center: viewCenter)
        tuneWithAngle(angle)
        
        var index = 0
        let total = rAngle / angleGap
        index = (total > 0 ? Int(total + 0.5) : Int(total - 0.5)) % numberOfSlices
        index = (index > 0 ? (numberOfSlices - index) : -index)

        selectedIndex = index
        
        // title
        if hostLandingPage != nil {
            hostLandingPage.riskClassIsOnShow(selectedIndex)
        }
    }
    
    func tuneWithAngle(_ angle: CGFloat) {
        transform = transform.rotated(by: angle)
        rAngle += angle
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        adjustAngle()
//        if hostLandingPage != nil {
//            hostLandingPage.delegate.landingView(hostLandingPage, chosen: <#T##CustomButton#>)
//        }
        
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        adjustAngle()
    }
    
    // scroll to center
    func adjustAngle() {
        if selectedIndex == -1 {
            var index = 0
            let total = rAngle / angleGap
            index = (total > 0 ? Int(total + 0.5) : Int(total - 0.5)) % numberOfSlices
            index = (index > 0 ? (numberOfSlices - index) : -index)
            rAngle = -CGFloat(index) * angleGap
        }else {
           rAngle = -CGFloat(selectedIndex) * angleGap
        }
        
        transform = CGAffineTransform(rotationAngle: rAngle)
    }
    
    // scroll
    func scrollToAngle() {
        var currentTop = 0
        let total = rAngle / angleGap
        currentTop = (total > 0 ? Int(total + 0.5) : Int(total - 0.5)) % numberOfSlices
        currentTop = (currentTop > 0 ? (numberOfSlices - currentTop) : -currentTop)
        
        if currentTop == selectedIndex {
            adjustAngle()
            hostLandingPage.shakeToRemind()
            return
        }
       
        // animation, go to directly
        var indexGap = abs(currentTop - selectedIndex)
        let half = numberOfSlices / 2
        if half < indexGap {
            indexGap = numberOfSlices - indexGap
        }
        
        rAngle = -CGFloat(selectedIndex) * angleGap

        UIView.animate(withDuration: min(0.15 * Double(indexGap), 1), delay: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(rotationAngle: self.rAngle)
        }) { (true) in
            if self.hostLandingPage.tierIndex == 2 {
                self.hostLandingPage.shakeToRemind()
            }else {
                print("other tier is selected during rotation")
            }
        }
    }

    // MARK: ---------- for colorful background
    fileprivate var numbers = [Int]()
    fileprivate var colorPairs = [(o: UIColor, i: UIColor)]()
    fileprivate var titles = [String]()
    func setupWithGroups(_ groups: [(title: String?, number: Int, outerColor: UIColor, innerColor: UIColor)]) {
        // number of slices
        var total = 0
        for group in groups {
            total += group.number
        }
        
        if total != numberOfSlices {
            print("wrong number")
            return
        }
        // set up
        numbers.removeAll()
        colorPairs.removeAll()
        titles.removeAll()
        
        // assign
        for group in groups {
            numbers.append(group.number)
            colorPairs.append((group.outerColor,group.innerColor))
            titles.append(group.title ?? "Life")
        }
        
        // draw rect
        setNeedsDisplay()
    }
    
    // test
    override func draw(_ rect: CGRect) {
        let ctx = UIGraphicsGetCurrentContext()!
        let gap = outerRadius - innerRadius
        
        UIBezierPath(arcCenter: viewCenter, radius: outerRadius, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: true).addClip()
        // draw back
        var cursor = 0
        var angles = [(start: CGFloat, end: CGFloat)]()
        for (i, number) in numbers.enumerated() {
            let startAngle = enlargeAngle + (CGFloat(cursor) - 0.5) * angleGap
            let endAngle = startAngle + angleGap * CGFloat(number)
            cursor += number
            angles.append((startAngle, endAngle))
            
            // fill
            let path = UIBezierPath(arcCenter: viewCenter, radius: outerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            path.addLine(to: viewCenter)
            path.close()
            colorPairs[i].o.setFill()
            path.fill()
           
            // shadow
            let middle = (startAngle + endAngle) * 0.5
            let innerPath = UIBezierPath(arcCenter: CGPoint(x: viewCenter.x + cos(middle), y: viewCenter.y + sin(middle)), radius: outerRadius - gap * 0.2, startAngle: startAngle, endAngle: endAngle, clockwise: true)
            innerPath.addLine(to: viewCenter)
            innerPath.close()
            path.append(innerPath)
            
            ctx.saveGState()
            
            // heavy
            ctx.setShadow(offset: CGSize.zero, blur: gap * 0.2, color: colorPairs[i].i.cgColor)
            path.usesEvenOddFillRule = true
            path.fill()
            // slight
            ctx.setShadow(offset: CGSize.zero, blur: gap * 0.4, color: colorPairs[i].i.cgColor)
            path.fill()
            
            // inner
            ctx.setShadow(offset: CGSize.zero, blur: gap * 0.3, color: colorPairs[i].i.cgColor)
            UIBezierPath(arcCenter: viewCenter, radius: innerRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true).fill()
            
            ctx.restoreGState()
        }
        
        // texts
        ctx.saveGState()
        let shadow = NSShadow()
        shadow.shadowOffset = CGSize.zero
        shadow.shadowBlurRadius = gap * 0.1
        shadow.shadowColor = UIColor.black
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: gap * 0.66, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white]
        let decoAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: gap * 0.66, weight: UIFontWeightBold), NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: NSNumber(value: 15)]
        let circleText = ANCircleText()
        for (i, title) in titles.enumerated() {
            let leftAngle = -angles[i].start * 180 / CGFloat(Double.pi)
            let rightAngle = -angles[i].end * 180 / CGFloat(Double.pi)
            
            // draw
            let string = NSMutableAttributedString(string: title, attributes: attributes)
            circleText.paintCircleText(ctx, text: NSMutableAttributedString(string: title, attributes: decoAttributes), style: .alignMiddle, radius: innerRadius + gap * 0.05, width: gap * 0.8, left: leftAngle, right: rightAngle, center: viewCenter)
            circleText.paintCircleText(ctx, text: string, style: .alignMiddle, radius: innerRadius + gap * 0.05, width: gap * 0.8, left: leftAngle, right: rightAngle, center: viewCenter)
        }
        ctx.restoreGState()
    }
}
