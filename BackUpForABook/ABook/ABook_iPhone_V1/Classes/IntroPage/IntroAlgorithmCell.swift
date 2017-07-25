//
//  IntroAlgorithmCell.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/9.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// algorithm cell
let introAlgorithmCellID = "intro algorithm cell ID"
let introAlgorithmSelectedCellID = "intro algorithm selected cell ID"
let introAlgorithmNoPicCellID = "intro algorithm selected no pic cell ID"
class IntroAlgorithmCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var stateImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var playNumberLabel: UILabel!

    // selected outlet
    @IBOutlet weak var startGame: UIButton!
    @IBOutlet weak var playForOthers: UIButton!
    @IBOutlet var userTested: [UIImageView]!
    @IBOutlet weak var moreUsers: UIImageView!
    
    // attached RiskObjModel key (or algorithm)
    fileprivate var riskModelKey: String?
    
    // hostTable
    fileprivate weak var hostTable: IntroPageTableView!
    
    // create
    class func cellWithTableView(_ tableView: UITableView, algoKey: String, name: String, authorName: String, latesetDate: Date, liked: Int, played: Int, selected: Bool, testedUsers: [UIImage]) -> IntroAlgorithmCell {
        var cell: IntroAlgorithmCell!
        
        if selected {
            if testedUsers.count == 0 {
                cell = tableView.dequeueReusableCell(withIdentifier: introAlgorithmNoPicCellID) as? IntroAlgorithmCell
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("IntroPageCells", owner: self, options: nil)?[3] as? IntroAlgorithmCell
                }

            }else {
                cell = tableView.dequeueReusableCell(withIdentifier: introAlgorithmSelectedCellID) as? IntroAlgorithmCell
                if cell == nil {
                    cell = Bundle.main.loadNibNamed("IntroPageCells", owner: self, options: nil)?[2] as? IntroAlgorithmCell
                }
            }
            
            // UI setup
            cell!.playForOthers.titleLabel?.numberOfLines = 0
            cell!.playForOthers.titleLabel?.textAlignment = .center
            
            // delegate
            cell!.hostTable = tableView as! IntroPageTableView
         
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: introAlgorithmCellID) as? IntroAlgorithmCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed("IntroPageCells", owner: self, options: nil)?[1] as? IntroAlgorithmCell
           }
        }
        
        cell!.riskModelKey = algoKey
        cell!.selectionStyle = .none
        cell!.stateImageView.transform = CGAffineTransform(rotationAngle: CGFloat(selected ? M_PI : 0))
        cell!.setupWithAlgorithmName(name, authorName: authorName, latesetDate: latesetDate, liked: liked, played: played)
        
        if selected {
            // set images
            cell!.setupTestedUsers(testedUsers)
        }
        
        return cell!
    }
    
    fileprivate func setupWithAlgorithmName(_ name: String, authorName: String, latesetDate: Date, liked: Int, played: Int) {
        nameLabel.text = name
        authorLabel.text = authorName
    
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        dateLabel.text = dateFormat.string(from: latesetDate)
        
        let numFormat = NumberFormatter()
        numFormat.numberStyle = .decimal
        likeLabel.text = numFormat.string(for: liked)
        playNumberLabel.text = numFormat.string(for: played)
    }
    
    fileprivate func setupTestedUsers(_ testedUsers: [UIImage]) {
        if userTested == nil && moreUsers == nil {
            return
        }
        
        if testedUsers.count > 5 {
            moreUsers.isHidden = false
            moreUsers.image = UIImage(named: "icon_etc")
            for i in 0..<5 {
                userTested[i].image = testedUsers[i]
            }
        }else {
            moreUsers.isHidden = true
            for (i, image) in testedUsers.enumerated() {
                userTested[i].image = image
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if userTested != nil && moreUsers != nil {
            for imageView in userTested {
                imageView.image = nil
            }
        }
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        if userTested != nil && moreUsers != nil {
            for view in userTested {
                view.layer.cornerRadius = view.bounds.width * 0.5
                view.layer.masksToBounds = true
            }
        }
        
        // button fontSize
        if startGame != nil && playForOthers != nil {
            let buttonHeight = startGame.bounds.height
            let font = UIFont.systemFont(ofSize: buttonHeight / 4, weight: UIFontWeightSemibold)
            startGame.titleLabel?.font = font
            playForOthers.titleLabel?.font = font
        }

    }
    
    // MARK: ----------------- actions
    // for self
    @IBAction func startTheGame(_ sender: Any) {
        // set risk model (algorithm)
        if riskModelKey != nil {
//            RiskMetricCardsCursor.sharedCursor.setRiskClassModel(riskModelKey!)
            RiskMetricCardsCursor.sharedCursor.focusingRiskKey = riskModelKey!
        }
        
        checkForLogin(true)
        if UserCenter.sharedCenter.userState != .none {
            UserCenter.sharedCenter.setLoginUserAsTarget()
            // logged or default
            let navi = hostTable.hostNavi!
            let riskAssess = ABookRiskAssessmentViewController()
            navi.pushViewController(riskAssess, animated: true)
        }
    }
    

    @IBAction func playForOthers(_ sender: Any) {
        // set risk model (algorithm)
        if riskModelKey != nil {
//            RiskMetricCardsCursor.sharedCursor.setRiskClassModel(riskModelKey!)
            RiskMetricCardsCursor.sharedCursor.focusingRiskKey = riskModelKey!
        }
        checkForLogin(false)
        if UserCenter.sharedCenter.userState != .none {
            let playForOthers = PlayForOthersViewController()
            let navi = hostTable.hostNavi!
            navi.pushViewController(playForOthers, animated: true)
        }
    }
    
    
    // for others
    fileprivate func checkForLogin(_ testForSelf: Bool) {
        if hostTable == nil || hostTable.hostNavi == nil{
            print("not added yet")
            return
        }

        let navi = hostTable.hostNavi!
        
        if UserCenter.sharedCenter.userState == .none {
            // user is not logged in
            // hide tabbar and push the login
            let loginVC = LoginViewController()
            loginVC.testForSelf = testForSelf
            loginVC.naviDelegate = navi
            loginVC.hidesBottomBarWhenPushed = true
            navi.pushViewController(loginVC, animated: true)
        }
    }
}
