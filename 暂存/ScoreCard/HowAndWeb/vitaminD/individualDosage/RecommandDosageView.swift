//
//  RecommandDosageView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/22.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class RecommandDosageView: UIScrollView {
    fileprivate let tempImageView = UIImageView(image: UIImage(named: "dosages")) // 332 * 545
    fileprivate let annotation = UIImageView(image: UIImage(named: "annotation"))
    fileprivate let currentLabel = UILabel()
    fileprivate let desLabel = UILabel()
    fileprivate let arrows = UIImageView(image: UIImage(named: "dosages_arrows"))
    fileprivate let arrowsBack = UIImageView(image: UIImage(named: "dosages_arrows"))
    fileprivate let arrowMaskLayer = CAShapeLayer()
    fileprivate let arrowBackMaskLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    
    fileprivate var labels = [UILabel]()
    fileprivate var backLabels = [UILabel]()
    fileprivate func setupBasic() {
        self.bounces = false
        
        annotation.contentMode = .scaleAspectFit
        
        addSubview(tempImageView)
        arrows.layer.mask = arrowMaskLayer
        arrowsBack.alpha = 0.45
        arrowsBack.layer.mask = arrowBackMaskLayer
        tempImageView.addSubview(arrowsBack)
        tempImageView.addSubview(arrows)
        
        currentLabel.layer.masksToBounds = true
        currentLabel.backgroundColor = UIColor.black
        currentLabel.textColor = UIColor.white
        currentLabel.textAlignment = .center
        currentLabel.numberOfLines = 0
        
        for _ in 0..<5 {
            let label = UILabel()
            let back = UILabel()
       
            label.numberOfLines = 0
            back.numberOfLines = 0
            
            addSubview(back)
            addSubview(label)
            
            labels.append(label)
            backLabels.append(back)
        }
        
        // top
        addSubview(currentLabel)
        addSubview(annotation)

        desLabel.numberOfLines = 0
        addSubview(desLabel)
    }
    
//    fileprivate var mainRect = CGRect.zero
    fileprivate var turningPoints = [CGPoint]()
    fileprivate var levelPoints = [CGPoint]()
    
    fileprivate var ratio: CGFloat = 325 / 345
    fileprivate let turning = [CGPoint(x: 226, y: 75),  CGPoint(x: 176, y: 131), CGPoint(x: 128, y: 180), CGPoint(x: 82, y: 220), CGPoint(x: 30, y: 275)]
