//
//  NineFactorsCollectionViewCell.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/14.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

let nineFactorsCellID = "nine factors cell identifier"
class NineFactorsCollectionViewCell: UICollectionViewCell {
    var isChosen = false {
        didSet{
            // image
            indiImageView.isHidden = !isChosen
            if !isChosen {
                imageView.image = UIImage(named: "BE_center")
            }
        }
    }
    
    
    // common
    fileprivate let imageView = UIImageView()
    fileprivate let indiImageView = UIImageView()
    fileprivate let textLabel = UILabel()
    fileprivate let labelBack = UIView()

    // negative
    fileprivate let nBorderColor = UIColorFromRGB(170, green: 153, blue: 224)
    fileprivate let nFillColor = UIColorFromRGB(204, green: 188, blue: 255)
    fileprivate let nButterfly = UIImage(named: "BE_negative")
    // positive
    fileprivate let pBorderColor = UIColorFromRGB(126, green: 211, blue: 33)
    fileprivate let pFillColor = UIColorFromRGB(196, green: 243, blue: 144)
    fileprivate let pButterfly = UIImage(named: "BE_positive")
    
    // data
    fileprivate var imageUrl: URL! {
        didSet{
            imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.placeHolder, options: .refreshCached, completed: nil)
        }
    }
    fileprivate var positive = true {
        didSet {
            labelBack.layer.borderColor = positive ? pBorderColor.cgColor : nBorderColor.cgColor
            labelBack.backgroundColor = positive ? pFillColor : nFillColor
            indiImageView.image = positive ? pButterfly : nButterfly
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate func updateUI() {
        backgroundColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFit
        indiImageView.contentMode = .scaleAspectFit
        
        textLabel.numberOfLines = 0
        layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(labelBack)
        contentView.addSubview(textLabel)
        contentView.addSubview(indiImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        imageView.frame = CGRect(x: 6 * fontFactor, y: 6 * fontFactor, width: bounds.width - 12 * fontFactor, height: bounds.height - 8 * fontFactor - 53 * standHP)
        indiImageView.frame = CGRect(x: bounds.width - 40 * fontFactor , y: 6 * fontFactor, width: 40 * fontFactor, height: 50 * fontFactor)
        
        // textlabel
        textLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: UIFont.Weight.semibold)

        // 57 for total
        let textHeight = 41 * standHP
        textLabel.frame = CGRect(x: 8 * standWP, y: bounds.height - textHeight - 6 * standHP, width: bounds.width - 12 * standWP, height: textHeight)
        labelBack.frame = CGRect(x: -2 * fontFactor, y: bounds.height - textHeight - 12 * standHP, width: bounds.width + 4 * fontFactor, height: textHeight + 14 * fontFactor)
        
        // layer
        layer.cornerRadius = 8 * fontFactor
        labelBack.layer.borderWidth = fontFactor
    }
    
    func configureCellWithText(_ text: String!, imageUrl: URL!, positive: Bool, answered: Bool) {
        self.imageUrl = imageUrl
        self.positive = positive
        
        textLabel.text = text
        isChosen = answered
    }
}
