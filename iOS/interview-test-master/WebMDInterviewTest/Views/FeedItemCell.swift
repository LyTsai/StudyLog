//
//  FeedItemCell.swift
//  WebMDInterviewTest
//
//  Created by L on 2022/9/14.
//

import Foundation
import UIKit

let FeedItemCellID = "Feed Item Cell Identifier"
class FeedItemCell: UITableViewCell {
    fileprivate let itemImage = UIImageView()
    fileprivate let detailTextView = UITextView()
    
    class func cellWithTable(_ table: FeedListTableView, item: FeedItem) -> FeedItemCell {
        var itemCell = table.dequeueReusableCell(withIdentifier: FeedItemCellID) as? FeedItemCell
        if itemCell === nil {
            itemCell = FeedItemCell(style: .subtitle, reuseIdentifier: FeedItemCellID)
            // setup
            itemCell?.setupSubviews()
            itemCell?.configureWithItem(item)
        }
        
        return itemCell!
    }
    
    fileprivate func setupSubviews() {
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        
        // subviews
        itemImage.contentMode = .scaleAspectFit
        
        detailTextView.backgroundColor = UIColor.clear
        detailTextView.isEditable = false
        
        self.contentView.addSubview(itemImage)
        self.contentView.addSubview(detailTextView)
    }
    
    fileprivate func configureWithItem(_ item: FeedItem) {
        itemImage.loadWebImage(item.imageUrl)
        textLabel?.text = item.title
        detailTextLabel?.text = item.description
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        itemImage.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 100)
    }
}
