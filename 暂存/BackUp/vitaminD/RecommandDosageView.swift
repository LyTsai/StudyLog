//
//  RecommandDosageView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/22.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class RecommandDosageView: UIScrollView {
    fileprivate let tempImageView = UIImageView(image: UIImage(named: "dosages")) // 328 * 520
    fileprivate let annotation = UIImageView(image: UIImage(named: "annotation"))
    fileprivate let currentLabel = UILabel()
//    fileprivate let currentLabelBack = UILabel()
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
        annotation.contentMode = .scaleAspectFit
        
        addSubview(tempImageView)
        
//        addSubview(currentLabelBack)
        
//        currentLabel.layer.borderColor = UIColor.red.cgColor
        currentLabel.layer.masksToBounds = true
        currentLabel.backgroundColor = UIColor.black
        currentLabel.textColor = UIColor.white
//        white.withAlphaComponent(0.98)
        currentLabel.textAlignment = .center
        currentLabel.numberOfLines = 0
//        currentLabelBack.textAlignment = .center
//        currentLabelBack.numberOfLines = 0
        
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

    }
    
//    fileprivate var mainRect = CGRect.zero
    fileprivate var turningPoints = [CGPoint]()
    fileprivate var levelPoints = [CGPoint]()
    
    fileprivate var ratio: CGFloat = 325 / 345
//    fileprivate let turning = [CGPoint(x: 57, y: 477), CGPoint(x: 110, y: 416), CGPoint(x: 163, y: 357), CGPoint(x: 211, y: 301), CGPoint(x: 254, y: 245)]
//    fileprivate let level = [CGPoint(x: 132, y: 535), CGPoint(x: 71, y: 521), CGPoint(x: 142, y: 491), CGPoint(x: 166, y: 477),  CGPoint(x: 158, y: 431),  CGPoint(x: 189, y: 398), CGPoint(x: 216, y: 370),  CGPoint(x: 234, y: 341), CGPoint(x: 263, y: 311), CGPoint(x: 268, y: 251), CGPoint(x: 271, y: 152)]  // >60
    fileprivate let turning = [CGPoint(x: 221, y: 29), CGPoint(x: 172, y: 79), CGPoint(x: 123, y: 129), CGPoint(x: 76, y: 174), CGPoint(x: 24, y: 230)]
    fileprivate let level = [CGPoint(x: 260, y: 24), CGPoint(x: 311, y: 82), CGPoint(x: 315, y: 97), CGPoint(x: 272, y: 142),  CGPoint(x: 276, y: 156),  CGPoint(x: 236, y: 214), CGPoint(x: 220, y: 231),  CGPoint(x: 188, y: 261), CGPoint(x: 190, y: 288), CGPoint(x: 152, y: 321), CGPoint(x: 85, y: 388)]  // >60
    
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
    func setupWithCurrentLevel(_ levelIndex: Int, cardIndex: Int, text: String, lbsWeight: Float) {
        currentLabel.text = text
        
        let point = bounds.width / 345
        let annotationH = bounds.width * 0.1 * ratio
        let offsetY = annotationH * 0.5
        
        // backImages
        let imageSize = CGSize(width: bounds.width * ratio, height: bounds.width * ratio * 520 / 328)
        tempImageView.frame = CGRect(origin: CGPoint(x: bounds.width * (1 - ratio) * 0.5, y:  offsetY), size: imageSize)
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
            let font = UIFont.systemFont(ofSize: 16 * point, weight: UIFontWeightBold)
            back.font = font
            let result = getDosagesWithLbsWeight(lbsWeight, levelIndex: levelIndex, targetIndex: i)
            if result != 0 {
                let resultS = NSMutableAttributedString(string: "\(result)\n", attributes:[NSFontAttributeName: font, NSForegroundColorAttributeName: UIColorFromRGB(255, green: 129, blue: 0)])
                resultS.append(NSAttributedString(string: "IU/day", attributes:[NSFontAttributeName:  UIFont.systemFont(ofSize: 10 * point, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.black]))
                label.attributedText = resultS
                
                let backS = NSMutableAttributedString(string: "\(result)\n", attributes:[NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: NSNumber(value: 15)])
                backS.append(NSAttributedString(string: "IU/day", attributes:[NSFontAttributeName:  UIFont.systemFont(ofSize: 10 * point, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColor.clear]))
                back.attributedText = backS
                
            }else {
                label.text = ""
                back.text = ""
            }
        }
        
        // annotation
        let cFont = UIFont.systemFont(ofSize: annotationH / 3, weight: UIFontWeightMedium)
        currentLabel.font = cFont
//        currentLabelBack.attributedText = NSAttributedString(string: text, attributes: [NSStrokeColorAttributeName: UIColor.white, NSStrokeWidthAttributeName: NSNumber(value: 15), NSFontAttributeName: cFont])
        
        let bottomPoint = levelPoints[levelIndex]
        annotation.frame = CGRect(x: bottomPoint.x - annotationH * 0.5, y: bottomPoint.y - annotationH, width: annotationH, height: annotationH) // 37 * 53
        let cWidth = annotationH * 4
        currentLabel.frame = CGRect(x: annotation.frame.midX - cWidth, y: annotation.frame.minY + annotationH * 0.02, width: cWidth, height: annotationH * 0.96)
        currentLabel.layer.cornerRadius = point * 2
        currentLabel.layer.borderWidth = point
//        currentLabelBack.frame = currentLabel.frame
        let offY = min(max(0, annotation.center.y - bounds.midY), contentSize.height - bounds.height)
        contentOffset = CGPoint(x: 0, y: offY)
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
//        if dosage % 1000 != 0 {
            dosage += 500
//        }
        dosage /= 1000
        dosage *= 1000
        
        return min(10000, dosage)
    }
}
