//
//  ComplementaryCardCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/10/25.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class ComplementaryCardCell: UITableViewCell {
    @IBOutlet weak var matchImageView: UIImageView!
    @IBOutlet weak var idenView: UIView!
    @IBOutlet weak var idenLine: UIView!
    @IBOutlet weak var classificationName: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    class func cellWithTable(_ table: UITableView, imageUrl: URL!, color: UIColor?, name: String?, detail: String?) -> ComplementaryCardCell {
        var cell = table.dequeueReusableCell(withIdentifier: "Complementary Card Cell ID") as? ComplementaryCardCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ComplementaryCardCell", owner: self, options: nil)?.first as? ComplementaryCardCell
            cell?.idenView.layer.backgroundColor = UIColor.black.cgColor
        }
        
        cell?.matchImageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.placeHolder, options: .refreshCached, completed: nil)
        
        cell?.idenView.backgroundColor = color ?? UIColor.clear
        cell?.idenLine.backgroundColor = color ?? UIColor.clear
        cell?.classificationName.text = "\(name ?? "Medium")"
        cell?.detailLabel.text = detail
        return cell!
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let one = bounds.height / 95
        classificationName.font = UIFont.systemFont(ofSize: 12 * one)
        detailLabel.font = UIFont.systemFont(ofSize: 14 * one, weight: .medium)
        idenView.layer.borderWidth = one
    }
}
