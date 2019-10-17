//
//  AssortedRotateView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/8/23.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class AssortedRotateView: UIView {
    var pieDelegate: PieViewDelegate!

    var topIndex: Int = -1

    // for slices
    var buttonsOnView: [CustomButton] {
        return buttons
    }
    // subviews
    fileprivate var buttons = [CustomButton]()

    // properties of plate
    fileprivate var numberOfSlices: Int = 0
    /** normal radius */
    fileprivate var innerRadius: CGFloat = 0
    /** selected radius */
    fileprivate var outerRadius: CGFloat = 0
    /** the angle of enlarge*/
    fileprivate var topAngle: CGFloat = -CGFloat(Double.pi) / 2
    
    var angleGap: CGFloat = 0
    fileprivate var viewCenter = CGPoint.zero
    
    // lines
    fileprivate var lineWidth: CGFloat = 1
 
    // the slices and shapes
    fileprivate var dataSource = [(MetricGroupObjModel, [MetricObjModel])]()
    fileprivate var allMetrics = [MetricObjModel]()
    func setupWithFrame(_ frame: CGRect, innerRadius: CGFloat, dataSource: [(MetricGroupObjModel, [MetricObjModel])])  {
        self.frame = frame
        backgroundColor = UIColor.clear
        viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        outerRadius = min(frame.width, frame.height) * 0.5
        lineWidth = outerRadius / 160 * 2.5
        outerRadius -= lineWidth * 1.5
        
        // clear data
        for button in buttons {
            button.removeFromSuperview()
        }
        buttons.removeAll()
        allMetrics.removeAll()
        
        // data
        self.dataSource = dataSource
        for (_, metrics) in dataSource {
            allMetrics.append(contentsOf: metrics)
        }
        
        numberOfSlices = allMetrics.count
        if numberOfSlices == 0 {
            return
        }
        
        angleGap = CGFloat(2 * Double.pi) / CGFloat(numberOfSlices)
        
        if numberOfSlices == 2 {
            angleGap = CGFloatPi * 0.5
            topAngle = -CGFloatPi * 1.5
        }
        
        // buttons
        for (i, metric) in allMetrics.enumerated() {
            let startAngle = topAngle + (CGFloat(i) - 0.5) * angleGap
            let middleAngle = startAngle + 0.5 * angleGap
            // add buttons
            let button = CustomButton(type: .custom)
            button.tag = 200 + i
            button.key = metric.key
            
            let imageL = max(innerRadius * 2 * sin(angleGap * 0.5), outerRadius * 0.28)
            let maxH = outerRadius * cos(angleGap * 0.5)
            let bottomH = imageL * 0.5 / tan(angleGap * 0.5)
            let bWidth = 2 * (imageL + bottomH) * tan(angleGap * 0.5)
            let bHeight = maxH - bottomH
            
            let bCenter = Calculation.getPositionByAngle(middleAngle, radius: maxH - 0.5 * bHeight, origin: viewCenter)
            button.frame = CGRect(center: bCenter, width: bWidth, height: bHeight)
            button.fontRatio = 0.2
            button.verticalWithText(metric.name, image: metric.imageUrl, heightRatio: 1 - imageL / bHeight)
            button.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi) / 2 + middleAngle)
            
            // add
            buttons.append(button)
            addSubview(button)
        }
        
        setNeedsDisplay()
    }
    
    // rotation angle
    var scale: CGFloat = 1
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
        let currentPoint = touches.first!.location(in: self)
        
        let lastPoint = touches.first!.previousLocation(in: self)
        let angle = Calculation.angleOfPoint(currentPoint, center: viewCenter) - Calculation.angleOfPoint(lastPoint, center: viewCenter)
        tuneWithAngle(angle)
        
        var index = 0
        let total = rAngle / angleGap
        index = (total > 0 ? Int(total + 0.5) : Int(total - 0.5)) % numberOfSlices
        index = (index > 0 ? (numberOfSlices - index) : -index)
        
        topIndex = index
        
        if pieDelegate != nil {
            pieDelegate.pieView?(self, isRotatingTo: topIndex)
        }
    }
    
    func tuneWithAngle(_ angle: CGFloat) {
        transform = transform.rotated(by: angle)
        rAngle += angle
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        adjustAngle()
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        adjustAngle()
    }
    
    // scroll to center
    func adjustAngle() {
        if numberOfSlices == 0 {
            return
        }
        
        var desA: CGFloat = 0
        if topIndex == -1 {
            var index = 0
            let total = rAngle / angleGap
            index = (total > 0 ? Int(total + 0.5) : Int(total - 0.5)) % numberOfSlices
            index = (index > 0 ? (numberOfSlices - index) : -index)
            desA = -CGFloat(index) * angleGap
        }else {
            desA = -CGFloat(topIndex) * angleGap
        }
        
        transform = transform.rotated(by: (desA - rAngle))
        rAngle = desA
    }
    
    // scroll
    func scrollToAngle() {
        var currentTop = 0
        let total = rAngle / angleGap
        currentTop = (total > 0 ? Int(total + 0.5) : Int(total - 0.5)) % numberOfSlices
        currentTop = (currentTop > 0 ? (numberOfSlices - currentTop) : -currentTop)
        
        if currentTop == topIndex {
            adjustAngle()
            if self.pieDelegate != nil {
                pieDelegate.pieView?(self, didMoveTo: topIndex)
            }
        }else {
            // animation, go to directly
            var indexGap = abs(currentTop - topIndex)
            let half = numberOfSlices / 2
            if half < indexGap {
                indexGap = numberOfSlices - indexGap
            }
            
            rAngle = -CGFloat(topIndex) * angleGap
            
            UIView.animate(withDuration: min(0.15 * Double(indexGap), 1), delay: 0, options: .curveEaseInOut, animations: {
                self.transform = CGAffineTransform(rotationAngle: self.rAngle)
            }) { (true) in
                if self.pieDelegate != nil {
                    self.pieDelegate.pieView?(self, didMoveTo: self.topIndex)
                }
            }
        }
    }
    
    // draw
    var pathes = [UIBezierPath]()
    
    override func draw(_ rect: CGRect) {
        pathes.removeAll()
        UIBezierPath(arcCenter: viewCenter, radius: outerRadius, startAngle: 0, endAngle: CGFloat(Double.pi) * 2, clockwise: true).addClip()
        
        // draw back
        var cursor = 0
        for (_, metrics) in dataSource {
            for _ in metrics {
                let startAngle = topAngle + (CGFloat(cursor) - 0.5) * angleGap
                let endAngle = startAngle + angleGap
                
                let path = UIBezierPath()
                path.lineJoinStyle = .miter
                
                path.move(to: viewCenter)
                path.addLine(to: Calculation.getPositionByAngle(startAngle, radius: outerRadius, origin: viewCenter))
                path.addLine(to: Calculation.getPositionByAngle(endAngle, radius: outerRadius, origin: viewCenter))
                path.close()
                
                UIColor.white.setFill()
                path.fill()
    
                // shadow
                let innerShadow = path.copy() as! UIBezierPath
                let off = outerRadius * 0.05
                let outerCenter = Calculation.getPositionByAngle(CGFloat(Double.pi) + (startAngle + angleGap * 0.5), radius: off, origin: viewCenter)
                 let radius = outerRadius + off * 2
                innerShadow.move(to: outerCenter)
                innerShadow.addLine(to: Calculation.getPositionByAngle(startAngle, radius: radius, origin: outerCenter))
                innerShadow.addLine(to: Calculation.getPositionByAngle(endAngle, radius: radius, origin: outerCenter))
                innerShadow.close()
                innerShadow.usesEvenOddFillRule = true
                let ctx = UIGraphicsGetCurrentContext()!
                ctx.saveGState()
                ctx.setShadow(offset: CGSize.zero, blur: lineWidth * 3, color: UIColor.black.withAlphaComponent(0.9).cgColor)
                UIColor.red.setFill()
                
                ctx.addPath(path.cgPath)
                ctx.clip()
                innerShadow.fill()
                ctx.restoreGState()
                
                // border
                path.lineWidth = lineWidth
                UIColorFromHex(0x00BFA5).setStroke()
                path.stroke()
                pathes.append(path)

                cursor += 1
            }
        }
    }
}
