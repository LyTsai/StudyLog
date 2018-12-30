//
//  StretchExplainHeaderView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/15.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

let stretchExplainCellID = "Stretch Explain Cell ID"
class StretchExplainCell: UITableViewCell {
    class func cellWithTable(_ table: UITableView, text: String, backgroundColor: UIColor) -> StretchExplainCell {
            var cell = table.dequeueReusableCell(withIdentifier: stretchExplainCellID) as? StretchExplainCell
            if cell == nil {
                cell = StretchExplainCell(style: .default, reuseIdentifier: "StretchExplainTableCellID")
                
                cell?.textLabel?.numberOfLines = 0
                cell?.textLabel?.textColor = UIColorGray(74)
                cell?.selectionStyle = .none
            }
            

            cell?.textLabel?.text = text
            cell?.backgroundColor = backgroundColor
        
        return cell!
     
    }
    override func layoutSubviews() {
        super.layoutSubviews()
            
        textLabel?.frame = bounds.insetBy(dx: bounds.width / 315 * 10, dy: 0)
        textLabel?.font = UIFont.systemFont(ofSize: 12 * bounds.width / 315, weight: UIFont.Weight.medium)
    }
}

class StretchExplainHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadViews()
    }
    
    fileprivate let capitalLabel = UILabel()
    fileprivate let titleLabel = UILabel()
    fileprivate let arrow = UIImageView(image: UIImage(named: "arrow_down_white"))
    fileprivate func loadViews() {
        capitalLabel.textAlignment = .center
        capitalLabel.layer.masksToBounds = true
        
        arrow.contentMode = .scaleAspectFit
        
        addSubview(capitalLabel)
        addSubview(titleLabel)
        addSubview(arrow)
    }
    
    func setupWithFillColor(_ fill: UIColor, cBorder:UIColor, cFill: UIColor, title: String) {
        backgroundColor = fill
        
        capitalLabel.layer.borderColor = cBorder.cgColor
        capitalLabel.backgroundColor = cFill
        
        capitalLabel.text = "\(String(describing: title.first!))"
        titleLabel.text = title
    }
    
    
    func reverseState() {
        let current = (arrow.transform == CGAffineTransform.identity)
        arrow.transform = current ? CGAffineTransform(rotationAngle: CGFloat(Double.pi)) : CGAffineTransform.identity
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.width / 315
        
        capitalLabel.frame = CGRect(center: CGPoint(x: 25 * one, y: bounds.midY), length: 35 * one)
        capitalLabel.layer.cornerRadius = capitalLabel.frame.height * 0.5
        capitalLabel.layer.borderWidth = 2 * one
        
        titleLabel.frame = CGRect(x: 60 * one, y: 0, width: bounds.width - 100 * one, height: bounds.height)
        arrow.frame = CGRect(center: CGPoint(x: bounds.width - 23 * one, y: bounds.midY), width: 14 * one, height: 15 * one)
        
        // font
        capitalLabel.font = UIFont.systemFont(ofSize: 18 * one, weight: UIFont.Weight.bold)
        titleLabel.font = UIFont.systemFont(ofSize: 16 * one, weight: UIFont.Weight.bold)
    }
}
