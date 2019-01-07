//
//  UserSelectionTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
import Foundation
let userCellID = "user Cell Identifier"
class UserSelectionTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
//    weak var seeHowHostVC: SeeHowViewController!
    weak var hostVC: MultipleUserViewController!
    fileprivate var loginUser = true
    fileprivate var pseudoUsers: [PseudoUserObjModel]!
    fileprivate var chosenUserKey: String!
    fileprivate var chosenIndexPath: IndexPath!
    
    class func createWithFrame(_ frame: CGRect, users: [Bool: [PseudoUserObjModel]], chosenUserKey: String) -> UserSelectionTableView {
        let table = UserSelectionTableView(frame: frame, style: .plain)
        // data
        if users[true] != nil {
            table.loginUser = true
        }else {
            table.loginUser = false
        }
        table.pseudoUsers = users[table.loginUser]!
        table.chosenUserKey = chosenUserKey
        
        if UserCenter.sharedCenter.loginUserObj.key == chosenUserKey {
            table.chosenIndexPath = IndexPath(item: 0, section: 0)
        }else {
            for (i, user) in table.pseudoUsers.enumerated() {
                if user.key == chosenUserKey {
                    table.chosenIndexPath = IndexPath(item: i, section: table.loginUser ? 1 : 0)
                }
            }
        }
  
        // seperator line
        if table.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            table.separatorInset = UIEdgeInsets.zero
        }
        if table.responds(to: #selector(setter: UIView.layoutMargins)) {
            table.layoutMargins = UIEdgeInsets.zero
        }
        table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        
        // delegate
        table.delegate = table
        table.dataSource = table
        
        return table
    }
    
    // dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return loginUser ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // user answered
        if loginUser && section == 0 {
            return 1
        }else {
            return pseudoUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: userCellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: userCellID)
            cell?.textLabel?.textColor = lightGreenColor
            cell?.backgroundColor = UIColor.clear
            cell?.contentView.backgroundColor = UIColor.clear
            cell?.selectionStyle = .none
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 12)
        }
        
        cell?.accessoryType = .none
        if loginUser && indexPath.section == 0 {
            cell?.textLabel?.text = "My Cards"
            if UserCenter.sharedCenter.loginUserObj.key == chosenUserKey {
                cell?.accessoryType = .checkmark
                chosenIndexPath = indexPath
            }
        }else {
            cell?.textLabel?.text = pseudoUsers[indexPath.row].name
            if chosenUserKey == pseudoUsers[indexPath.row].key {
                cell?.accessoryType = .checkmark
                chosenIndexPath = indexPath
            }
        }
        
        return cell!
    }
    
    // delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 35
        }
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // remove later
        if chosenIndexPath == nil {
            print("some set up is wrong!!!!!!!")
            return
        }
    
        if indexPath != chosenIndexPath {
            if loginUser && indexPath.section == 0 {
                chosenUserKey = UserCenter.sharedCenter.loginUserObj.key
            }else {
                chosenUserKey = pseudoUsers[indexPath.row].key
            }
            
            // ui
            tableView.reloadRows(at: [chosenIndexPath, indexPath], with: .automatic)
            chosenIndexPath = indexPath
            
            // vc
            if hostVC != nil {
                hostVC.reloadWithUserKey(chosenUserKey)
            }
        }
    }
}
