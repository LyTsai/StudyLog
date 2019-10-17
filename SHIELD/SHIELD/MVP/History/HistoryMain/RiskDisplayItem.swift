//
//  RiskDisplayItem.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/21.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class RiskDisplayItem: UIView {
    var risk: String!
    
    fileprivate let backShape = CAShapeLayer()
    fileprivate let icon = UIImageView()
    fileprivate let typeLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        backgroundColor = UIColor.clear
        
        backShape.fillColor = UIColor.white.cgColor
        icon.contentMode = .scaleAspectFit
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.white
        typeLabel.layer.masksToBounds = true
        
        layer.addSublayer(backShape)
        addSubview(icon)
        addSubview(typeLabel)
    }
    
    // 36 * 41
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let labelH = bounds.height * 0.25
        let lineWidth = bounds.height / 41
        
        var topRect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - labelH * 0.5)
        topRect = topRect.insetBy(dx: lineWidth * 0.5, dy: lineWidth * 0.5)

        backShape.path = UIBezierPath(roundedRect: topRect, cornerRadius: lineWidth * 2).cgPath
        backShape.lineWidth = lineWidth
        
        icon.frame = CGRect(x: lineWidth, y: lineWidth, width: bounds.width - 2 * lineWidth, height: bounds.height - labelH - lineWidth)
        typeLabel.frame = CGRect(x: 0, y: bounds.height - labelH, width: bounds.width, height: labelH).insetBy(dx: 4 * lineWidth, dy: 0)
        typeLabel.font = UIFont.systemFont(ofSize: labelH * 0.8)
        typeLabel.layer.cornerRadius = labelH * 0.5
    }
    
    func setupWithRisk(_ riskKey: String) {
        if let risk = collection.getRisk(riskKey) {
            // metric
            if let metricKey = risk.metricKey {
                if let metric = collection.getMetric(metricKey) {
                    icon.sd_setImage(with: metric.imageUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, completed: nil)
                }
            }
            
            // riskType
            if let riskTypeKey = risk.riskTypeKey {
                if let riskType = collection.getRiskTypeByKey(riskTypeKey) {
                    let color = riskType.realColor ?? tabTintGreen
                    typeLabel.backgroundColor = color
                    backShape.strokeColor = color.cgColor
                    typeLabel.text = (riskType.name ?? "iRa")[0..<3]
                }
            }
        }
    }
}
