//
//  GroupDisplayCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/10.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

let groupDisplayCellID = "group Display Cell Identifier "
class GroupDisplayCell: UITableViewCell {
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var groupImageView: UIImageView!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    fileprivate var group: UserGroupObjModel!
    fileprivate weak var groupsTable: GroupsTableView!
    class func cellWithTableView(_ table: GroupsTableView, group: UserGroupObjModel) -> GroupDisplayCell {
        var cell = table.dequeueReusableCell(withIdentifier: groupDisplayCellID) as? GroupDisplayCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("GroupDisplayCell", owner: self, options: nil)?.first as? GroupDisplayCell
            cell?.setupBasic()
        }
        
        cell?.groupsTable = table
        cell?.group = group
        cell?.groupNameLabel.text = group.name
        
        return cell!
    }
    
    fileprivate func setupBasic() {
        mainBackView.layer.cornerRadius = 4 * fontFactor
        mainBackView.layer.borderColor = UIColorFromHex(0x71B3AE).cgColor
        mainBackView.layer.borderWidth = fontFactor
    }
    
    @IBAction func deleteGroup(_ sender: Any) {
        let deleteAlert = CatCardAlertViewController()
        deleteAlert.addTitle("Delete Group", subTitle: "All data will be deleted for this group", buttonInfo: [("Cancel", false, nil), ("Continue", true, delete)])
        
        viewController.presentOverCurrentViewController(deleteAlert, completion: nil)
    }
    
    fileprivate func delete() {
        self.groupsTable.deleteGroup(self.group.key)
    }
    
    @IBAction func editGroup(_ sender: Any) {
        let editGroup = Bundle.main.loadNibNamed("UserGroupInfoViewController", owner: self, options: nil)?.first as! UserGroupInfoViewController
        editGroup.setupGroup(group)
        navigation?.pushViewController(editGroup, animated: true)
    }
}
