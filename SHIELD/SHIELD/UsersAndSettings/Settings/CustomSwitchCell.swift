//
//  CustomSwitchCell.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/10.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

let customSwitchCellID = "custom Switch Cell ID"
class CustomSwitchCell: UITableViewCell {
    var switchIsTapped: (()->Void)?
    
    fileprivate let titleLabel = UILabel()
    fileprivate let switchImage = UIImageView()
    fileprivate var isOn = false {
        didSet{
            switchImage.image = isOn ? #imageLiteral(resourceName: "switch_on") : #imageLiteral(resourceName: "switch_off")
        }
    }
    
    class func cellWithTableView(_ table: UITableView, title: NSAttributedString, isOn: Bool) -> CustomSwitchCell {
        var cell = table.dequeueReusableCell(withIdentifier: customSwitchCellID) as? CustomSwitchCell
        if cell == nil {
            cell = CustomSwitchCell(style: .default, reuseIdentifier: customSwitchCellID)
            cell!.addBasic()
        }
        
        cell!.titleLabel.attributedText = title
        cell!.isOn = isOn
        
        return cell!
    }
    
    func addBasic()  {
        selectionStyle = .none
        switchImage.isUserInteractionEnabled = true
        contentView.addSubview(titleLabel)
        contentView.addSubview(switchImage)
        
        let changeTap = UITapGestureRecognizer(target: self, action: #selector(changeState))
        switchImage.addGestureRecognizer(changeTap)
    }
    
    @objc func changeState() {
        isOn = !isOn
        switchIsTapped?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        let margin = 20 * bounds.width / 375
        let oneSize = min(bounds.width / 375, bounds.height / 56) * 0.65
        
        switchImage.frame = CGRect(center: CGPoint(x: bounds.width - 26 * oneSize - margin, y: bounds.midY), width: 53 * oneSize, height: 37 * oneSize)
        titleLabel.frame = CGRect(x: margin, y: 0, width: switchImage.frame.minX - margin, height: bounds.height)
    }
}
