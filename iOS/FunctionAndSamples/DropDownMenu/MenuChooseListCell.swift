//
//  MenuChooseListCell.swift
//  BeautiPhi
//
//  Created by L on 2019/11/8.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation
import UIKit

let menuChooseID = "menu choose identifier"
class MenuChooseListCell: UITableViewCell {
    class func cellWithTable(_ table: UITableView, selectionName: String, selected: Bool) -> MenuChooseListCell {
        var cell = table.dequeueReusableCell(withIdentifier: menuChooseID) as? MenuChooseListCell
        if cell == nil {
            cell = MenuChooseListCell(style: .default, reuseIdentifier: menuChooseID)
            cell!.addAll()
        }
        cell!.setupWithSelectionName(selectionName, selected: selected)
        
        return cell!
    }
    
    fileprivate var nameLabel = UILabel()
    fileprivate let checkMark = UIImageView(image: UIImage(named: "icon_productCheck"))
    fileprivate func addAll() {
        selectionStyle = .none
        nameLabel.numberOfLines = 0
        checkMark.contentMode = .scaleAspectFit
       
        addSubview(nameLabel)
        addSubview(checkMark)
    }
    
    fileprivate func setupWithSelectionName(_ selectionName: String, selected: Bool) {
        nameLabel.text = selectionName
        checkMark.isHidden = !selected
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let checkL = bounds.height * 0.4
        checkMark.frame = CGRect(x: bounds.width - bounds.height, y: bounds.midY - checkL * 0.5, width: checkL, height: checkL)
        nameLabel.frame = CGRect(x: checkL, y: 0, width: checkMark.frame.minX - checkL, height: bounds.height)
        nameLabel.font = UIFont.systemFont(ofSize: bounds.height * 0.5)
    }
}
