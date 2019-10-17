//
//  SettingsViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/4/10.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    fileprivate var settingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingTable = UITableView(frame: mainFrame, style: .plain)
        settingTable.delegate = self
        settingTable.dataSource = self
        settingTable.tableFooterView = UIView()
        settingTable.bounces = false
        
        view.addSubview(settingTable)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Settings"
        
        settingTable.reloadData()
    }
    
    // table
    func numberOfSections(in tableView: UITableView) -> Int {
        return userCenter.userState == .login ? 4 : 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return userCenter.userState == .login ? 3 : 1
        case 1: return 2
        case 2: return 3
        case 3: return 1
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainFont = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        
        // personal
        if indexPath.section == 0 {
            var attributedString: NSAttributedString!
            // user info
            if indexPath.item == 0 {
                if userCenter.userState == .login {
                    // detal or change
                    let titleAttri = NSMutableAttributedString(string: userCenter.loginUserObj.displayName ?? userCenter.loginName, attributes: [.font: UIFont.systemFont(ofSize: 20 * fontFactor, weight: .semibold)])
                    titleAttri.append(NSAttributedString(string: "\nID: \(userCenter.loginUserObj.loginId!)", attributes: [.foregroundColor: UIColorGray(131), .font: UIFont.systemFont(ofSize: 12 * fontFactor, weight: .semibold)]))
                    attributedString = NSAttributedString(attributedString: titleAttri)
                }else {
                    // login
                    let titleAttri = NSMutableAttributedString(string: "You are not logged in", attributes: [.font: UIFont.systemFont(ofSize: 20 * fontFactor, weight: .semibold)])
                    titleAttri.append(NSAttributedString(string: "\nTap to log in", attributes: [.foregroundColor: UIColorGray(131), .font: UIFont.systemFont(ofSize: 12 * fontFactor, weight: .semibold)]))
                    attributedString = NSAttributedString(attributedString: titleAttri)
                }
            }else if indexPath.item == 1 {
                // password
                attributedString = NSAttributedString(string: "Change Password", attributes: [.font: mainFont])
            }else if indexPath.item == 2 {
                // player
                attributedString = NSAttributedString(string: "Players", attributes: [.font: mainFont, .foregroundColor: UIColorFromHex(0x689F38)])
            }
            
            return CustomSimpleIndicatorCell.cellWithTableView(tableView, title: attributedString)
        }else if indexPath.section == 1 {
            if indexPath.item == 0 {
                let switchCell = CustomSwitchCell.cellWithTableView(tableView, title: NSAttributedString(string: "Voice Broadcast", attributes: [.font: mainFont]), isOn: userDefaults.bool(forKey: allowVoiceKey))
                switchCell.switchIsTapped = changeVoiceState
                return switchCell
            }else {
                var versionString = ""
                if let infoDic = Bundle.main.infoDictionary {
                    if let version = infoDic["CFBundleShortVersionString"] {
                        versionString = "\(version)"
                    }
//                    if let build = infoDic["CFBundleVersion"] {
//                        versionString.append("(\(build))")
//                    }
                }
                
                return CustomSubTitleCell.cellWithTableView(tableView, title: NSAttributedString(string: "Version", attributes: [.font: mainFont]), subTitle: NSAttributedString(string: "\(versionString)", attributes: [.font: UIFont.systemFont(ofSize: 16 * fontFactor), .foregroundColor : UIColorGray(130)]))
            }
            
        }else if indexPath.section == 2 {
            // web
            var aboutString = "Terms and Conditions"
            if indexPath.item == 1 {
                aboutString = "Privacy Policy"
            }else if indexPath.item == 2 {
                aboutString = "End-User License Agreement"
            }
            
            return CustomSimpleIndicatorCell.cellWithTableView(tableView, title: NSAttributedString(string: aboutString, attributes: [.font: mainFont]))
        }else {
            // log out
            var logOutCell = tableView.dequeueReusableCell(withIdentifier: "logOutCellID")
            if logOutCell == nil {
                logOutCell = UITableViewCell(style: .default, reuseIdentifier: "logOutCellID")
                logOutCell?.selectionStyle = .none
                logOutCell?.textLabel?.font = mainFont
                logOutCell?.textLabel?.textAlignment = .center
                logOutCell?.textLabel?.textColor = UIColorFromHex(0xFF001F)
                logOutCell?.textLabel?.text = "Log Out"
            }
            
            return logOutCell!
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.item == 0 {
            return 56 * standHP
        }
        return 52 * standHP
    }
    
    // header
    // margin: 20
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: width, height: section == 3 ? 28 * standHP : 43 * standHP))
        header.backgroundColor = UIColorGray(246)
        
        let label = UILabel(frame: header.bounds.insetBy(dx: 12 * standWP, dy: 0))
        label.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)
        label.textColor = UIColorGray(155)
        header.addSubview(label)
        
        var headerTitle = ""
        if section == 0 {
            headerTitle = "Personal Information"
        }else if section == 1 {
            headerTitle = "Account Settings"
        }else if section == 2 {
            headerTitle = "About"
        }
        
        label.text = headerTitle
        
        return header
    
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 3 ? 25 * standHP : 43 * standHP
    }
    
    // action delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // personal
        if indexPath.section == 0 {
            // user info
            if indexPath.item == 0 {
                if userCenter.userState == .login {
                    // detal or change
                    let personl = PersonalInfoDisplayViewController()
                    navigationController?.pushViewController(personl, animated: true)
                }else {
                    // login
                    let login = LoginViewController.createFromNib()
                    navigationController?.pushViewController(login, animated: true)
                }
            }else if indexPath.item == 1 {
                // password
                let changePassword = ChangePasswordViewController.createFromNib()
                navigationController?.pushViewController(changePassword, animated: true)
            }else if indexPath.item == 2 {
                // player
                let player = ABookPlayerViewController.initFromStoryBoard()
                navigationController?.pushViewController(player, animated: true)
            }
        }else if indexPath.section == 1 {
            return
        }else if indexPath.section == 2 {
            // web
            let urlString = "\(pagesBaseUrl)public/About_\(indexPath.item + 2)/"
            let webVC = WebViewDisplayViewController()
            webVC.showGradientBorder = false
            webVC.setupWithUrlString(urlString)
            
            presentOverCurrentViewController(webVC, completion: nil)
        }else if indexPath.section == 3 {
            // log out
            let alert = CatCardAlertViewController()
            alert.addTitle("Are you sure to log out", subTitle: nil, buttonInfo:[("Cancel", false, nil), ("Yes", true, logOut)])
            presentOverCurrentViewController(alert, completion: nil)
        }
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    // methods
    fileprivate func changeVoiceState() {
        userDefaults.set(!userDefaults.bool(forKey: allowVoiceKey), forKey: allowVoiceKey)
        userDefaults.synchronize()
    }
    
    fileprivate func logOut() {
        // go back to first to avoid mistake
        let firstNavi = tabBarController?.viewControllers?.first! as! ABookNavigationController
        for vc in firstNavi.viewControllers {
            if vc.isKind(of: ABookLandingPageViewController.self) {
                firstNavi.popToViewController(vc, animated: true)
                break
            }
        }
        
        userCenter.logOut()
        settingTable.reloadData()
    }
}

