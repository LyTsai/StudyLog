//
//  GetMethodChooseView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/13.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class GetMethodChooseView: UIView {
    var displayIndex = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var methodButtons = [UIButton]()
    var nameLabels = [UILabel]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButtons()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addButtons()
    }
    
    
    func addButtons() {
        backgroundColor = UIColorGray(241)
        
        let names = ["Sun's UVB rays","Diet/Food","Supplements"]
        for (i, name) in names.enumerated() {
            let button = UIButton(type: .custom)
            button.tag = 300 + i
            button.setBackgroundImage(UIImage(named: "dosage_\(i)"), for: .normal)
            button.addTarget(self, action: #selector(showMethod), for: .touchUpInside)
            methodButtons.append(button)
            addSubview(button)
            
            let label = UILabel()
            label.textAlignment = .center
            label.text = name
            addSubview(label)
            nameLabels.append(label)
            
            if i != 0 {
                button.isEnabled = false
                label.alpha = 0.5
            }else {
                button.layer.addBlackShadow(fontFactor * 4)
                button.layer.shadowOpacity = 0.6
            }
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let bLength = bounds.height * 35 / 83
        let gap = (bounds.width - bLength * 3) / 4
        let firstX = gap
        for (i, button) in methodButtons.enumerated() {
            button.frame = CGRect(x: firstX + CGFloat(i) * (bLength + gap), y: bLength * 0.2, width: bLength, height: bLength)
            let labelW = gap + bLength
            let labelH = bounds.height * 0.9 - button.frame.maxY - bLength * 0.2
            nameLabels[i].frame = CGRect(x: button.frame.midX - labelW * 0.5, y: button.frame.maxY + bLength * 0.1, width: labelW, height: labelH)
            nameLabels[i].font = UIFont.systemFont(ofSize: bLength / 3, weight: UIFont.Weight.medium)
        }
        
        setNeedsDisplay()
    }
    
    
    @objc func showMethod(_ button: UIButton) {
        
        
    }
    
    override func draw(_ rect: CGRect) {
        let topH = bounds.height * 0.1
        let arrowTopX = methodButtons[displayIndex].frame.midX
        let path = UIBezierPath()
        path.move(to: CGPoint(x: arrowTopX, y: bounds.height - topH * 1.5))
        path.addLine(to: CGPoint(x: arrowTopX - topH, y: bounds.height - topH * 0.5))
        path.addLine(to: CGPoint(x: arrowTopX + topH, y: bounds.height - topH * 0.5))
        path.append(UIBezierPath(rect: CGRect(x: 0, y: bounds.height - topH * 0.5, width: bounds.width, height: topH * 0.5)))
        UIColor.white.setFill()
        path.fill()
    }
}
