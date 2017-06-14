//
//  IntroIndicatorsCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/9.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let introIndicatorsCellID = "intro indicators cell ID"
// buttons of pages
class IntroIndicatorsCell: UITableViewCell {
    var pageNames = ["indi_cards", "indi_summary", "indi_overall", "indi_advice"]

    class func cellWithTableView(_ tableView: UITableView) -> IntroIndicatorsCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: introIndicatorsCellID) as? IntroIndicatorsCell
        if cell == nil {
            cell = IntroIndicatorsCell(style: .default, reuseIdentifier: introIndicatorsCellID)
            cell!.addViews()
            cell!.selectionStyle = .none
        }
        
        return cell!
    }
    
    fileprivate var imageViews = [UIImageView]()
    fileprivate var arrows = [UIImageView]()
    fileprivate var textLabels = [UILabel]()
    
    fileprivate var count: Int {
        return pageNames.count
    }
    
    fileprivate func addViews() {
        backgroundColor = UIColor.clear
        
        for (i, name) in pageNames.enumerated() {
            let imageView = UIImageView(image: UIImage(named: name))
            imageViews.append(imageView)
            addSubview(imageView)
            
            let label = UILabel()
            label.text = name
            label.textColor = introPageFontColor
            label.textAlignment = .center
            textLabels.append(label)
            addSubview(label)
            
            if i != count - 1 {
                let arrow = UIImageView(image: UIImage(named: "arrow_right"))
                addSubview(arrow)
                arrows.append(arrow)
            }
        }
    }
    
    // layoutSubviews
    fileprivate let arrowRatio: CGFloat = 0.516
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let pageWidth = 0.15 * bounds.width
        let pageHeight = pageWidth / 0.5622
        
        let vMargin = 0.045 * bounds.height
        let hMargin = 0.114 * bounds.width
        let hGap = (bounds.width - hMargin * 2 - pageWidth * CGFloat(count)) / CGFloat(count - 1)
        
        // imageViews(buttons)
        for (i, imageView) in imageViews.enumerated() {
            let x = hMargin + CGFloat(i) * (hGap + pageWidth)
            imageView.frame = CGRect(x: x, y: vMargin, width: pageWidth, height: pageHeight)
            
            // labels
            let label = textLabels[i]
            let labelHeight = bounds.height - imageView.frame.maxY - vMargin
            label.font = UIFont.systemFont(ofSize: labelHeight / 3)
            label.frame = CGRect(x: x, y: vMargin + pageHeight, width: pageWidth, height: labelHeight)
            
            // arrows
            let arrowWidth = hGap * 0.59
            if i != count - 1 {
                let arrow = arrows[i]
                arrow.frame = CGRect(x: imageView.frame.maxX + (hGap - arrowWidth) * 0.5, y: imageView.frame.midY - arrowWidth * arrowRatio * 0.5, width: arrowWidth, height: arrowWidth * arrowRatio)
            }
        }
        
    }
}
