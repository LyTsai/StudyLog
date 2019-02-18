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
    let imageView = UIImageView()
    let checkBox = UIView()
    let textLabel = UILabel()
    let labelBack = UIView()
    let checkmark = UIImageView(image: UIImage(named: "9factors_checkmark"))

    var isChosen = false {
        didSet{
            checkmark.isHidden = !isChosen
            checkBox.layer.borderColor = isChosen ? UIColorFromRGB(0, green: 200, blue: 83).cgColor : UIColorGray(195).cgColor
            
            // TODO: ------ label's height is changed, why?
            setNeedsLayout()
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
        checkmark.contentMode = .scaleAspectFit
        
        textLabel.numberOfLines = 0
        
        layer.masksToBounds = true
        
        contentView.addSubview(imageView)
        contentView.addSubview(labelBack)
        contentView.addSubview(textLabel)
        contentView.addSubview(checkBox)
        contentView.addSubview(checkmark)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let standHP = bounds.height / 155
        let standWP = bounds.width / 112
        let standP = min(standHP, standWP)
        let boxLength = 20 * standP

        imageView.frame = bounds.insetBy(dx: 8 * standWP, dy: 8 * standHP)
        checkBox.frame = CGRect(x: bounds.width - 8 * standWP - boxLength, y: 8 * standHP,width: boxLength, height: boxLength)

        checkmark.frame = CGRect(x: checkBox.frame.minX + 3 * standWP, y: 7 * standHP, width: 23 * standP, height: 17 * standP)
        
        checkBox.layer.borderWidth = standP
        checkBox.layer.cornerRadius = 2 * standP
        layer.cornerRadius = 8 * standP
        
        // textlabel
        textLabel.font = UIFont.systemFont(ofSize: 14 * standP, weight: UIFontWeightSemibold)
        textLabel.frame = imageView.frame
        textLabel.sizeToFit()
        
        // 57 for total
        let textHeight = max(textLabel.frame.height, 41 * standHP)
        textLabel.frame = CGRect(x: 8 * standWP, y: bounds.height - textHeight - 8 * standHP, width: bounds.width - 16 * standWP, height: textHeight)
        labelBack.frame = CGRect(x: 0, y: bounds.height - textHeight - 16 * standHP, width: bounds.width, height: textHeight + 16 * standHP)
    }
    
    func configureCellWithText(_ text: String!, image: UIImage!, bannerColor: UIColor, checked: Bool) {
        textLabel.text = text
        imageView.image = image
        labelBack.backgroundColor = bannerColor
        isChosen = checked
    }
}
