//
//  SelectTableViewCell.swift
//  AnnielyticX
//
//  Created by L on 2019/4/29.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

let selectTableViewCellID = "Select TableView Cell Identifier"
class SelectTableViewCell: UITableViewCell {
    fileprivate let checkBox = UIImageView()
    fileprivate let titleLabel = UILabel()
    class func cellWithTableView(_ table: UITableView, text: String?, available: Bool, selected: Bool) -> SelectTableViewCell {
        var cell = table.dequeueReusableCell(withIdentifier: selectTableViewCellID) as? SelectTableViewCell
        if cell == nil {
            cell = SelectTableViewCell(style: .default, reuseIdentifier: selectTableViewCellID)
            cell!.setupBasic()
        }
        
        cell!.setupWithText(text, available: available, selected: selected)
        
        return cell!
    }
    
    fileprivate func setupBasic() {
        selectionStyle = .none
        
        contentView.addSubview(checkBox)
        contentView.addSubview(titleLabel)
    }
    
    func setupWithText(_ text: String?, available: Bool, selected: Bool) {
        titleLabel.text = text
        checkBox.image = UIImage(named: selected ? "history_check" : "history_uncheck")
        
        checkBox.alpha = available ? 1 : 0.8
        titleLabel.textColor = available ? UIColor.black : UIColorGray(187)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let checkL = 25 * fontFactor
        checkBox.frame = CGRect(x: 20 * fontFactor, y: bounds.midY - checkL * 0.5, width: checkL, height: checkL)
        titleLabel.frame = CGRect(x: checkBox.frame.maxX, y: 0, width: bounds.width - checkBox.frame.maxX, height: bounds.height).insetBy(dx: 15 * fontFactor, dy: 0)
        titleLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
    }
}
