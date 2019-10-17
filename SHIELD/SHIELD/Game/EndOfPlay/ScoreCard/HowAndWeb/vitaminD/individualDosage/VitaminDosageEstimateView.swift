//
//  VitaminDosageEstimateView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/17.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

// 338 * 434
class VitaminDosageEstimateView: UIView {
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var arrowImage: UIImageView!
    
    @IBOutlet weak var roadImage: UIImageView!
    @IBOutlet var dosageLabels: [UILabel]!
    @IBOutlet var dosageStrokeLabels: [UILabel]!
    fileprivate let gradientArrow = CAGradientLayer()
    fileprivate let pointArrow = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addExtraViews()
    }
    
    fileprivate let roadMask = UIView()
    fileprivate func addExtraViews() {
        roadMask.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        insertSubview(roadMask, aboveSubview: arrowImage)
        addSubview(annotationLabel)
        
        // arrow
        gradientArrow.startPoint = CGPoint.zero
        gradientArrow.endPoint = CGPoint(x: 0, y: 1)
        
        layer.addSublayer(gradientArrow)
        
        pointArrow.strokeColor = UIColor.black.cgColor
        pointArrow.fillColor = UIColor.clear.cgColor
        layer.addSublayer(pointArrow)
    }
    
    fileprivate let annotationLabel = AnnotationLabelView()
    fileprivate var levelIndex: Int = 0
    fileprivate var color = tabTintGreen
    func setupWithCurrentLevel(_ levelIndex: Int, text: String, color: UIColor, lbsWeight: Float) {
        self.levelIndex = levelIndex
        self.color = color
        
        // assign
        for (i, label) in dosageLabels.enumerated() {
            let back = dosageStrokeLabels[i]
            let result = getDosagesWithLbsWeight(lbsWeight, levelIndex: levelIndex, targetIndex: i)
            if result != 0 {
                let resultString = "\(result)"
                label.text = resultString
                let backS = NSMutableAttributedString(string: resultString, attributes:[ .strokeColor: UIColor.black,  .strokeWidth: NSNumber(value: 15)])
                back.attributedText = backS
            }else {
                label.text = ""
                back.text = ""
            }
        }
        
        // place
        annotationLabel.setupWithText(text, color: color)
    }
    
    func displayView() -> CGFloat {
        let one = bounds.width / 338
        let locations = [CGPoint(x: 288, y: 3), CGPoint(x: 282, y: 23),
                         CGPoint(x: 275, y: 48),  CGPoint(x: 280, y: 67), CGPoint(x: 233, y: 110),
                         CGPoint(x: 208, y: 138), CGPoint(x: 202, y: 179),
                         CGPoint(x: 144, y: 198), CGPoint(x: 159, y: 234), CGPoint(x: 160, y: 249),
                         CGPoint(x: 122, y: 305)]
        var point = locations[levelIndex]
        point = CGPoint(x: point.x * one, y: point.y * one)
        point = convert(point, from: roadImage)
        annotationLabel.pointToLocation(point)
        roadMask.frame = CGRect(x: 0, y: 0, width: bounds.width, height: point.y)
        
        // arrow normal state
        gradientArrow.transform = CATransform3DIdentity
        pointArrow.transform = CATransform3DIdentity
        
        gradientArrow.frame = bounds
        pointArrow.frame = gradientArrow.frame
        
        gradientArrow.colors = [color.cgColor, UIColorFromHex(0x01E25F).cgColor]
        
        // path
        let desPoint = CGPoint(x: 66 * one, y: roadImage.frame.maxY - 84 * one)
        let triL = 15 * one
        let arrowCenterX = point.x
        let topPoint = point
        let bottomPoint = CGPoint(x: arrowCenterX, y: topPoint.y + Calculation.distanceOfPointA(topPoint, pointB: desPoint))
        
        if bottomPoint.y < topPoint.y + triL * 2 {
            return annotationLabel.frame.minY
        }
        
        let middleWidth = triL / 3
        let arrowRect = CGRect(x: arrowCenterX - middleWidth * 0.5, y: topPoint.y + triL, width: middleWidth, height: bottomPoint.y - topPoint.y - 2 * triL)
        
        let arrowPath = UIBezierPath()
        // left
        arrowPath.move(to: topPoint)
        arrowPath.addLine(to: CGPoint(x: topPoint.x - triL * 0.5, y: arrowRect.minY))
        arrowPath.addLine(to: arrowRect.origin)
        arrowPath.addLine(to: CGPoint(x: arrowRect.minX, y: arrowRect.maxY))
        arrowPath.addLine(to: CGPoint(x: bottomPoint.x - triL * 0.5, y: arrowRect.maxY))
        arrowPath.addLine(to: bottomPoint)
        // right
        arrowPath.addLine(to: CGPoint(x: bottomPoint.x + triL * 0.5, y: arrowRect.maxY))
        arrowPath.addLine(to: CGPoint(x: arrowRect.maxX, y: arrowRect.maxY))
        arrowPath.addLine(to: CGPoint(x: arrowRect.maxX, y: arrowRect.minY))
        arrowPath.addLine(to: CGPoint(x: topPoint.x + triL * 0.5, y: arrowRect.minY))
        arrowPath.close()
        
        pointArrow.path = arrowPath.cgPath
        pointArrow.lineWidth = one
    
        let gradientMaskLayer = CAShapeLayer()
        gradientArrow.locations = [NSNumber(value: Float(topPoint.y / gradientArrow.frame.height)), NSNumber(value: Float(bottomPoint.y / gradientArrow.frame.height))]
        gradientMaskLayer.path = arrowPath.cgPath
        gradientArrow.mask = gradientMaskLayer
        
        // rotate
        pointArrow.anchorPoint = CGPoint(x: topPoint.x / bounds.width, y: topPoint.y / bounds.height)
        pointArrow.position = topPoint
        
        let angle = atan((topPoint.x - desPoint.x)/(desPoint.y - topPoint.y))
        pointArrow.transform = CATransform3DRotate(CATransform3DIdentity, angle, 0, 0, 1)
        
        gradientArrow.anchorPoint = pointArrow.anchorPoint
        gradientArrow.position = pointArrow.position
        gradientArrow.transform = pointArrow.transform
        
        // draw arrows
        let arrowsMask = CAShapeLayer()
        let arrowsPath = UIBezierPath()
        arrowsPath.move(to: CGPoint(x: arrowImage.bounds.midX, y: annotationLabel.frame.minY - arrowImage.frame.minY))
        arrowsPath.addLine(to: CGPoint(x: arrowImage.bounds.midX, y: arrowImage.bounds.height))
        arrowsMask.lineWidth = roadImage.bounds.width
        arrowsMask.strokeColor = UIColor.red.cgColor
        arrowsMask.path = arrowsPath.cgPath
        arrowImage.layer.mask = arrowsMask
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        basicAnimation.duration = 2
        arrowsMask.add(basicAnimation, forKey: nil)
        
        return annotationLabel.frame.minY
    }

    fileprivate func getDosagesWithLbsWeight(_ lbsWeight: Float, levelIndex: Int, targetIndex: Int) -> Int {
        let vitaminDDosageTable =  [[12, 26, 43, 64, 70], // 10
            [6, 20, 37, 58, 70],  // 15
            [0, 14, 31, 52, 70],  // 20
            [0, 7, 24, 45, 70],   // 25
            [0, 0, 17, 38, 67],   // 30
            [0, 0, 9, 30, 59],    // 35
            [0, 0, 0, 21, 50],    // 40
            [0, 0, 0, 11, 40],    // 45
            [0, 0, 0, 0, 29]]     // 50
        
        if levelIndex >= vitaminDDosageTable.count {
            print("wrong level index")
            return 0
        }
        
        var dosage = Int(Float(vitaminDDosageTable[levelIndex][targetIndex]) * lbsWeight)
        dosage += 500
        dosage /= 1000
        dosage *= 1000
        
        return min(10000, dosage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 338
        tagLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .semibold)
        let labelFont = UIFont.systemFont(ofSize: 12 * one)
        for label in dosageLabels {
            label.font = labelFont
        }
        for label in dosageStrokeLabels {
            label.font = labelFont
        }
        
        annotationLabel.frame = CGRect(x: 0, y: 0, width: 88 * one, height: 68 * one)
    }
}
