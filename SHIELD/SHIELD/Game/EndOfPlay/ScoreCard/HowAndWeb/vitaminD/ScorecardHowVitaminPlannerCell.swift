//
//  ScorecardHowVitaminPlannerCell.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/27.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardHowVitaminPlannerCell {
    var cellTag = -1
    
    var markIsTouched: ((ScorecardHowVitaminPlannerCell)->Void)?
    var cellIsTouched: ((ScorecardHowVitaminPlannerCell)->Void)?
    
    var checked = false {
        didSet{
            checkLayer.isHidden = !checked
        }
    }
    
    var title = ""
    
    fileprivate let titleLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let checkLayer = CAShapeLayer()
    fileprivate let backShape = CAShapeLayer()
    fileprivate let markButton = UIButton(type: .custom)
    func placeCellOnView(_ view: UIView, color: UIColor, title: String, mark: Bool) {
        self.title = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = title
        
        // layers
        backShape.fillColor = color.cgColor
        backShape.strokeColor = UIColor.black.cgColor
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0.6).cgColor, UIColor.white.withAlphaComponent(0).cgColor]
        gradientLayer.locations = [0, 0.6]
        
        checkLayer.backgroundColor = UIColorFromHex(0x83E445).withAlphaComponent(0.7).cgColor
        checkLayer.strokeColor = UIColor.white.cgColor
        checkLayer.fillColor = UIColor.clear.cgColor
        
        // add all
        view.layer.addSublayer(backShape)
        view.layer.addSublayer(gradientLayer)
        view.addSubview(titleLabel)
        view.layer.addSublayer(checkLayer)
   
        backShape.addBlackShadow(3 * fontFactor)
        
        enableLabelAction()
        if mark {
            enableMarkAction()
            markButton.setBackgroundImage(#imageLiteral(resourceName: "button_rectMark"), for: .normal)
            view.addSubview(markButton)
        }
    }

    // action
    func enableMarkAction() {
        markButton.addTarget(self, action: #selector(checkDetail), for: .touchUpInside)
    }
    
    func enableLabelAction() {
        titleLabel.isUserInteractionEnabled = true
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(labelIsTapped))
        titleLabel.addGestureRecognizer(tapGR)
    }
    
    @objc func checkDetail() {
        markIsTouched?(self)
    }
    
    @objc func labelIsTapped()  {
        cellIsTouched?(self)
    }
    
    // layout
    func layoutWithFrame(_ frame: CGRect) {
        let lineWidth = min(frame.height / 35, frame.width / 135)
        
        // back
        backShape.path = UIBezierPath(roundedRect: frame, cornerRadius: 4 * lineWidth).cgPath
        backShape.lineWidth = lineWidth
        
        titleLabel.frame = CGRect(x: 5 * lineWidth + frame.minX, y: 3 * lineWidth + frame.minY, width: frame.width - 20 * lineWidth, height: frame.height - 6 * lineWidth)
        titleLabel.font = UIFont.systemFont(ofSize: 10 * fontFactor, weight: .medium)
        
        markButton.frame = CGRect(x: frame.maxX - 15 * lineWidth, y: frame.maxY - 13 * lineWidth, width: 10 * lineWidth, height: 10 * lineWidth)
        
        checkLayer.frame = frame.insetBy(dx: lineWidth, dy: lineWidth)
        checkLayer.cornerRadius = 4 * lineWidth
        gradientLayer.frame = checkLayer.frame
        gradientLayer.cornerRadius = 4 * lineWidth
        
        let checkPath = UIBezierPath()
        checkPath.move(to: CGPoint(x: checkLayer.bounds.midX - 8 * lineWidth, y: checkLayer.bounds.midY))
        checkPath.addLine(to: CGPoint(x: checkLayer.bounds.midX, y: checkLayer.bounds.midY + 8 * lineWidth))
        checkPath.addLine(to: CGPoint(x: checkLayer.bounds.midX + 14 * lineWidth, y: checkLayer.bounds.midY - 10 * lineWidth))
        checkPath.lineCapStyle = .round
        
        checkLayer.path = checkPath.cgPath
        checkLayer.lineWidth = 4 * lineWidth
    }
}
