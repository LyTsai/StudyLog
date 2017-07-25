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
    
    var side = "" {
        didSet{ sideLabel.text = side }
    }
    
    var mainImage = UIImage(named: "Coming Soon.png") {
        didSet{ mainImageView.image = mainImage }
    }
    
    // size concerned, change with the backImage
    fileprivate var standardW: CGFloat {
        return bounds.width / 335
    }
    fileprivate var standardH: CGFloat {
        return bounds.height / 450
    }
    
    var lineInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 18 * standardH, left: 10 * standardW, bottom: 14 * standardH, right: 10 * standardW)
    }
    
    var lineWidth: CGFloat {
        return 4 * max(standardH, standardW)
    }

    var bottomForMore: CGFloat {
        return 55 * standardH
    }
    
    // in case there is more change about the textLabel or imageView
    var titleLabel = UILabel()
    var promptLabel = UILabel()
    var mainImageView = UIImageView()
    var sideLabel = UILabel()
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    
    // factory method
    class func createWithText(_ text: String?, prompt: String?, side: String? , image: UIImage?) -> PlainCardView {
        let view = PlainCardView()
        view.setupWithText(text, prompt: prompt, side: side, image: image)
        
        return view
    }
    
    fileprivate let sideBack = UIImageView()
    fileprivate func updateUI() {
        for view in subviews {
            view.removeFromSuperview()
        }
        
        // setup titleLabel
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.backgroundColor = UIColor.clear
        titleLabel.textColor = UIColorFromRGB(69, green: 51, blue: 17)
        
        // setup promptLabel
        promptLabel.numberOfLines = 0
        promptLabel.textAlignment = .center
        promptLabel.backgroundColor = UIColor.clear
        
        // setup side
        sideBack.image = ProjectImages.sharedImage.cardSide
        sideBack.contentMode = .scaleToFill
        
        sideLabel.numberOfLines = 0
        sideLabel.textAlignment = .center
        sideLabel.backgroundColor = UIColor.clear
        
        // setup imageView
        mainImageView.contentMode = .scaleAspectFit
        
        // add
        addSubview(mainImageView)
        addSubview(titleLabel)
        addSubview(promptLabel)
        addSubview(sideBack)
        addSubview(sideLabel)
    }
    
    // setup
    func setupWithText(_ text: String?, prompt: String?, side: String?, image: UIImage?) {
        titleLabel.text = text
        promptLabel.text = prompt
        sideLabel.text = side
        mainImageView.image = image
    }
    
    // layout subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        resetLayout()
    }
    
    // call when the layout is changed, except from the frame of view is changed
    func resetLayout() {
        
        // title, x: 74, width: 187
        let titleHeight = 49 * standardH
        titleLabel.frame = CGRect(x: 74.5 * standardW, y: 0, width: 186 * standardW, height: titleHeight)
        titleLabel.font = UIFont.systemFont(ofSize: min(18, titleHeight / 2.6), weight: UIFontWeightBold)
        
        // prompt
        let promptMargin = 2 * lineInsets.left + lineWidth
        promptLabel.frame = CGRect(x: promptMargin, y: titleHeight + lineInsets.top, width: bounds.width - 2 * promptMargin, height: 72 * standardH)
        promptLabel.font = UIFont.systemFont(ofSize: min(18, 72 * standardH / 4))
        
        // image
        let overlap = 20 * standardH
        let imageY = promptLabel.frame.maxY + overlap
        mainImageView.frame = CGRect(x: lineInsets.left, y: imageY, width: bounds.width - lineInsets.left - lineInsets.right, height: bounds.height - imageY - bottomForMore - lineWidth - lineInsets.bottom)
        
        // side
        let sideSize = CGSize(width: 30 * standardW, height: 110 * standardH)
        sideBack.frame = CGRect(x: bounds.width - sideSize.width, y: bounds.height - sideSize.height - bottomForMore * 0.5, width: sideSize.width, height: sideSize.height)
        
        sideLabel.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        sideLabel.frame = sideBack.frame
        sideLabel.font = UIFont.systemFont(ofSize: min(11, sideSize.width / 1.2), weight: UIFontWeightMedium)
    }
    
    /*
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
    */
}
