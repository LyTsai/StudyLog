//
//  CardProcessCell.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/13.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

// MARK: ----------------- cell
let cardProcessCellID = "card process cell identifier"
class CardProcessCell: UICollectionViewCell {
    var borderColor = UIColorFromRGB(100, green: 221, blue: 23).cgColor {
        didSet{
             textLabel.layer.borderColor = borderColor
        }
    }
    var answeredColor = UIColorFromRGB(180, green: 236, blue: 81).cgColor
    var currentShadowColor = UIColorFromRGB(178, green: 255, blue: 89).cgColor
    
    // change colors
    // set before setup
    func setToBluePair() {
        borderColor = UIColorFromRGB(0, green: 158, blue: 235).cgColor
        answeredColor = UIColorFromRGB(14, green: 167, blue: 237).cgColor
        currentShadowColor = UIColorFromRGB(0, green: 222, blue: 255).cgColor
    }
    
    func setToPetPair() {
        borderColor = UIColorFromRGB(0, green: 158, blue: 235).cgColor
        answeredColor = UIColorFromRGB(14, green: 167, blue: 237).cgColor
        currentShadowColor = UIColorFromRGB(0, green: 222, blue: 255).cgColor
    }
    
    func setToNegativePair() {
        borderColor = UIColorFromRGB(127, green: 116, blue: 165).cgColor
        answeredColor = UIColorFromRGB(151, green: 118, blue: 255).cgColor
        currentShadowColor = UIColorFromRGB(186, green: 171, blue: 236).cgColor
    }
    
    fileprivate var forProcess = false
    func setAsProcess()  {
        forProcess = true
        unBack = UIColorGray(213)
    }
    
    // set up
    fileprivate var current = false {
        didSet{
            layoutSubviews()
        }
    }
    fileprivate var isFirst = false
    fileprivate var isLast = false
    
    // subviews
    fileprivate let textLabel = UILabel()
    fileprivate let backLayer = CAShapeLayer()
    fileprivate let shadowLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }

    fileprivate func updateUI() {
        // text
        textLabel.textAlignment = .center
        textLabel.textColor = UIColor.black
        textLabel.backgroundColor = UIColor.white
        textLabel.layer.borderColor = borderColor
        textLabel.layer.masksToBounds = true
        textLabel.layer.borderWidth = 1
        
        // shadow
        shadowLayer.shadowOpacity = 1
        shadowLayer.shadowOffset = CGSize.zero
        
        // add
        contentView.layer.addSublayer(backLayer)
        contentView.layer.addSublayer(shadowLayer)
        contentView.addSubview(textLabel)
    }

    // card cell
    fileprivate var unBack = UIColor.white.withAlphaComponent(0.6)
    func setupWithIndex(_ index: Int, answered: Bool, current: Bool) {
        isFirst = false
        isLast = false
        setTextLabelState()
        
        self.current = current
        
        // assign
        textLabel.text = "\(index)"
        backLayer.fillColor = answered ? answeredColor : unBack.cgColor
        shadowLayer.shadowColor = current ?currentShadowColor : UIColor.clear.cgColor
    }
    
    func setupForFirst(_ nextAnswered: Bool) {
        isFirst = true
        isLast = false
        setTextLabelState()
        
        backLayer.fillColor = nextAnswered ? answeredColor : unBack.cgColor
    }
    
    func setupForLast(_ allAnswered: Bool) {
        isLast = true
        isFirst = false
        setTextLabelState()
        
        backLayer.fillColor = allAnswered ? answeredColor : unBack.cgColor
    }
    
    fileprivate func setTextLabelState() {
        var hidden = false
        if isLast || isFirst {
            hidden = true
        }
        
        textLabel.isHidden = hidden
        shadowLayer.isHidden = hidden
    }
    
    // layout, 0.6
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let backHeight = bounds.height * 0.2
        let backY = (bounds.height - backHeight) * 0.5
        
        if isLast {
            backLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0, dy: backY), byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: backHeight * 0.5, height: backHeight * 0.5)).cgPath
        }else if isFirst {
            backLayer.path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0, dy: backY), byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: backHeight * 0.5, height: backHeight * 0.5)).cgPath
        }else {
            backLayer.path = UIBezierPath(rect: bounds.insetBy(dx: 0, dy: backY)).cgPath
        }
       
        // text
        var labelHeight = current ? bounds.height * 0.6 : bounds.height * 0.38
        if forProcess {
            labelHeight = bounds.height * 0.6
        }
        textLabel.frame = CGRect(center: CGPoint(x: bounds.width - labelHeight * 0.52, y: bounds.midY), length: labelHeight)
        textLabel.font = forProcess ? UIFont.systemFont(ofSize: bounds.height * 0.32) : UIFont.systemFont(ofSize: bounds.height * 0.26)
        textLabel.layer.cornerRadius = labelHeight * 0.5
        
        // text shadow
        shadowLayer.shadowRadius = bounds.height * 0.15
        shadowLayer.shadowPath = UIBezierPath(roundedRect: textLabel.frame, cornerRadius: labelHeight * 0.5).cgPath
    }
    
}
