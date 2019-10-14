//
//  LoginUserOverallInputView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class HealthChooseView: UIView {
    
    var isChosen = false {
        didSet{
            if isChosen {
                textLabel.textColor = chosenColor
                imageView.image = chosenImage
            }else {
                textLabel.textColor = textColor
                imageView.image = unchosenImage
            }
        }
    }
    
    fileprivate let imageView = UIImageView()
    fileprivate let textLabel = UILabel()
    fileprivate let textColor = UIColorGray(155)
    fileprivate var chosenImage: UIImage!
    fileprivate var chosenColor: UIColor!
    fileprivate var unchosenImage: UIImage!
    fileprivate var unchosenColor: UIColor!

    func setupWithText(_ text: String, unchosenImage: UIImage?, chosenImage: UIImage?, chosenColor: UIColor) {
        self.chosenImage = chosenImage
        self.chosenColor = chosenColor
        self.unchosenImage = unchosenImage
                
        // textLabel
        textLabel.text = text
        textLabel.textAlignment = .center
        textLabel.textColor = textColor
        
        // image
        imageView.image = unchosenImage
        imageView.contentMode = .scaleAspectFit
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 2 * fontFactor)
        imageView.layer.shadowOpacity = 0.8
        imageView.layer.shadowRadius = 3 * fontFactor
        
        // add
        addSubview(imageView)
        addSubview(textLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // textLabel
        textLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height * 0.3)
        textLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.2, weight: .medium)
        
        // imageView
        let imageY = textLabel.frame.maxY + bounds.height * 0.02
        imageView.frame = CGRect(x: 0, y: imageY, width: bounds.width, height: bounds.height - imageY)
    }
}

// MARK: ------------- overall ----------------
class UserOverallInputView: DashBorderView {
    enum HealthState: String {
        case good = "Good"
        case ok = "OK"
        case poor = "Poor"
    }
    
    // result
    var result: HealthState!
    
    // views
    fileprivate let goodView = HealthChooseView()
    fileprivate let okView = HealthChooseView()
    fileprivate let poorView = HealthChooseView()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate let maskLayer = CAShapeLayer()
    // add sub
    let poorColor = UIColorFromRGB(208, green: 2, blue: 27)
    let okColor = UIColorFromRGB(255, green: 234, blue: 0)
    let goodColor = UIColorFromRGB(104, green: 159, blue: 56)
    
