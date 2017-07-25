//
//  IntroRiskKnowledgeCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/21.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// 4
let introRiskClassKnowledgeID = "Intro RiskClass Knowledge ID"

class IntroRiskClassKnowledgeCell: UITableViewCell {
    
    @IBOutlet weak var knowledgeImageView: UIImageView!
    @IBOutlet weak var articalTitleLabel: UILabel!
    @IBOutlet weak var articalDetailLabel: UILabel!
    
    class func cellWithTableView( _ tableView: UITableView, articalImage: UIImage?, title: String?, publishDate: Date?, authorName: String?) -> IntroRiskClassKnowledgeCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: introRiskClassKnowledgeID) as? IntroRiskClassKnowledgeCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("IntroPageCells", owner: self, options: nil)?[4] as? IntroRiskClassKnowledgeCell
            cell?.knowledgeImageView.layer.borderColor = UIColorFromRGB(214, green: 222, blue: 233).cgColor
            cell?.knowledgeImageView.layer.borderWidth = 1
            cell?.knowledgeImageView.layer.cornerRadius = 8
        }
        
        // data fill
        cell?.fillDataWithArticalImage(articalImage, title: title, publishDate: publishDate, authorName: authorName)
        
        return cell!
    }
    
    fileprivate func fillDataWithArticalImage(_ articalImage: UIImage?, title: String?, publishDate: Date?, authorName: String?) {
        knowledgeImageView.image = articalImage ?? UIImage(named: "news_demo")
        articalTitleLabel.text = title ?? "Related Artical of Current Risk Class"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: publishDate ?? Date())
        let nameString = authorName ?? "Anonymous"
        
        articalDetailLabel.text = "\(dateString) | \(nameString)"
    }
}
