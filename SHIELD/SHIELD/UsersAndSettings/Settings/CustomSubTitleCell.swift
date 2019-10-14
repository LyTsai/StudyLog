//
//  CustomSubTitleCell.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/10.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

let customSubTitleCellID = "Custom SubTitle Cell ID"
class CustomSubTitleCell: UITableViewCell {
    fileprivate let titleLabel = UILabel()
    fileprivate let subTitleLabel = UILabel()
    
    class func cellWithTableView(_ table: UITableView, title: NSAttributedString, subTitle: NSAttributedString?) -> CustomSubTitleCell {
        var cell = table.dequeueReusableCell(withIdentifier: customSubTitleCellID) as? CustomSubTitleCell
        if cell == nil {
            cell = CustomSubTitleCell(style: .default, reuseIdentifier: customSubTitleCellID)
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
        contentView.addSubview(subTitleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = 20 * bounds.width / 375
        titleLabel.frame = CGRect(x: margin, y: 0, width: (bounds.width - 2 * margin) * 0.7, height: bounds.height)
        subTitleLabel.frame = CGRect(x: titleLabel.frame.maxX, y: 0, width: bounds.width - margin - titleLabel.frame.maxX, height: bounds.height)
    }
}
