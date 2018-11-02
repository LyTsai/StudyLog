//
//  IntroRiskKnowledgeCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/21.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import SDWebImage
import Kingfisher

// 4
let introRiskClassKnowledgeID = "Intro RiskClass Knowledge ID"

class IntroRiskClassKnowledgeCell: UITableViewCell {
    
    @IBOutlet weak var knowledgeImageView: UIImageView!
    @IBOutlet weak var articalTitleLabel: UILabel!
    @IBOutlet weak var articalDetailLabel: UILabel!
    
    class func cellWithTableView( _ tableView: UITableView, article: ArticleObjModel) -> IntroRiskClassKnowledgeCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: introRiskClassKnowledgeID) as? IntroRiskClassKnowledgeCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("IntroPageCells", owner: self, options: nil)?[2] as? IntroRiskClassKnowledgeCell
            cell?.knowledgeImageView.layer.borderColor = textTintGray.cgColor
            cell?.knowledgeImageView.layer.borderWidth = 1
            cell?.knowledgeImageView.layer.cornerRadius = 8
            cell?.knowledgeImageView.layer.masksToBounds = true
            cell?.selectionStyle = .none
        }
        
        // data fill
        cell?.fillDataWithArtical(article)
        
        return cell!
    }
    
    fileprivate func fillDataWithArtical(_ article: ArticleObjModel) {
        let imageUrl = article.imageUrls.first
        
        knowledgeImageView.sd_setShowActivityIndicatorView(true)
        knowledgeImageView.sd_setIndicatorStyle(.gray)
        knowledgeImageView.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
            if image == nil {
                self.knowledgeImageView.image = ProjectImages.sharedImage.placeHolder
            }
        }
        
        articalTitleLabel.text = article.title ?? "Related Artical of Current Risk Class"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: article.addTime ?? Date())
        let nameString = article.keyword ?? "Anonymous"
        
        articalDetailLabel.text = "\(dateString) | \(nameString)"
    }
}
