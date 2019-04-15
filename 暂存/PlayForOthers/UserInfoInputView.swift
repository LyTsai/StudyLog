//
//  UserInfoInputView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/3/6.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
struct UserInfoResult {
    var name = ""
    var relationship: (UIImage, String)!
    var age: Int!
    var isMale: Bool!
    var race: String!
    var overallHealth: HealthState!
}

class UserInfoInputTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    weak var hostVC: UserInfoInputViewController!
    
    var saveButton = UIButton(type: .custom)
    var userInfoResult = UserInfoResult() {
        didSet{
            // name and relationship is finished, and the save button can be touched
            if userInfoResult.name != "" && userInfoResult.relationship != nil  {
//            if userInfoResult.name != "" && userInfoResult.age != nil && userInfoResult.isMale != nil && userInfoResult.race != nil && userInfoResult.overallHealth != nil {
                // all is set
                saveButton.setTitleColor(processColor, for: .normal)
                saveButton.isUserInteractionEnabled = true
            }
        }
    }
    
    let lineEdgeInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 10)
    
    // newly created pseudoUser
    var newPseudoUser: PseudoUserObjModel?
    
    class func createWith(_ frame: CGRect) -> UserInfoInputTableView {
        let table = UserInfoInputTableView(frame: frame, style: .plain)
        table.allowsSelection = false
        
        if table.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            table.separatorInset = table.lineEdgeInset
        }
        if table.responds(to: #selector(setter: UIView.layoutMargins)) {
            table.layoutMargins = table.lineEdgeInset
        }
        
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0: return UserInfoNameCell.cellWith(tableView)
        case 2: return UserInfoAgeCell.cellWith(tableView)
        case 3: return UserInfoGenderCell.cellWith(tableView)
        case 4: return UserInfoRaceCell.cellWith(tableView)
        case 5: return UserInfoOverallHealthCell.cellWith(tableView)
        default: return UserInfoRelationshipCell.cellWith(tableView)
        }
        
    }
    
    var footerHeight: CGFloat {
        return 50 * bounds.height / 543
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: footerHeight))
        footer.backgroundColor = UIColor.white
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(unProcessColor, for: .normal)
        saveButton.isUserInteractionEnabled = false
        saveButton.addTarget(self, action: #selector(addPeople), for: .touchUpInside)
        saveButton.frame = CGRect(x: bounds.midX - 40, y: 0, width: 80, height: footerHeight)
        footer.addSubview(saveButton)
        
        return footer
    }
    
    // delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let standardW = bounds.width / 365
        switch indexPath.row {
        case 0: return 100 * standardW
        case 1: return 145 * standardW
        case 5: return 130 * standardW
        default: return 81 * standardW
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return footerHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = lineEdgeInset
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = lineEdgeInset
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //endEditing(true)
        
        let nameCell = cellForRow(at: IndexPath(row: 0, section: 0)) as? UserInfoNameCell
        if nameCell != nil {
            nameCell!.endInput()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       // endEditing(true)
        
        let nameCell = cellForRow(at: IndexPath(row: 0, section: 0)) as? UserInfoNameCell
        if nameCell != nil {
            nameCell!.endInput()
        }
    }
    // save, active when none of the parameters is nil
    fileprivate var pseudoUser2Backend: PseudoUserAccess!
    func addPeople()  {
        // get answers
        var gender: String!
        if userInfoResult.isMale != nil {
            gender = (userInfoResult.isMale == true ? "Male" : "Female")
        }else {
            gender = "Not Told"
        }
    
        newPseudoUser = PseudoUserObjModel()
        
        newPseudoUser!.key = UUID().uuidString
        //newPseudoUser!.dob = Date() - userInfoResult.age
        newPseudoUser!.name = userInfoResult.name
        newPseudoUser!.sex = gender
        newPseudoUser!.race = userInfoResult.race
        newPseudoUser!.userKey = userCenter.loginUserObj.key
        
        // icons
        let relationship = userInfoResult.relationship
        newPseudoUser!.imageObj = relationship?.0
        
        pseudoUser2Backend = PseudoUserAccess(callback: self)
        pseudoUser2Backend.beginApi(self)
        pseudoUser2Backend.addOne(oneData: newPseudoUser!)
    }
}

extension UserInfoInputTableView: DataAccessProtocal {
    func didFinishAddDataByKey(_ obj: AnyObject) {
        pseudoUser2Backend.endApi()
        if newPseudoUser != nil {
            print("add pseudoUser success")
            userCenter.addOrChangePseudoUser(newPseudoUser!)
            
            if hostVC != nil {
                let tableVC = hostVC.playForOthersDelegate.othersTable!
                tableVC.otherUsers.append(newPseudoUser!)
                //            tableVC.insertRows(at: [IndexPath(row: tableVC.otherUsers.count - 1, section: 0)], with: .automatic)
                
                hostVC.dismissVC()
            }
        }
     }
    
    func failedAddDataByKey(_ error: String) {
        print(error)
    }
}
