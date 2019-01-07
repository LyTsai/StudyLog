//
//  UserPullDown.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/12/9.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation

// user target the risk model applied for.  each risk mode is "played" by a user onto another user.  For example, doc A applys AHA CVD model (author AHA) onto his patient user B
let userCellIdentifier = "ModelTargetUserIdentifier"

class UserCell: UITableViewCell {
    var userInfoView: UserInfoView!
    
    class func cellWithTableView(_ tableView: UITableView, userInfo: UserInfoModel) -> UserCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: userCellIdentifier) as? UserCell
        if cell == nil {
            cell = UserCell(style: .default, reuseIdentifier: userCellIdentifier)
            cell!.userInfoView = UserInfoView.createUserInfoViewWithUserInfo(userInfo)
            cell!.addSubview(cell!.userInfoView)
        }
        cell!.userInfoView.userInfo = userInfo
        
        return cell!
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        userInfoView.frame = bounds
    }
}

class UserPullDownTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    weak var assessmentDelegate: AssessmentInfoView!
    
    fileprivate var loginUser: UserModel {
        return UserCenter.sharedCenter.loginUser
    }
    
    var pseudoUsers: [PseudoUserModel] {
        return UserCenter.sharedCenter.pseudoUsers
    }
    
    var loginSelected = true

    class func createPullDownTableWithFrame(_ frame: CGRect, loginSelected: Bool) -> UserPullDownTableView {
        let table = UserPullDownTableView(frame: frame, style: .plain)

        table.loginSelected = loginSelected
        
        table.dataSource = table
        table.delegate = table
        
        table.backgroundColor = UIColor.white
        table.separatorColor = UIColor.clear
        
        return table
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        return pseudoUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return UserCell.cellWithTableView(tableView, userInfo: UserCenter.sharedCenter.loginUserInfo)
        }
        
        let cell = UserCell.cellWithTableView(tableView, userInfo: pseudoUsers[indexPath.row].details!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            loginSelected = true
            UserCenter.sharedCenter.currentGameTargetUser.set2registertedUser(loginUser)
        }else {
            loginSelected = false
            UserCenter.sharedCenter.currentGameTargetUser.set2pseudoUser(pseudoUsers[indexPath.row])
        }
        
        if assessmentDelegate != nil {
            assessmentDelegate.selectUser()
        }
//        assessmentDelegate.updateUserWithTargetUser(targetUsers[indexPath.row])
    }
    
    

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let numberOnShow = min(pseudoUsers.count + 1, 4)
        return bounds.height / CGFloat(numberOnShow)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return nil
        }
        
        // add for the pseudoUsers
        let footerFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: 20))
        
        let footer = UIView(frame: footerFrame)
        footer.backgroundColor = selectedCellBackColor
        let button = UIButton(frame: footerFrame.insetBy(dx: 10, dy: 2))
        button.setTitle("add user", for: UIControlState())
        button.titleLabel?.textColor = UIColor.black
        button.addTarget(self, action: #selector(addUser), for: .touchUpInside)
        footer.addSubview(button)
        
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0
        }
        return 20
    }
    
    func addUser()  {
        // TODO: --------- shold also support image-add and gender-selection
        let alertController = UIAlertController(title: "add new user", message: nil, preferredStyle: .alert)
        alertController.addTextField { (nameTextField) in
            nameTextField.placeholder = "Name"
        }
        alertController.addTextField { (ageTextField) in
            ageTextField.placeholder = "Age"
        }
        
        let addAction = UIAlertAction(title: "Save", style: .default) { (action) in
            // save
//            let simpleInfo = UserInfoModel.createUserInfo(<#T##address: String?##String?#>, age: <#T##NSNumber?#>, city: <#T##String?#>, country: <#T##String?#>, email: <#T##String?#>, name: <#T##String?#>, profession: <#T##String?#>, race: <#T##String?#>, state: <#T##String?#>, sex: <#T##String?#>, image: <#T##UIImage?#>)
            
            let userInfo = UserInfoModel()
            userInfo.name = alertController.textFields!.first!.text!
            UserCenter.sharedCenter.addDefaultPseudoUser(userInfo)
            
//            let targetUser = CardTargetUser()
//            targetUser.displayName = alertController.textFields!.first!.text!
//            
//            self.assessmentDelegate.updateUserWithTargetUser(targetUser)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action) in
            // cancel, do nothing
        }
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        let next = assessmentDelegate.topAssessmentDelegate.superview?.next as! ABookRiskAssessmentViewController
        next.present(alertController, animated: true, completion: nil)
    }
}

