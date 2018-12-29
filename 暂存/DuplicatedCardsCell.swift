//
//  DuplicatedCardsCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

let duplicatedCardsCellID = "duplicated Cards Cell Identifier"
class DuplicatedCardsCell: UICollectionViewCell {
    fileprivate let backLayer = CAShapeLayer()
    fileprivate let imageView = UIImageView()
    fileprivate let baseCard = UIImageView()
    fileprivate let resultLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    func updateUI() {
        imageView.contentMode = .scaleAspectFit
        backLayer.fillColor = UIColor.white.cgColor
        
        baseCard.backgroundColor = UIColor.white
        baseCard.layer.borderColor = UIColorFromHex(0x83F9E5).cgColor
        baseCard.layer.masksToBounds = true
        
        // add
        contentView.addSubview(baseCard)
        contentView.layer.addSublayer(backLayer)
        contentView.addSubview(imageView)
        
        resultLabel.textAlignment = .center
        resultLabel.isHidden = true
        resultLabel.layer.masksToBounds = true
        resultLabel.layer.borderColor = UIColor.black.cgColor
        resultLabel.textColor = UIColor.white
        contentView.addSubview(resultLabel)
    }

    func configureWithImageUrl(_ imageUrl: URL!, borderColor: UIColor, resultTag: Bool!, showBaseline: Bool) {
        // imageUrl
        imageView.sd_setShowActivityIndicatorView(true)
        imageView.sd_setIndicatorStyle(.gray)
        imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
        }
        
        backLayer.strokeColor = borderColor.cgColor
        
        if resultTag == nil {
            resultLabel.isHidden = true
        }else {
            resultLabel.isHidden = false
            resultLabel.text = resultTag ? "ME" : "NOT ME"
            resultLabel.backgroundColor = resultTag ? UIColorFromRGB(61, green: 59, blue: 238) : UIColorFromRGB(204, green: 123, blue: 0)
        }
        
        baseCard.isHidden = !showBaseline
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
       
        let length = bounds.height
        let one = length / 65
        let borderWidth = one * 1.5
        let cornerRadius = length * 0.1
        
        let mainLength = length - borderWidth
        let mainFrame = CGRect(x: bounds.width - mainLength, y: 0, width: mainLength, height: mainLength)
        backLayer.path = UIBezierPath(roundedRect: mainFrame, cornerRadius: cornerRadius).cgPath
        backLayer.lineWidth = borderWidth
        
        // image
        imageView.frame = mainFrame.insetBy(dx: length * 0.02, dy: length * 0.02) // a little gap
     
        // ME / NOT ME
        resultLabel.frame = CGRect(x: mainFrame.minX + 2 * one, y: mainFrame.minY + 2 * one, width: 45 * one, height: 12 * one)
        resultLabel.layer.borderWidth = one
        resultLabel.font = UIFont.systemFont(ofSize: 9 * one, weight: UIFont.Weight.semibold)
        resultLabel.layer.cornerRadius = 6 * one
        
        // baseline
        baseCard.frame = CGRect(x: 0, y: 0, width: mainFrame.width, height: mainFrame.height).insetBy(dx: borderWidth, dy: borderWidth)
        baseCard.layer.borderWidth = borderWidth
        baseCard.layer.cornerRadius = cornerRadius
    }
}