//    ["My current level\n <=10ng/ml", "My current level\n 11-15ng/ml"]),
//    ["My current level\n 16-20ng/ml", "My current level\n 21-25ng/ml", "My current level\n 26-30ng/ml"]),
//    options: [ "My current level\n 31-35ng/ml", "My current level\n 36-40ng/ml"]),
//    options: ["My current level\n 41-45ng/ml", "My current level\n 46-50ng/ml", "My current level\n 51-60ng/ml"]),
//   options: ["My current level\n 61-100ng/ml"]),

    // bottom
    fileprivate let level = [CGPoint(x: 263, y: 57), CGPoint(x: 263, y: 83), CGPoint(x: 305, y: 128), CGPoint(x: 302, y: 160),  CGPoint(x: 274, y: 215),  CGPoint(x: 232, y: 249), CGPoint(x: 237, y: 280),  CGPoint(x: 196, y: 311), CGPoint(x: 198, y: 335), CGPoint(x: 155, y: 397), CGPoint(x: 93, y: 448)]  // >60
    
    fileprivate func adjustPoints(_ points: [CGPoint], offsetY: CGFloat) -> [CGPoint] {
        var aPoints = [CGPoint]()
        let one = tempImageView.frame.width / 325
        let offsetX = (1 - ratio) * 0.5 * bounds.width
        for point in points {
            let aPoint = CGPoint(x: point.x * one + offsetX, y: point.y * one + offsetY)
            aPoints.append(aPoint)
        }
        
        return aPoints
    }
    
    // current: <10, 11-15,16-20,21-25
    func setupWithCurrentLevel(_ levelIndex: Int, text: String, lbsWeight: Float) {
        currentLabel.text = text
        
        let point = bounds.width / 345
        let annotationH = bounds.width * 0.1 * ratio
        let offsetY = annotationH * 0.5
        
        // backImages
        let imageSize = CGSize(width: bounds.width * ratio, height: bounds.width * ratio * 545 / 332)
        tempImageView.frame = CGRect(origin: CGPoint(x: bounds.width * (1 - ratio) * 0.5, y:  offsetY), size: imageSize)
        
        // 195 * 315
        let arrowW = imageSize.width / 332 * 195
        arrows.frame = CGRect(x: imageSize.width - arrowW, y: 88 * imageSize.width / 332, width: arrowW, height: arrowW * 315 / 195)
        arrowsBack.frame = arrows.frame
        
        arrowMaskLayer.backgroundColor = UIColor.clear.cgColor
        arrowMaskLayer.lineWidth = arrowW
        arrowMaskLayer.strokeColor = UIColor.red.cgColor
        
        arrowBackMaskLayer.backgroundColor = UIColor.clear.cgColor
        arrowBackMaskLayer.lineWidth = arrowW
        arrowBackMaskLayer.strokeColor = UIColor.red.cgColor
        
        contentSize = CGSize(width: bounds.width, height: imageSize.height + bounds.width * 80 / 345 + offsetY)
        turningPoints = adjustPoints(turning, offsetY: offsetY)
        levelPoints = adjustPoints(level, offsetY: offsetY)
        
        // from low to high
        //10, target:  20, 30, 40, 50, 60, more
        for (i, label) in labels.enumerated() {
            let top = turningPoints[i]
            let back = backLabels[i]
            let labelW = bounds.width * 0.2 * ratio
            label.frame = CGRect(x: max(0, top.x - labelW * 0.5), y: top.y, width: labelW, height: labelW * 0.5)
            back.frame = label.frame
            let font = UIFont.systemFont(ofSize: 16 * point, weight: UIFont.Weight.bold)
            back.font = font
            let result = getDosagesWithLbsWeight(lbsWeight, levelIndex: levelIndex, targetIndex: i)
            if result != 0 {
                let resultS = NSMutableAttributedString(string: " \(result)\n", attributes:[NSAttributedStringKey.font: font, NSAttributedStringKey.foregroundColor: UIColorFromRGB(255, green: 129, blue: 0)])
                resultS.append(NSAttributedString(string: " IU/day", attributes:[NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 10 * point, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor: UIColor.black]))
                label.attributedText = resultS
                
                let backS = NSMutableAttributedString(string: " \(result)\n", attributes:[NSAttributedStringKey.strokeColor: UIColor.black, NSAttributedStringKey.strokeWidth: NSNumber(value: 15)])
                backS.append(NSAttributedString(string: " IU/day", attributes:[NSAttributedStringKey.font:  UIFont.systemFont(ofSize: 10 * point, weight: UIFont.Weight.semibold), NSAttributedStringKey.foregroundColor: UIColor.clear]))
                back.attributedText = backS
                
            }else {
                label.text = ""
                back.text = ""
            }
        }
        
        // annotation
        currentLabel.font = UIFont.systemFont(ofSize: annotationH / 3, weight: UIFont.Weight.medium)

        let bottomPoint = levelPoints[levelIndex]
        var isLeft = true
        if levelIndex == level.count - 1 {
            isLeft = false
        }
        annotation.frame = CGRect(x: bottomPoint.x - annotationH * 0.5, y: bottomPoint.y - annotationH, width: annotationH, height: annotationH) // 37 * 53
        let cWidth = annotationH * 3.5
        currentLabel.frame = CGRect(x: isLeft ? annotation.frame.midX - cWidth : bottomPoint.x, y: annotation.frame.minY + annotationH * 0.02, width: cWidth, height: annotationH * 0.96)
        currentLabel.layer.cornerRadius = point * 2
        currentLabel.layer.borderWidth = point
        
        desLabel.font = UIFont.systemFont(ofSize: 14 * point, weight: UIFont.Weight.semibold)
        desLabel.frame = CGRect(origin: adjustPoints([CGPoint(x: 108, y: 465)], offsetY: offsetY).first!, size: CGSize(width: 200 * point, height: 70 * point))
        desLabel.text = (levelIndex < 7) ? "Your Vitamin D level would be excellent once you reach the \"sweet spot\"" : "Your Vitamin D level has reached the \"sweet spot\". Keep up the good work!"
       
        let offY = min(max(0, annotation.center.y - bounds.midY), contentSize.height - bounds.height)
        contentOffset = CGPoint(x: 0, y: offY)
        
        // arrow
        
        let breakPoint = CGPoint(x: arrowW * 0.5, y: annotation.frame.maxY - arrows.frame.minY - tempImageView.frame.minY)
        
        let path = UIBezierPath()
        path.move(to: breakPoint)
        path.addLine(to: CGPoint(x: arrowW * 0.5, y: arrows.bounds.maxY))
        arrowMaskLayer.path = path.cgPath
        
        let backPath = UIBezierPath()
        backPath.move(to: CGPoint(x: arrowW * 0.5, y: 0))
        backPath.addLine(to: breakPoint)
        arrowBackMaskLayer.path = backPath.cgPath
        
        arrows.isHidden = true
        arrowsBack.isHidden = true
    }
    
    let vitaminDDosageTable =  [[12, 26, 43, 64, 70], // 10
        [6, 20, 37, 58, 70],  // 15
        [0, 14, 31, 52, 70],  // 20
        [0, 7, 24, 45, 70],   // 25
        [0, 0, 17, 38, 67],   // 30
        [0, 0, 9, 30, 59],    // 35
        [0, 0, 0, 21, 50],    // 40
        [0, 0, 0, 11, 40],    // 45
        [0, 0, 0, 0, 29]]     // 50
    
    func getDosagesWithLbsWeight(_ lbsWeight: Float, levelIndex: Int, targetIndex: Int) -> Int {
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
    
    func arrowAnimation() {
        arrows.isHidden = false
        arrowsBack.isHidden = false
        
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.duration = 1.5
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        arrowMaskLayer.add(basicAnimation, forKey: nil)
    }
}
