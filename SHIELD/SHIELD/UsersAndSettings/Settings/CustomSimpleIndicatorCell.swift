//
//  CustomSimpleIndicatorCell.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/10.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation
let customSimpleIndicatorCellID = "Custom Simple Indicator Cell ID"

class CustomSimpleIndicatorCell: UITableViewCell {
    fileprivate let titleLabel = UILabel()
    fileprivate let indiImage = UIImageView(image: #imageLiteral(resourceName: "cell_leftIndicator"))
    
    class func cellWithTableView(_ table: UITableView, title: NSAttributedString) -> CustomSimpleIndicatorCell {
        var cell = table.dequeueReusableCell(withIdentifier: customSimpleIndicatorCellID) as? CustomSimpleIndicatorCell
        if cell == nil {
            cell = CustomSimpleIndicatorCell(style: .default, reuseIdentifier: customSimpleIndicatorCellID)
            cell!.addBasic()
        }
        
        cell!.titleLabel.attributedText = title
        
        return cell!
    }
    
    func addBasic()  {
        selectionStyle = .none
        titleLabel.numberOfLines = 0
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(indiImage)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = 20 * bounds.width / 375
        
        let oneSize = min(bounds.width / 375, bounds.height / 56)
        
        indiImage.frame = CGRect(center: CGPoint(x: bounds.width - 25 * oneSize, y: bounds.midY), width: 11 * oneSize, height: 18 * oneSize)
        titleLabel.frame = CGRect(x: margin, y: 0, width: indiImage.frame.minX - margin, height: bounds.height)
    }
}