    override func addBasicViews() {
        super.addBasicViews()
        
        // gradient
        gradientLayer.colors = [poorColor.cgColor, okColor.cgColor, goodColor.cgColor]
        gradientLayer.startPoint = CGPoint.zero
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.locations = [0.2, 0.4, 0.8]
        
        maskLayer.strokeColor = UIColor.red.cgColor
        maskLayer.fillColor = UIColor.clear.cgColor
        gradientLayer.mask = maskLayer
        
        // setup
        goodView.setupWithText("Good", unchosenImage: UIImage(named: "state_good_un"), chosenImage: UIImage(named: "state_good"), chosenColor: goodColor)
        okView.setupWithText("OK", unchosenImage: UIImage(named: "state_ok_un"), chosenImage: UIImage(named: "state_ok"), chosenColor: okColor)
        poorView.setupWithText("Poor", unchosenImage: UIImage(named: "state_poor_un"), chosenImage: UIImage(named: "state_poor"), chosenColor: poorColor)
        
        // tags
        goodView.tag = 102
        okView.tag = 101
        poorView.tag = 100
        
        // add
        layer.addSublayer(gradientLayer)
        addSubview(goodView)
        addSubview(okView)
        addSubview(poorView)
    
        // gestures
        let goodTapGR = UITapGestureRecognizer(target: self, action: #selector(selectHealthState))
        let okTapGR = UITapGestureRecognizer(target: self, action: #selector(selectHealthState))
        let poorTapGR = UITapGestureRecognizer(target: self, action: #selector(selectHealthState))
        goodView.addGestureRecognizer(goodTapGR)
        okView.addGestureRecognizer(okTapGR)
        poorView.addGestureRecognizer(poorTapGR)
    }
    
    @objc func selectHealthState(_ tap: UITapGestureRecognizer) {
        let selectedView = tap.view as! HealthChooseView
        setupWithChosenTag(selectedView.tag)
    }
    // used for set
    func setupWithState(_ state: String) {
        var tagIndex = 100
        if state.localizedStandardContains("good") {
            tagIndex = 102
        }else if state.localizedStandardContains("ok") {
            tagIndex = 101
        }
        setupWithChosenTag(tagIndex)

    }
    
    fileprivate func setupWithChosenTag(_ tagIndex: Int) {
        if tagIndex == 102 {
            goodView.isChosen = true
            okView.isChosen = false
            poorView.isChosen = false
            
            result = .good
            maskLayer.path = fullPath.cgPath
            
        }else if tagIndex == 101 {
            goodView.isChosen = false
            okView.isChosen = true
            poorView.isChosen = false
            
            result = .ok
            maskLayer.path = middlePath.cgPath

        }else {
            goodView.isChosen = false
            okView.isChosen = false
            poorView.isChosen = true
            
            result = .poor
            maskLayer.path = nil
        }
    }
    
    fileprivate var fullPath: UIBezierPath! {
        let path = middlePath.copy() as! UIBezierPath
        if viewPoints.count == 3 {
            let radius = (viewPoints[1].x - viewPoints[0].x) / 3
             let lineOffset = poorView.frame.width * 0.13
            path.addArc(withCenter: CGPoint(x: viewPoints[1].x , y: viewPoints[1].y + radius), radius: radius, startAngle: CGFloat(Double.pi) * 1.5, endAngle: 0, clockwise: true)
            path.addLine(to: CGPoint(x: viewPoints[1].x + radius, y: bounds.height - radius - lineOffset))
            path.addArc(withCenter: CGPoint(x: viewPoints[2].x - radius, y: bounds.height - radius - lineOffset), radius: radius, startAngle: CGFloat(Double.pi), endAngle: 0, clockwise: false)
            path.addLine(to: viewPoints[2])
        }
        return path
    }
    fileprivate var middlePath: UIBezierPath! {
        let path = UIBezierPath()
        if viewPoints.count == 3 {
            let radius = (viewPoints[1].x - viewPoints[0].x) / 3
            let lineOffset = poorView.frame.width * 0.13
            path.move(to: viewPoints.first!)
            path.addLine(to: CGPoint(x: viewPoints[0].x, y: bounds.height - radius - lineOffset))
            path.addArc(withCenter: CGPoint(x: viewPoints[0].x + radius, y: bounds.height - radius - lineOffset), radius: radius, startAngle: CGFloat(Double.pi), endAngle: 0, clockwise: false)
            path.addLine(to: CGPoint(x: viewPoints[1].x - radius, y: viewPoints[1].y + radius))
            path.addArc(withCenter: CGPoint(x: viewPoints[1].x , y: viewPoints[1].y + radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi) * 1.5, clockwise: true)
        }
        return path
    }
    fileprivate var viewPoints = [CGPoint]()
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = bounds
        
        let stateWidth = bounds.width * 0.18
        let stateHeight = min(stateWidth * 1.6, (bounds.height))
        
        let okCenter = CGPoint(x: bounds.midX, y: (bounds.height) * 0.5)
        okView.frame = CGRect(center: okCenter, width: stateWidth, height: stateHeight)
        
        let poorCenter = CGPoint(x: stateWidth, y: bounds.height - stateHeight)
        poorView.frame = CGRect(center: poorCenter, width: stateWidth, height: stateHeight)
        
        let goodCenter = CGPoint(x: bounds.width - stateWidth, y: stateHeight * 0.8)
        goodView.frame = CGRect(center: goodCenter, width: stateWidth, height: stateHeight)

        viewPoints = [poorCenter, okCenter, goodCenter]
        
        maskLayer.lineWidth = goodView.frame.width * 0.07
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let line = goodView.frame.width * 0.14
        // back
        let path = fullPath.copy() as! UIBezierPath
        UIColorGray(240).setStroke()
        path.lineWidth = line
        path.stroke()
        
        // center
        UIColorGray(216).setStroke()
        path.lineWidth = line * 0.3
        path.stroke()
    }
}
