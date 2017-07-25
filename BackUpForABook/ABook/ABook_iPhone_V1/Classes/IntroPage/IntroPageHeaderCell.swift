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
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var watchLabel: UILabel!
    
    // dequeue
    class func cellWithTableView(_ tableView: UITableView, image: UIImage?, name: String?, likeNumber: Int, watchNumber: Int ) -> IntroPageHeaderCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: introHeaderCellID) as? IntroPageHeaderCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("IntroPageCells", owner: self, options: nil)?.first as? IntroPageHeaderCell
            cell?.selectionStyle = .none
            cell?.contentView.backgroundColor = introPageBGColor
        }
        
        cell!.metricImageView.image = image
        cell!.metricNameLabel.text = name
        
        let numFormat = NumberFormatter()
        numFormat.numberStyle = .decimal
        
        cell!.likeLabel.text = numFormat.string(for: likeNumber)
        cell!.watchLabel.text = numFormat.string(for: watchNumber)
        
        return cell!
    }
}
