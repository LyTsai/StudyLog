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
        
    }
    
    fileprivate func configureWithItem(_ item: FeedItem) {
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // adjust?
    }
}
