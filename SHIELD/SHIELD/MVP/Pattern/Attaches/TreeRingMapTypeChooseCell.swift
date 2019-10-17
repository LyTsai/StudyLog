//
//  TreeRingMapTypeChooseCell.swift
//  AnnielyticX
//
//  Created by L on 2019/5/6.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

let treeRingMapTypeChooseCellID = "treeRingMap Type Choose Cell Identifier"
class TreeRingMapTypeChooseCell: UITableViewCell {
    fileprivate let titleLabel = UILabel()
    fileprivate let decoView = UIView()
    class func cellWithTableView(_ table: UITableView, text: String, chosen: Bool) -> TreeRingMapTypeChooseCell {
        var cell = table.dequeueReusableCell(withIdentifier: treeRingMapTypeChooseCellID) as? TreeRingMapTypeChooseCell
        if cell == nil {
            cell = TreeRingMapTypeChooseCell(style: .default, reuseIdentifier: treeRingMapTypeChooseCellID)
            cell?.addBasic()
        }
        cell?.titleLabel.text = text
        cell?.setChosenState(chosen)
        
        return cell!
    }
    
    fileprivate func addBasic() {
        selectionStyle = .none
        contentView.backgroundColor = UIColor.clear
        
        titleLabel.layer.masksToBounds = true
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        
        decoView.backgroundColor = UIColorFromHex(0x74D864)
        decoView.layer.addBlackShadow(4)
        contentView.addSubview(decoView)
        contentView.addSubview(titleLabel)
    }
    
    func setChosenState(_ chosen: Bool) {
        decoView.layer.shadowColor = chosen ? UIColor.black.withAlphaComponent(0.3).cgColor : UIColor.clear.cgColor
        titleLabel.backgroundColor = chosen ? UIColorFromHex(0xACEBA0) : UIColorFromHex(0xE5FFE0)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = min(bounds.height / 65, bounds.width / 191)
        titleLabel.frame =  CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - 7 * one)
        titleLabel.layer.cornerRadius = 4 * one
        titleLabel.font = UIFont.systemFont(ofSize: 14 * one, weight: .medium)
        
        decoView.frame = titleLabel.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: -one * 2, right: 0))
        decoView.layer.cornerRadius = 4 * one
        decoView.layer.shadowRadius = 4 * one
    }
}
