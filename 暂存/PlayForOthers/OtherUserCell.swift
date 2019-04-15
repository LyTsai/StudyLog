//
//  OtherUserCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/21.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let otherUserCellID = "other user cell ID"
class OtherUserCell: UITableViewCell {
    
    var userInfoView = PlayForOthersUserInfoView.createUserInfoView(nil, userName: nil, lastDate: Date(), tested: [])
    class func cellWithTableView(_ tableView: UITableView, user: PseudoUserObjModel) -> OtherUserCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: otherUserCellID) as? OtherUserCell
        if cell == nil {
            cell = OtherUserCell(style: .default, reuseIdentifier: otherUserCellID)
            cell!.userInfoView.backgroundColor = UIColor.clear
            cell!.contentView.addSubview(cell!.userInfoView)
        }
        
        let details = user.details()
        
        // recently "played" games by user
        let tested = [RiskObjModel]()
        cell!.userInfoView.setupUserInfoView(user.imageObj, userName: details.name, lastDate: Date(), tested: tested)
        
        return cell!
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userInfoView.frame = bounds
    }
    
}
