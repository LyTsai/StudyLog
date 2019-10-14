//
//  CustomRightDetailIndicatorCell.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/10.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation
let customRightDetailIndicatorCellID = "custom Right Detail Indicator Cell ID"

class CustomRightDetailIndicatorCell: UITableViewCell {
    fileprivate let titleLabel = UILabel()
    fileprivate let indiImage = UIImageView(image: #imageLiteral(resourceName: "cell_leftIndicator"))
    fileprivate let subTitleLabel = UILabel()
    
    class func cellWithTableView(_ table: UITableView, title: NSAttributedString, subTitle: NSAttributedString?) -> CustomRightDetailIndicatorCell {
        var cell = table.dequeueReusableCell(withIdentifier: customRightDetailIndicatorCellID) as? CustomRightDetailIndicatorCell
        if cell == nil {
            cell = CustomRightDetailIndicatorCell(style: .default, reuseIdentifier: customRightDetailIndicatorCellID)
            cell!.addBasic()
        }
        
        cell!.titleLabel.attributedText = title
        cell!.subTitleLabel.attributedText = subTitle
        
        return cell!
    }
    
    func addBasic()  {
        selectionStyle = .none
        subTitleLabel.textAlignment = .right
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(indiImage)
        contentView.addSubview(subTitleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let margin = 20 * bounds.width / 375
        let oneSize = min(bounds.width / 375, bounds.height / 56)
        
        indiImage.frame = CGRect(center: CGPoint(x: bounds.width - 25 * oneSize, y: bounds.midY), width: 11 * oneSize, height: 18 * oneSize)

        titleLabel.frame = CGRect(x: margin, y: 0, width: (indiImage.frame.minX - margin) * 0.7, height: bounds.height)
        subTitleLabel.frame = CGRect(x: titleLabel.frame.maxX, y: 0, width: indiImage.frame.minX - titleLabel.frame.maxX - 4 * oneSize, height: bounds.height)
    }
}
