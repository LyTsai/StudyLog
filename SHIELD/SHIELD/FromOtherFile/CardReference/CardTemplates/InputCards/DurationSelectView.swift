//
//  DurationSelectView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/10.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class DurationSelectView: UIView {
    var startValue: Float = 0
    var endValue: Float = 360
    var result: Float {
        let realEnd = endValue < startValue ? (endValue + 24 * 60) : endValue
        return (realEnd - startValue)
    }
    
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    
    @IBOutlet weak var startView: UIView! // tag: 100
    @IBOutlet weak var endView: UIView!
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var clock: UIImageView!
    
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let maskLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    fileprivate var startAngle: CGFloat {
        return getAngleForSecondValue(startValue)
    }
    fileprivate var endAngle: CGFloat {
        return getAngleForSecondValue(endValue)
    }
    fileprivate let floatPi = Float(Double.pi)
    fileprivate func updateUI() {
        // gradient
        gradientLayer.mask = maskLayer
        maskLayer.backgroundColor = UIColor.clear.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        maskLayer.strokeColor = UIColor.red.cgColor
        clock.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [UIColorFromHex(0x002296).cgColor, UIColorFromHex(0x0DDFFE).cgColor]
        gradientLayer.locations = [0.01,0.99]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        
    }
    
    func setupWithValues() {
        leftLabel.text = timeStringForValue(startValue)
        startView.center = Calculation.getPositionByAngle(startAngle, radius: radius, origin: clockCenter)
        
        rightLabel.text = timeStringForValue(endValue)
        endView.center = Calculation.getPositionByAngle(endAngle, radius: radius, origin: clockCenter)
        
        setMaskPath()
        durationLabel.text = "\(Int(result) / 60)"
    }
    
    @IBAction func viewIsPanned(_ sender: UIPanGestureRecognizer) {
        let pannedView = sender.view!
        let radianValue = 12 * 60 / (2 * floatPi)
       
        if sender.state == .changed {
            let point = sender.location(in: self)
            let angle = Calculation.angleOfPoint(point, center: clockCenter)
            var gapValue = angle - Calculation.angleOfPoint(pannedView.center, center: clockCenter)
            if abs(gapValue) > CGFloat(Double.pi) {
                gapValue -= CGFloat(2 * Double.pi)
            }else if gapValue < -CGFloat(Double.pi) {
                gapValue += CGFloat(2 * Double.pi)
            }
            let valueChanged = radianValue * Float(gapValue)
            if pannedView.tag == 100 {
                startValue += valueChanged
               
                if startValue < 0 {
                    startValue += 24 * 60
                }else if startValue > 24 * 60 {
                    startValue -= 24 * 60
                }

            }else {
                endValue += valueChanged
                if endValue < 0 {
                    endValue += 24 * 60
                }else if endValue > 24 * 60 {
                    endValue -= 24 * 60
                }
            }
            
            setupWithValues()
        }
    }
    
    fileprivate func timeStringForValue(_ value: Float) -> String {
        let hour = Int(value) / 60
        let min = Int(value) % 60
        return String(format: "%02d : %02d", hour, min)
    }
    
    
    fileprivate var clockCenter = CGPoint.zero
    fileprivate var radius: CGFloat = 0
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupFonts()
        
        let sideWidth = startView.frame.width
        clockCenter = CGPoint(x: clock.frame.midX, y: clock.frame.midY)
        radius = (clock.frame.width - sideWidth) * 0.5

        gradientLayer.frame = clock.bounds
        maskLayer.lineWidth = sideWidth
        
        startView.layer.cornerRadius = sideWidth * 0.5
        endView.layer.cornerRadius = sideWidth * 0.5

        setupWithValues()
    }
    
    fileprivate func setupFonts() {
        let one = bounds.height / 261
        let titleFont = UIFont.systemFont(ofSize: 14 * one)
        leftTitleLabel.font = titleFont
        rightTitleLabel.font = titleFont
        
        let selectFont = UIFont.systemFont(ofSize: 20 * one, weight: .light)
        leftLabel.font = selectFont
        rightLabel.font = selectFont
        
        durationLabel.font = UIFont.systemFont(ofSize: 40 * one, weight: .light)
        
    }
    
    fileprivate func setMaskPath() {
        maskLayer.path = UIBezierPath(arcCenter: CGPoint(x: clock.bounds.midX, y: clock.bounds.midY), radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true).cgPath
    }
    
    fileprivate func getAngleForSecondValue(_ value: Float) -> CGFloat {
        return CGFloat((4 * value / (24 * 60) - 0.5) * floatPi)
    }
    
    fileprivate func getSecondValueForAngle(_ angle: CGFloat) -> Float {
        return (Float(angle) / floatPi + 0.5) * (24 * 60) / 4
    }
}
