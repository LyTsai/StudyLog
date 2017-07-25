//
//  IntroPagePseudoUsersTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/15.
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
        let tested = CardSelectionResults.cachedCardProcessingResults.gamePlayed(user.key)
        
        cell!.userInfoView.setupUserInfoView(details.imageObj, userName: details.name, lastDate: Date(), tested: tested)
       
        return cell!
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userInfoView.frame = bounds
    }
    
}

// show and search
class OtherUsersTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var otherUsers = [PseudoUserObjModel]()
        {
        didSet{
            if otherUsers != oldValue {
                reloadData()
            }
        }
    }
    
    weak var delegateNavi: UINavigationController!
    class func createWithFrame(_ frame: CGRect) -> OtherUsersTableView {
        let table = OtherUsersTableView(frame: frame, style: .plain)
        
        table.tableFooterView = UIView()
        if table.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            table.separatorInset = UIEdgeInsets.zero
        }
        if table.responds(to: #selector(setter: UIView.layoutMargins)) {
            table.layoutMargins = UIEdgeInsets.zero
        }
        
        table.otherUsers = Array(UserCenter.sharedCenter.pseudoUserList.values)
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    // dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return otherUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = OtherUserCell.cellWithTableView(tableView, user: otherUsers[indexPath.row])
        if indexPath.row % 2 == 0 {
            cell.contentView.backgroundColor = introPageBGColor
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 30))
        label.text = "My family and friends"
        label.textColor = heavyGreenColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.backgroundColor = UIColor.white
        
        return label
    }
    
    // height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (bounds.height - 30) / 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = otherUsers[indexPath.row]
        UserCenter.sharedCenter.currentGameTargetUser.pseudoUser = selectedUser
        
        if delegateNavi != nil {
            let assessVC = ABookRiskAssessmentViewController()
            delegateNavi.pushViewController(assessVC, animated: true)
        }
    }
}
