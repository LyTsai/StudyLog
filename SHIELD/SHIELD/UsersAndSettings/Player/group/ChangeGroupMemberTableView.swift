//
//  ChangeGroupMemberTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/10.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ChangeGroupMemberTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
    }
    
    var members: [String] {
        return Array(chosenMemebers)
    }
    
    
    fileprivate var pseudoUsers: [String] {
        return userCenter.pseudoUserKeys
    }
    
    fileprivate var userData = [String]()
    fileprivate var chosenMemebers = Set<String>()
    
    func setForReadOnly(_ readOnly: Bool) {
        allowsSelection = !readOnly
    }
    
    func updateWithMembers(_ memebers: [String]) {
        for member in memebers {
            chosenMemebers.insert(member)
        }
        
        // data source array
        userData = members
        var unchosen = [String]()
        for user in pseudoUsers {
            if !chosenMemebers.contains(user) {
                unchosen.append(user)
            }
        }
        
        userData.append(contentsOf: unchosen)
        reloadData()
    }

    func chooseRow(_ row: Int) {
        let userKey = userData[row]
        if chosenMemebers.contains(userKey) {
            chosenMemebers.remove(userKey)
        }else {
            chosenMemebers.insert(userKey)
        }
        reloadRows(at: [IndexPath(row: row, section: 0)], with: .automatic)
    }
    
    // cell
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userKey = userData[indexPath.row]
        let cell = GroupMemberDisplayCell.cellWithTableView(self, member: userKey, chosen: members.contains(userKey), row: indexPath.row, readOnly: !allowsSelection)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60 * fontFactor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chooseRow(indexPath.row)
    }

    
    // header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = AddPeopleOrGroupView.createFromNib()
        header.usedToAdd(.addMembers)
        return header
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 95 * standWP
    }
}


