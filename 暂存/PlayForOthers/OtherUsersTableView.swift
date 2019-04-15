//
//  IntroPagePseudoUsersTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/15.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// show and search
class OtherUsersTableView: UITableView, UITableViewDataSource {
    var otherUsers = [PseudoUserObjModel]() {
        didSet{
            if otherUsers != oldValue {
                reloadData()
            }
        }
    }
    
    weak var delegateNavi: UINavigationController!
    fileprivate var deletedIndexPath: IndexPath!
    fileprivate var pseudoUser2Backend: PseudoUserAccess!
    class func createWithFrame(_ frame: CGRect) -> OtherUsersTableView {
        let table = OtherUsersTableView(frame: frame, style: .plain)
        
        table.tableFooterView = UIView()
        if table.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            table.separatorInset = UIEdgeInsets.zero
        }
        if table.responds(to: #selector(setter: UIView.layoutMargins)) {
            table.layoutMargins = UIEdgeInsets.zero
        }
        
        table.otherUsers = Array(userCenter.pseudoUsers)
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
        }else {
            cell.contentView.backgroundColor = UIColor.white
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 30 * standHP))
        label.text = "My family and friends"
        label.textColor = heavyGreenColor
        label.font = UIFont.boldSystemFont(ofSize: 16 * fontFactor)
        label.backgroundColor = UIColor.white
        
        return label
    }

}

extension OtherUsersTableView: UITableViewDelegate {
    // select
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedUser = otherUsers[indexPath.row]
        userCenter.currentGameTargetUser.pseudoUser = selectedUser
        
        if delegateNavi != nil {
            let assessVC = CategoryViewController()
//                ABookRiskAssessmentViewController()
            delegateNavi.pushViewController(assessVC, animated: true)
        }
    }
    
    // edit
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // delete
        if editingStyle == .delete {
            deletedIndexPath = indexPath
            // backend
            pseudoUser2Backend = PseudoUserAccess(callback: self)
            
            pseudoUser2Backend.beginApi(self)
            pseudoUser2Backend.deleteOneByKey(key: otherUsers[deletedIndexPath.row].key)
            
            // UI
//            deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (bounds.height - 30 * standHP) / 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30 * standHP
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
}

// data access
extension OtherUsersTableView: DataAccessProtocal {
    func didFinishDeleteDataByKey(_ obj: AnyObject) {
        pseudoUser2Backend.endApi()
        print("delete pseudoUser success")
        if deletedIndexPath != nil {
            let deletedUser = otherUsers[deletedIndexPath.row]
            userCenter.deletePseudoUser(deletedUser.key)
            otherUsers.remove(at: deletedIndexPath.row)
        }
    }
    
    func failedDeleteDataByKey(_ error: String) {
        print(error)
        // TODO: ------- can not delete, because of measurement
        if deletedIndexPath != nil {
            let deletedUser = otherUsers[deletedIndexPath.row]
            userCenter.deletePseudoUser(deletedUser.key)
            otherUsers.remove(at: deletedIndexPath.row)
        }
    }
}
