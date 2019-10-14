//
//  PersonalInfoDisplayViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/10.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class PersonalInfoDisplayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate var infoTable: UITableView!
    fileprivate var userAccountService: UserAccess!
    
    // show on this view
    fileprivate var nameInputView: UserNameInputView!
    fileprivate var dobInputView: UserBirthDateInputView!
    fileprivate var genderInputView: UserGenderInputView!
    fileprivate var overallInputView: UserOverallInputView!
    fileprivate var duringChange = -1
    fileprivate var user = UserObjModel()
    fileprivate var details = UserInfoObjModel()
    fileprivate var loading: LoadingViewController!
    
    fileprivate var confirmButton: GradientBackStrokeButton!
    fileprivate var giveUp: GradientBackStrokeButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // back
        let backButton = createBackButton()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        user = userCenter.loginUserObj
        details = userCenter.loginUserObj.details()
        view.backgroundColor = UIColor.white
        
        let buttonY = height - bottomLength - 55 * fontFactor
        let buttonSize = CGSize(width: 140 * fontFactor, height: 45 * fontFactor)
        giveUp = GradientBackStrokeButton(frame: CGRect(x: width * 0.5 - buttonSize.width - 10 * fontFactor, y: buttonY, width: buttonSize.width, height: buttonSize.height))
        confirmButton = GradientBackStrokeButton(frame: CGRect(x: width * 0.5 + 10 * fontFactor, y: buttonY, width: buttonSize.width, height: buttonSize.height))
        confirmButton.addTarget(self, action: #selector(change), for: .touchUpInside)
        giveUp.addTarget(self, action: #selector(giveUpChange), for: .touchUpInside)
        
        confirmButton.setupWithTitle("Save")
        giveUp.setupWithTitle("Resign")
        giveUp.isSelected = false
        
        view.addSubview(confirmButton)
        view.addSubview(giveUp)
        
        // table
        infoTable = UITableView(frame: mainFrame, style: .plain)
        infoTable.delegate = self
        infoTable.dataSource = self
        infoTable.tableFooterView = UIView()
        infoTable.bounces = false
        
        view.addSubview(infoTable)
    }
    
    @objc func change() {
        if duringChange == 0 {
            details.displayName = nameInputView.userName
        }else if duringChange == 1 {
            details.sex = genderInputView.sexString
        }else if duringChange == 2 {
            details.dobString = dobInputView.dobString
        }else if duringChange == 3 {
            details.state = overallInputView.result.rawValue
        }
        
        infoTable.reloadRows(at: [IndexPath(item: duringChange, section: 0)], with: .automatic)
        showTableView()
    }
    
    @objc func giveUpChange() {
        showTableView()
    }
    
    fileprivate func showTableView() {
        if duringChange == 0 {
            nameInputView.isHidden = true
        }else if duringChange == 1 {
            genderInputView.isHidden = true
        }else if duringChange == 2 {
            dobInputView.isHidden = true
        }else if duringChange == 3 {
            overallInputView.isHidden = true
        }
        infoTable.isHidden = false
        duringChange = -1
    }
    
    override func backButtonClicked() {
        if duringChange != -1 {
            change()
        }else {
            if nameInputView != nil {
                let current = user.displayName ?? ""
                if current != nameInputView.userName {
                    checkChange()
                    return
                }
            }

            if genderInputView != nil {
                if let genderString = genderInputView.sexString {
                    if user.sex == nil || user.sex != genderString {
                        checkChange()
                        return
                    }
                }
            }
            
            if dobInputView != nil {
                let dobString = dobInputView.dobString
                if user.dobString == nil || user.dobString != dobString {
                    checkChange()
                    return
                }
            }
            
            
            if overallInputView != nil {
                if let result = overallInputView.result {
                    if user.state == nil || user.state != result.rawValue {
                        checkChange()
                        return
                    }
                }
            }
            
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    fileprivate func checkChange() {
        let alert = CatCardAlertViewController()
        alert.addTitle("You have changed some information. Are your sure to update?", subTitle: nil, buttonInfo:[("Cancel", false, resignChange), ("Update", true, updateUser)])
        presentOverCurrentViewController(alert, completion: nil)
    }
    
    fileprivate func updateUser() {
        if userAccountService == nil {
            userAccountService = UserAccess(callback: self)
        }
        
        if nameInputView != nil {
            user.displayName = nameInputView.userName
        }
        
        if dobInputView != nil {
            user.dobString = dobInputView.dobString
        }
        
        if genderInputView != nil {
            user.sex = genderInputView.sexString
        }
        
        if overallInputView != nil {
            user.state = overallInputView.result?.rawValue
        }
        
        loading = LoadingViewController()
        present(loading, animated: true) {
            self.userAccountService.updateOneByKey(key: self.user.key, oneData: self.user)
        }
    }
    
    fileprivate func resignChange() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Personal Information"
        
    }
    
    // table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainFont = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        let subFont = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)
        let subColor = UIColorGray(155)
        var titleString = ""
        var subTitle: NSAttributedString!

        if indexPath.item == 0 {
            titleString = "Name"
            subTitle = NSAttributedString(string: details.displayName ?? "", attributes: [.font: subFont, .foregroundColor: subColor])
        }else if indexPath.item == 1 {
            titleString = "Gender"
            if let sex = details.sex {
                subTitle = NSAttributedString(string: sex, attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor), .foregroundColor: subColor])
//                let isMale = !sex.localizedCaseInsensitiveContains("f")
//                subTitle = NSAttributedString(string: sex, attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor), .foregroundColor: isMale ? UIColorFromHex(0x00B0FF) : UIColorFromHex(0xFF2700)])
            }
        }else if indexPath.item == 2 {
            titleString = "Born In"
            if let date = CalendarCenter.getDateFromString(details.dobString) {
                subTitle = NSAttributedString(string: "\(CalendarCenter.getYearOfDate(date))", attributes: [.font: subFont, .foregroundColor: subColor])
            }
        }else {
            titleString = "Overall Health"
            if let state = details.state {
                let stateS = NSTextAttachment()
                var stateImage = #imageLiteral(resourceName: "state_poor")
                if state.localizedStandardContains("good") {
                    stateImage = #imageLiteral(resourceName: "state_good")
                }else if state.localizedStandardContains("ok") {
                    stateImage = #imageLiteral(resourceName: "state_ok")
                }
                
                stateS.image = stateImage
                stateS.bounds = CGRect(x: 0, y: 0, width: 22 * fontFactor, height: 22 * fontFactor)
                
                let stateA = NSAttributedString(attachment: stateS)
                let stateMA = NSMutableAttributedString(attributedString: stateA)
                stateMA.append(NSAttributedString(string: "    \(state)", attributes: [.font: subFont, .foregroundColor: subColor]))
                subTitle = NSAttributedString(attributedString: stateMA)
            }
        }
        
        return CustomRightDetailIndicatorCell.cellWithTableView(tableView, title: NSAttributedString(string: titleString, attributes: [.font: mainFont]), subTitle: subTitle)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 56 * standHP
    }
    
    
    // action delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        duringChange = indexPath.item
        
        let mainBounds = CGRect(x: 0, y: topLength, width: width, height: height - 55 * fontFactor - bottomLength - topLength).insetBy(dx: 20 * fontFactor, dy: 15 * fontFactor)
        // personal
        if indexPath.item == 0 {
            if nameInputView == nil {
                nameInputView = UserNameInputView(frame: mainBounds)
                view.addSubview(nameInputView)
            }else {
                nameInputView.isHidden = false
            }
            
            // setup
            nameInputView.setName(details.displayName ?? "")
        }else if indexPath.item == 1 {
            if genderInputView == nil {
                genderInputView = UserGenderInputView(frame: mainBounds)
                view.addSubview(genderInputView)
            }else {
                genderInputView.isHidden = false
            }
            
            if details.sex != nil {
                genderInputView.isMale = !details.sex!.localizedCaseInsensitiveContains("f")
            }
        }else if indexPath.item == 2 {
            if dobInputView == nil {
                dobInputView = UserBirthDateInputView(frame: mainBounds)
                view.addSubview(dobInputView)
            }else {
                dobInputView.isHidden = false
            }
            
            if let dobString = details.dobString {
                dobInputView.setDateOfBirth(dobString)
            }
        }else {
            if overallInputView == nil {
                overallInputView = UserOverallInputView(frame: mainBounds)
                view.addSubview(overallInputView)
            }else {
                overallInputView.isHidden = false
            }
            
            if let state = details.state {
                overallInputView.setupWithState(state)
            }
        }
        
        infoTable.isHidden = true
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

extension PersonalInfoDisplayViewController: DataAccessProtocal  {
    func didFinishUpdateDataByKey(_ obj: AnyObject) {
        if localDB.database.open() {
            user.saveToLocalDatabase()
        }
        loading.dismiss(animated: true) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func failedUpdateDataByKey(_ error: String) {
        print(error)
        
        loading.dismiss(animated: true) {
            let alert = CatCardAlertViewController()
            alert.addTitle("Failed to update", subTitle: nil, buttonInfo:[("Cancel", false, self.resignChange), ("Try Aagin", true, self.updateUser)])
            self.presentOverCurrentViewController(alert, completion: nil)
        }
    }
}
