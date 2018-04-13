//
//  IntroDetailCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/9.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// introduction of riskMetric
let introDetailCellID = "intro detail cell ID"
class IntroDetailCell: UITableViewCell {
    
    var detailText = "" {
        didSet{
            detailLabel.text = detailText
        }
    }
    
    fileprivate var detailLabel = UILabel()
    
    // more and mask
    fileprivate var more = MoreView()
    
    class func cellWithTableView(_ tableView: UITableView, detailText: String, needMore: Bool) -> IntroDetailCell{
        var cell = tableView.dequeueReusableCell(withIdentifier: introDetailCellID) as? IntroDetailCell
        if cell == nil {
            cell = IntroDetailCell(style: .default, reuseIdentifier: introDetailCellID)
            cell!.setupUI()
        }
        
        cell!.detailText = detailText
        cell!.more.isHidden = !needMore
        
        return cell!
    }
    
    fileprivate func setupUI(){
        backgroundColor = UIColor.clear
        
        detailLabel.backgroundColor = UIColor.clear
        detailLabel.numberOfLines = 0
//        detailLabel.lineBreakMode = .byCharWrapping
        detailLabel.lineBreakMode = .byClipping
  
        
        more.setupMoreView()
        
        addSubview(detailLabel)
        addSubview(more)
        
        selectionStyle = .none
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let margin = 0.072 * bounds.width
        
        detailLabel.frame = CGRect(x: margin, y: 0, width: bounds.width - 2 * margin, height: bounds.height)
        detailLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor)
        more.frame = bounds
        more.rightMargin = margin
    }
}

class MoreView: UIView {
    private let gradientLayer = CAGradientLayer()
    private let label = UILabel()
    private let arrow = UIImageView()
    
    var rightMargin: CGFloat = 0 {
        didSet{
            if rightMargin != oldValue {
                setNeedsLayout()
            }
        }
    }

    func setupMoreView()  {
        gradientLayer.colors = [UIColor.white.withAlphaComponent(0).cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.1, 0.85]
        layer.addSublayer(gradientLayer)
        
        label.text = "More"
        label.textColor = UIColorFromRGB(80, green: 211, blue: 135)
        label.backgroundColor = UIColor.clear
        label.textAlignment = .center
        
        arrow.image = UIImage(named: "arrow_down_green")
        arrow.contentMode = .scaleAspectFit
        
        addSubview(label)
        addSubview(arrow)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds

        let sub = 0.26 * rightMargin * sqrt(2) / 2
        label.frame = CGRect(x: bounds.width - rightMargin * 2.8, y: bounds.height - sub * 4, width: rightMargin * 1.8 - 3 * sub, height: sub * 3)
        arrow.frame = CGRect(x: label.frame.maxX + sub, y: label.frame.midY, width: 2 * sub, height: sub)
        label.font = UIFont.systemFont(ofSize: sub * 2.3)
    }
}
