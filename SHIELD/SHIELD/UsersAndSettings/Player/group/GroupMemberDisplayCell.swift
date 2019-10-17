//
//  GroupMemberDisplayCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/12.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

let groupMemberDisplayCellID = "group Member Display Cell Identifier"
class GroupMemberDisplayCell: UITableViewCell {
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    weak var changeMemberTable: ChangeGroupMemberTableView!
    fileprivate var row: Int!
    class func cellWithTableView(_ table: ChangeGroupMemberTableView, member: String, chosen: Bool, row: Int, readOnly: Bool) -> GroupMemberDisplayCell {
        var cell = table.dequeueReusableCell(withIdentifier: groupMemberDisplayCellID) as? GroupMemberDisplayCell
        if cell == nil {
            cell = Bundle.main.loadNibNamed("PlayerDisplayCell", owner: self, options: nil)?[1] as? GroupMemberDisplayCell
            cell?.backgroundColor = UIColor.clear
        }
        
        cell?.addButton.isSelected = chosen
        cell?.addButton.isUserInteractionEnabled = !readOnly
        cell?.changeMemberTable = table
        cell?.row = row
        cell?.setupWithUserKey(member)
        
        return cell!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    
        avatar.layer.cornerRadius = avatar.bounds.midX
        
        let one = fontFactor
        nameLabel.font = UIFont.systemFont(ofSize: 12 * one, weight: .medium)
        subLabel.font = UIFont.systemFont(ofSize: 11 * one, weight: .medium)
    }
    
    fileprivate func setupWithUserKey(_ userKey: String) {
        if let user = userCenter.getPseudoUser(userKey) {
            avatar.image = user.imageObj ?? ProjectImages.sharedImage.tempAvatar
            nameLabel.text = user.name
            subLabel.text = user.sex ?? "Unset"
        }
    }
    
    @IBAction func buttonIsChanged(_ sender: Any) {
        changeMemberTable.chooseRow(row)
    }
}
