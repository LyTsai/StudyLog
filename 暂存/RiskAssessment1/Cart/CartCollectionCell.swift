//
//  CartCollectionCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/14.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let cartCollectionCellID = "cart collection cell identifier"
class CartCollectionCell: ImageAndTextCell {

    fileprivate let checkImageView = UIImageView()
    override func updateUI() {
        super.updateUI()
        checkImageView.image = ProjectImages.sharedImage.unchosenIcon
        addSubview(checkImageView)
    }
    
    // edit state
    var isEditing = false {
        didSet{
            checkImageView.isHidden = !isEditing
        }
    }
    
    
    // set content of cell
    var isChosen = false {
        didSet{
            if isChosen != oldValue {
                checkImageView.image = isChosen ? ProjectImages.sharedImage.roundCheck : ProjectImages.sharedImage.unchosenIcon
            }
        }
    }
    
    func setupWithMatched(_ matched: MatchedCardsDisplayModel, color: UIColor) {
        text = matched.title
//        image = matched.image
        imageUrl = matched.imageUrl
        backLayer.strokeColor = color.cgColor
        backLayer.fillColor = UIColor.white.cgColor
        backLayer.shadowColor = UIColor.black.cgColor
        backLayer.shadowOffset = CGSize(width: 0, height: 1)
        backLayer.shadowRadius = 2
        backLayer.shadowOpacity = 0.8
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let lineWidth: CGFloat = 2 * bounds.width / 100
        let mainFrame = CGRect(x: lineWidth * 0.5, y: lineWidth * 0.5, width: bounds.width - lineWidth, height: bounds.height * 130 / 150)
        // backLayer
        let path = UIBezierPath(roundedRect: mainFrame, cornerRadius: 8).cgPath
        backLayer.lineWidth = lineWidth
        backLayer.path = path
        backLayer.shadowPath = path
    
        // text
        let mainLength = bounds.width - 2 * lineWidth
        let labelHeight = max(mainFrame.height * 0.3, mainFrame.height - mainFrame.width)
        textLabel.frame = CGRect(x: lineWidth, y: lineWidth, width: mainLength, height: labelHeight)
        textLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.3, weight: UIFontWeightSemibold)
        imageView.frame = CGRect(x: lineWidth, y: textLabel.frame.maxY, width: mainLength, height: mainFrame.height - textLabel.frame.maxY - lineWidth)
        
        let checkLength = 0.7 * (bounds.height - mainFrame.height)
        checkImageView.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - checkLength * 0.5), length: checkLength)
    }
    
}
