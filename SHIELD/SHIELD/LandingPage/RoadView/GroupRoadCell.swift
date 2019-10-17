//
//  GroupRoadCell.swift
//  AnnielyticX
//
//  Created by Lydire on 2019/5/11.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

// header
let groupRoadHeaderID = "group road header identifier"
class GroupRoadHeaderView: UICollectionReusableView {
    fileprivate let imageView = UIImageView()
    fileprivate let titleLabel = UILabel()
    fileprivate let pairShape = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.contentMode = .scaleAspectFit
        imageView.layer.borderColor = UIColorGray(158).cgColor
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = UIColor.white
        
        // title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        layer.addSublayer(pairShape)
        addSubview(titleLabel)
        addSubview(imageView)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func configureWithIcon(_ imageUrl: URL?, name: String?, color: UIColor) {
        imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, context: nil)
        titleLabel.text = name
        pairShape.fillColor = color.cgColor
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let startX = bounds.height
        
        let lineWidth = min(bounds.height / 45, bounds.width / 375)
        
        // 45 * 45
        let leftRect = CGRect(x: startX, y: 0, width: bounds.height, height: bounds.height)
        
        // 37 * 37
        imageView.frame = leftRect.insetBy(dx: 4 * lineWidth, dy: 4 * lineWidth)
        imageView.layer.cornerRadius = imageView.bounds.midX
        imageView.layer.borderWidth = lineWidth
        
        // label
        let labelX = leftRect.maxX + startX
        let rightMargin = bounds.height * 2
        titleLabel.frame = CGRect(x: labelX, y: 0, width: bounds.width - labelX - rightMargin, height: bounds.height).insetBy(dx: 2 * lineWidth, dy: 0)
        titleLabel.font = UIFont.systemFont(ofSize: 14 * lineWidth, weight: .semibold)
        
        // MWidth * 9
        let middleRect = CGRect(x: imageView.frame.maxX, y: bounds.midY - 5 * lineWidth, width: titleLabel.frame.minX - imageView.frame.maxX, height: 10 * lineWidth)
        
        // LWidth * 40
        let rightRect = titleLabel.frame.insetBy(dx: -titleLabel.frame.height * 0.5, dy: lineWidth * 5)
        
        // background
        let shapePath = UIBezierPath(ovalIn: leftRect)
        shapePath.append(UIBezierPath(rect: middleRect))
        shapePath.append(UIBezierPath(roundedRect: rightRect, cornerRadius: rightRect.height * 0.5))
        pairShape.path = shapePath.cgPath
    }
}

// cell
let groupRoadCellID = "group road cell identifier"
class GroupRoadCell: UICollectionViewCell {
    fileprivate let titleLabel = UILabel()
    fileprivate let imageView = UIImageView()
    fileprivate let backView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backView.backgroundColor = UIColor.white
        
        imageView.contentMode = .scaleAspectFit
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.layer.masksToBounds = true
        
        layer.borderColor = UIColor.black.cgColor
        
        contentView.addSubview(backView)
        contentView.addSubview(imageView)
        contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    // layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = min(bounds.width / 110, bounds.height / 67)
        let gap =  2 * one
        backView.frame = bounds.insetBy(dx: gap, dy: gap)
        
        let topH = bounds.height * 0.4
        let imageL = topH - 2 * gap
        imageView.frame = CGRect(x: bounds.midX - imageL * 0.5 , y: gap, width: imageL, height: imageL)
        titleLabel.frame = CGRect(x: 0, y: topH, width: bounds.width, height: bounds.height - topH - gap).insetBy(dx: gap, dy: 0)
        titleLabel.font = UIFont.systemFont(ofSize: 10 * one, weight: .medium)
        
        layer.cornerRadius = 4 * one
        backView.layer.cornerRadius = 4 * one
        titleLabel.layer.cornerRadius = 4 * one
        titleLabel.layer.borderWidth = one
        layer.addBlackShadow(4 * one)
    }
    
    func configureWithImageUrl(_ imageUrl: URL?, name: String?, color: UIColor) {
        titleLabel.text = name
        imageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, context: nil)
        
        titleLabel.backgroundColor = color
        titleLabel.layer.borderColor = UIColorGray(158).cgColor
        backgroundColor = color
        layer.shadowColor = color.cgColor
    }
    
   
}
