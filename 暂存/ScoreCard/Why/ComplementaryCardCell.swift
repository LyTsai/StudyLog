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
    @IBOutlet weak var classificationName: UILabel!
    
    class func cellWithTable(_ table: UITableView, imageUrl: URL!, color: UIColor?, name: String?) -> ComplementaryCardCell {
        var cell = table.dequeueReusableCell(withIdentifier: "Complementary Card Cell ID") as? ComplementaryCardCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("ComplementaryCardCell", owner: self, options: nil)?.first as? ComplementaryCardCell
        }
        
        cell?.matchImageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.placeHolder, options: .refreshCached, completed: nil)
        
        cell?.idenView.backgroundColor = color ?? UIColor.clear
        
        let attributedS = NSMutableAttributedString(string: "Relative Risk Level:\n", attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)])
        attributedS.append(NSAttributedString(string: "\(name ?? "Medium")", attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor)]))
        
        cell?.classificationName.attributedText = attributedS
        
        return cell!
    }
    
    

}
