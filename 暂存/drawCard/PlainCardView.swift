//
//  File.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/29.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// only texts and image, used on many cards
class PlainCardView: UIView {
    // MARK: --------- properties -------------------
    // open, fill data

    var title = "" {
        didSet{ titleLabel.text = title}
    }
    var prompt = "" {
        didSet{ promptLabel.text = prompt }
    }
    var mainImage = UIImage(named: "Coming Soon.png") {
        didSet{ mainImageView.image = mainImage }
    }
    
    // size concerned
    var titleHeightPro: CGFloat = 0.3
    var marginPros: (horizontal: CGFloat, vertical: CGFloat) = (0.1, 0.07)
    var bottomForMore: CGFloat = 64 / 419
    
    // calculated for other
    var hMargin: CGFloat {
        return marginPros.horizontal * bounds.width
    }
    var vMargin: CGFloat {
        return marginPros.vertical * bounds.height
    }
    
    // in case there is more change about the textLabel or imageView
    var titleLabel = UILabel()
    var promptLabel = UILabel()
    var mainImageView = UIImageView()

    // factory method
    class func createWithText(_ text: String?, prompt: String?, image: UIImage?) -> PlainCardView {
        let view = PlainCardView()
        view.updateUI()
        view.setupWithText(text, prompt: prompt, image: image)
        
        return view
    }
    
    fileprivate func updateUI() {
        // setup titleLabel
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        
        // setup promptLabel
        promptLabel.numberOfLines = 0
        promptLabel.textAlignment = .center
        promptLabel.backgroundColor = UIColor.clear
        
        // setup imageView
        mainImageView.contentMode = .scaleAspectFit
        mainImageView.alpha = 0.5
        
        // add
        addSubview(mainImageView)
        addSubview(titleLabel)
        addSubview(promptLabel)
    }
    
    // setup
    func setupWithText(_ text: String?, prompt: String?, image: UIImage?) {
        titleLabel.text = text
        promptLabel.text = prompt
        mainImageView.image = image
    }
    
    // layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        resetLayout()
    }
    
    // call when the layout is changed, except from the frame of view is changed
    func resetLayout()  {
        // calculated results
        // width
        let labelWidth = bounds.width - hMargin * 2
        
        // height
        let bottom = bottomForMore * bounds.height
        let titleHeight = titleHeightPro * bounds.height
        
        // title label
        titleLabel.font = UIFont.systemFont(ofSize: min(22, titleHeight / 2.6), weight: UIFontWeightMedium)
        titleLabel.frame = CGRect(x: hMargin, y: vMargin, width: labelWidth, height: titleHeight)
        titleLabel.adjustWithWidthKept()
        
        // prompt label
        let promptHeight = bounds.height - 2.5 * vMargin - titleHeight - bottom
        promptLabel.font = UIFont.systemFont(ofSize: min(16, promptHeight / 2.6), weight: UIFontWeightLight)
        promptLabel.frame = CGRect(x: hMargin, y: titleLabel.frame.maxY + 0.5 * vMargin, width: labelWidth, height: promptHeight)
        promptLabel.adjustWithWidthKept()
        
        // image
        mainImageView.frame = bounds.insetBy(dx: hMargin, dy: vMargin)
        
        setNeedsDisplay()
        layer.cornerRadius = margin
        layer.masksToBounds = true
    }
    
    // MARK: ---------------- drawRect
    // all about the boarder
    var selected = false {
        didSet{
            if selected != oldValue {
                backgroundColor = selected ? selectedFillColor : UIColor.white
                setNeedsDisplay()

            }
        }
    }
    
    var normalLineColor = innerLineColor
    var fillColor = UIColorFromRGB(206, green: 230, blue: 139)
    var selectedLineColor = outerLineColor
    var selectedFillColor = innerLineColor
    
    fileprivate var margin: CGFloat {
        return min(vMargin, hMargin) * 0.3
    }
    
    // methods
    override func draw(_ rect: CGRect) {
        if selected == false {
            drawNormalBorder()
        }else {
            drawSelectedBorder()
        }
    }
    
    // for normal, without outer border
    fileprivate func drawNormalBorder() {
        
        let innerPath = UIBezierPath()
        innerPath.addArc(withCenter: CGPoint(x: margin, y: margin), radius: margin, startAngle: CGFloat(M_PI_2), endAngle: 0, clockwise: false)
        innerPath.addLine(to: CGPoint(x: bounds.width - 2 * margin, y: margin))
        innerPath.addArc(withCenter: CGPoint(x: bounds.width - margin, y: margin), radius: margin, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI_2), clockwise: false)
        innerPath.addLine(to: CGPoint(x: bounds.width - margin, y: bounds.height - 2 * margin))
        innerPath.addArc(withCenter: CGPoint(x: bounds.width - margin, y: bounds.height - margin), radius: margin, startAngle: -CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: false)
        innerPath.addLine(to: CGPoint(x: 2 * margin, y: bounds.height - margin))
        innerPath.addArc(withCenter: CGPoint(x: margin, y: bounds.height - margin), radius: margin, startAngle: 0, endAngle: -CGFloat(M_PI_2), clockwise: false)
        innerPath.close()
        
        normalLineColor.setStroke()
        fillColor.setFill()
        innerPath.lineWidth = 3
        innerPath.stroke()
        innerPath.fill()
        
        layer.borderWidth = 0
    }
    
    fileprivate func drawSelectedBorder() {
        let boxSize = CGSize(width: hMargin * 5 / 3, height: hMargin)
        
        // fill
        let innerPath = UIBezierPath()
        innerPath.addArc(withCenter: CGPoint(x: boxSize.width - margin, y: boxSize.height - margin), radius: margin, startAngle: CGFloat(M_PI_2), endAngle: 0, clockwise: false)
        innerPath.addLine(to: CGPoint(x: boxSize.width, y: margin))
        innerPath.addLine(to: CGPoint(x: bounds.width - 2 * margin, y: margin))
        innerPath.addArc(withCenter: CGPoint(x: bounds.width - margin, y: margin), radius: margin, startAngle: CGFloat(M_PI), endAngle: CGFloat(M_PI_2), clockwise: false)
        innerPath.addLine(to: CGPoint(x: bounds.width - margin, y: bounds.height - 2 * margin))
        innerPath.addArc(withCenter: CGPoint(x: bounds.width - margin, y: bounds.height - margin), radius: margin, startAngle: -CGFloat(M_PI_2), endAngle: CGFloat(M_PI), clockwise: false)
        innerPath.addLine(to: CGPoint(x: 2 * margin, y: bounds.height - margin))
        innerPath.addArc(withCenter: CGPoint(x: margin, y: bounds.height - margin), radius: margin, startAngle: 0, endAngle: -CGFloat(M_PI_2), clockwise: false)
        innerPath.addLine(to: CGPoint(x: margin, y: boxSize.height))
        innerPath.close()

        selectedLineColor.setStroke()
        innerPath.lineWidth = 3
        innerPath.stroke()
        fillColor.setFill()
        innerPath.fill()
        
        // borderFill
//        let outerPath = UIBezierPath(roundedRect: bounds, cornerRadius: margin)
//        outerPath.append(innerPath)
//        outerPath.usesEvenOddFillRule = true
//        selectedFillColor.setFill()
//
//        outerPath.fill()

        // check mark
        let checkPath = UIBezierPath()
        checkPath.move(to: CGPoint(x: boxSize.width * 0.4, y: boxSize.height * 0.6))
        checkPath.addLine(to: CGPoint(x: boxSize.width * 0.55, y: boxSize.height * 0.8))
        checkPath.addLine(to: CGPoint(x: boxSize.width * 0.75, y: boxSize.height * 0.4))
    
        checkPath.lineWidth = 3
        checkPath.lineCapStyle = .round
        UIColor.white.setStroke()
        checkPath.stroke()

        layer.borderWidth = 2
        layer.borderColor = selectedLineColor.cgColor

    }
    
}
