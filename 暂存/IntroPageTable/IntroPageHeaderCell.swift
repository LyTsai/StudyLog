//
//  IntroPageHeaderCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let introHeaderCellID = "intro header cell ID"

class IntroPageHeaderCell: UITableViewCell {
    // outlet
    @IBOutlet weak var metricImageView: UIImageView!
    @IBOutlet weak var metricNameLabel: UILabel!
    @IBOutlet weak var riskTypeLabel: UILabel!
    
    // dequeue
    class func cellWithTableView(_ tableView: UITableView, imageUrl: URL?, name: String?, typeName: String?) -> IntroPageHeaderCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: introHeaderCellID) as? IntroPageHeaderCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("IntroPageCells", owner: self, options: nil)?.first as? IntroPageHeaderCell
            cell?.selectionStyle = .none
            cell?.contentView.backgroundColor = introPageBGColor
            
            cell?.metricNameLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: UIFontWeightSemibold)
            cell?.riskTypeLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: UIFontWeightMedium)
        }
        
        // image
        cell!.metricImageView.sd_setShowActivityIndicatorView(true)
        cell!.metricImageView.sd_setIndicatorStyle(.gray)
        cell!.metricImageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
            if image == nil {
                cell!.metricImageView.image = ProjectImages.sharedImage.placeHolder
            }
        }
        
        cell!.metricNameLabel.text = name
        cell!.riskTypeLabel.text = typeName
        
       
        
        return cell!
    }
    

}
