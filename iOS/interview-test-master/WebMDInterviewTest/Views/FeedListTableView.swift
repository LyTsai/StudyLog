//
//  FeedListTableView.swift
//  WebMDInterviewTest
//
//  Created by L on 2022/9/14.
//

import Foundation
import UIKit

class FeedListTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setupBasic()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBasic()
    }
    
    // basic setup for table
    fileprivate func setupBasic() {
        self.dataSource = self
        self.delegate = self
        
        if #available(iOS 15, *) {
            self.sectionHeaderTopPadding = 0
        }
    }
    
    fileprivate var feedResponse = FeedResponse()
    func setupWithFeedResponse(_ feed: FeedResponse) {
        self.feedResponse = feed
        self.reloadData()
    }
    
    // data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedResponse.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedItem = feedResponse.items[indexPath.row]
        let feedCell = FeedItemCell.cellWithTable(self, item: feedItem)
        
        return feedCell
    }
    
    // delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedItem = feedResponse.items[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
