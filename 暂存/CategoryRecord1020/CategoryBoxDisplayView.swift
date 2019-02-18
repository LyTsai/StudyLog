//
//  CategoryBoxDisplayView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/20.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

let categoryBoxCellID = "category box cell identifier"
class CategoryBoxDisplayCell: UICollectionViewCell {
    fileprivate let colors = [UIColorFromRGB(0, green: 158, blue: 235),
                              UIColorFromRGB(54, green: 78, blue: 228),
                              UIColorFromRGB(216, green: 49, blue: 45),
                              UIColorFromRGB(185, green: 4, blue: 227),
                              UIColorFromRGB(66, green: 147, blue: 33),
                              UIColorFromRGB(255, green: 171, blue: 0)]
    
    fileprivate let boxImageView = UIImageView()
    fileprivate let titleLabel = UILabel()
    fileprivate let cardImageView = UIImageView()
//    fileprivate let indiPairs = UIImageView()
    
    fileprivate let titleBackLayer = CALayer()
    fileprivate let processView = CustomProcessView.setupWithProcessColor(UIColorFromRGB(80, green: 211, blue: 135))
    fileprivate let processLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    fileprivate func setupUI() {
        // layer setup
        titleBackLayer.backgroundColor = UIColor.white.cgColor
        
        // labels
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        processLabel.textAlignment = .center
        processLabel.textColor = UIColor.white
        
        // imageViews
        boxImageView.contentMode = .scaleAspectFit
        cardImageView.contentMode = .scaleAspectFit
        
        // shadows
        boxImageView.layer.addBlackShadow(3)
        
        // add
        contentView.addSubview(boxImageView)
        contentView.layer.addSublayer(titleBackLayer)
        contentView.addSubview(titleLabel)
        contentView.addSubview(processView)
        contentView.addSubview(processLabel)
        contentView.addSubview(cardImageView)
    }
    
    fileprivate var closed = true {
        didSet{
            cardImageView.isHidden = closed
            
            layoutSubviews()
        }
    }
    // 115 * 155
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let standP = min(bounds.width / 115, bounds.height / 155)
        
        // box image
        let boxSize = closed ? CGSize(width: 70 * standP, height: 80 * standP) : CGSize(width: 104 * standP, height: 87 * standP)
        boxImageView.frame = CGRect(x: bounds.midX - boxSize.width * 0.5, y: bounds.height - boxSize.height, width: boxSize.width, height: boxSize.height)
        // process
        processView.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - 20 * standP), width: 50 * standP, height: 8 * standP)
        processLabel.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - 25 * standP), width: 50 * standP, height: 12 * standP)
        processLabel.font = UIFont.systemFont(ofSize: 10 * standP, weight: UIFontWeightMedium)
        
        // titleLabel
        let topSize = CGSize(width: bounds.width, height: 35 * standP)
        let titleCenterY = closed ? boxImageView.frame.minX : 0
        let topFrame = CGRect(center: CGPoint(x: bounds.midX, y: titleCenterY), width: topSize.width, height: topSize.height)
        titleBackLayer.frame = topFrame
        titleBackLayer.cornerRadius = boxSize.height * 0.5
        titleBackLayer.borderWidth = 2 * standP
        
        titleLabel.frame = topFrame.insetBy(dx: 4 * standP, dy: 2 * standP)
        titleLabel.font = UIFont.systemFont(ofSize: 12 * standP, weight: UIFontWeightBold)
        
        // cardView
        if !closed {
            
        }
    }
}

// open func
extension CategoryBoxDisplayCell {
    func configureWithIndex(_ itemIndex: Int, title: String, cardUrl: URL?, answeredNumber: Int, totalNumber: Int) {
        closed = (answeredNumber == 0)
        
        titleLabel.text = title
        processLabel.text = "\(answeredNumber)/\(totalNumber)"
        processView.processVaule = CGFloat(answeredNumber) / CGFloat(totalNumber)
        
        let index = itemIndex % 6
        let color = colors[itemIndex]
        let boxImage = closed ? UIImage(named: "box_closed_\(index)") : UIImage(named: "box_open_\(index)")
        
        boxImageView.image = boxImage
        titleBackLayer.borderColor = color.cgColor
        if !closed {
            cardImageView.layer.borderColor = color.cgColor
        }
    }
}
