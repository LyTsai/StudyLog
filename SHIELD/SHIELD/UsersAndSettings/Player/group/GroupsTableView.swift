//
//  GroupsTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/6.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class GroupsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dataSource = self
        self.delegate = self
    }

    var groups = [UserGroupObjModel]()
    
    func deleteGroup(_ key: String) {
        var index = 0
        for (i, group) in groups.enumerated() {
            if group.key == key {
                index = i
                break
            }
        }
        userCenter.deleteUserGroup(key)
        groups.remove(at: index)
        deleteRows(at: [IndexPath(row: index, section: 1)], with: .left)
    }
    
    // dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return indexPath.section == 0 ? UITableViewCell() : GroupDisplayCell.cellWithTableView(self, group: groups[indexPath.item])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 0.01 : 65 * fontFactor
    }
    
    // header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = AddPeopleOrGroupView.createFromNib()
            header.usedToAdd(.addGroup)
            
            return header
        }else {
            let search = UIView()
            search.backgroundColor = UIColorFromHex(0xAEEBE7)
            return search
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 92 * standWP : 30 * fontFactor
    }
}
