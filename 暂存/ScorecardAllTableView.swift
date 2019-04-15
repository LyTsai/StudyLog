//
//  ScorecardAllTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/7/2.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardAllTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource = self
        tableFooterView = UIView()
    }
    
    fileprivate var riskKey: String!
    fileprivate var userKey: String!
    func setupWithRiskKey(_ riskKey: String, userKey: String) {
        self.riskKey = riskKey
        self.userKey = userKey
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ScorecardBarCell.cellWithTable(tableView, riskKey: riskKey, userKey: userKey, forCard: indexPath.item != 0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return bounds.height * 0.5
    }
}
