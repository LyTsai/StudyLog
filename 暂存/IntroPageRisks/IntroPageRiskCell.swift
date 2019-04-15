//
//  IntroPageRiskCell.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/22.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

// 375 * 138
let introPageRiskCellID = "introPage risk cell identifier"
class IntroPageRiskCell: UITableViewCell {
    var hostTable: IntroPageRisksTableView!
    
    @IBOutlet var playStateImageView: UIImageView!
    @IBOutlet var riskNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var playedNumberLabel: UILabel!
    @IBOutlet var playForElseButton: UIButton!
    @IBOutlet var playForSelfButton: UIButton!
    
    class func cellWithTableView(_ tableView: UITableView, risks: [RiskObjModel]) -> IntroPageRiskCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: introPageRiskCellID) as? IntroPageRiskCell
        if cell == nil {
            // IntroPageRiskCell
            cell = Bundle.main.loadNibNamed("IntroPageRiskCell", owner: self, options: nil)?.first as? IntroPageRiskCell
            cell?.setupBasicUI()
        }
        
        cell?.fillDateWithRisk(risk)
        
        return cell!
    }
    
    fileprivate func setupBasicUI() {
        selectionStyle = .none
        
        // buttons
        playForSelfButton.titleLabel?.numberOfLines = 0
        playForSelfButton.titleLabel?.textAlignment = .center
        playForElseButton.titleLabel?.numberOfLines = 0
        playForElseButton.titleLabel?.textAlignment = .center
    
        // fonts
        playForSelfButton.titleLabel?.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: UIFontWeightBold)
        playForElseButton.titleLabel?.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: UIFontWeightBold)
        
        riskNameLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: UIFontWeightSemibold)
        authorNameLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor)
        dateLabel.font = UIFont.systemFont(ofSize: 10 * fontFactor)
        
        likeLabel.font = UIFont.systemFont(ofSize: 10 * fontFactor)
        playedNumberLabel.font = UIFont.systemFont(ofSize: 10 * fontFactor)
        
    }
    
    fileprivate var riskKey: String!
    fileprivate func fillDateWithRisk(_ risk: RiskObjModel) {
        riskKey = risk.key
        
        // star
        let number = CardSelectionResults.cachedCardProcessingResults.getNumberOfCardsPlayedForUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), riskKey: riskKey)
        playStateImageView.image = (number == 0) ? #imageLiteral(resourceName: "star_played_un") : #imageLiteral(resourceName: "star_played")
        
        // labels
        riskNameLabel.text = risk.name
        authorNameLabel.text = "Game published by: \(risk.author?.name ?? "AnnielyticX")"
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        dateLabel.text = dateFormat.string(from: Date())
        
        let numFormat = NumberFormatter()
        numFormat.numberStyle = .decimal
        likeLabel.text = numFormat.string(for: 930)
        playedNumberLabel.text = numFormat.string(for: 1100)
    }
    
 

    
    // Actions
    @IBAction func playForElse(sender: UIButton) {
        // set risk model (algorithm)
        if riskKey != nil {
            RiskMetricCardsCursor.sharedCursor.focusingRiskKey = riskKey!
        }
        checkForLogin(ModeForShowingLoginVc.playForOthers)
        if UserCenter.sharedCenter.userState != .none {
            let playForOthers = PlayForOthersViewController()
            let navi = hostTable.hostVC.navigationController
            navi?.pushViewController(playForOthers, animated: true)
        }
    }
    @IBAction func playForSelf(sender: UIButton) {
        // set risk model (algorithm)
        if riskKey != nil {
            RiskMetricCardsCursor.sharedCursor.focusingRiskKey = riskKey!
        }
        print(riskKey)
        
        checkForLogin(ModeForShowingLoginVc.abookRiskAssessment)
        if UserCenter.sharedCenter.userState != .none {
            UserCenter.sharedCenter.setLoginUserAsTarget()
            // logged or default
            let navi = hostTable.hostVC.navigationController
            let riskAssess = CategoryViewController()
            navi?.pushViewController(riskAssess, animated: true)
        }
    }
    
    // for others
    fileprivate func checkForLogin(_ modeForShowingLoginVc: ModeForShowingLoginVc) {
        if hostTable == nil || hostTable.hostVC == nil{
            print("not added yet")
            return
        }

        let navi = hostTable.hostVC.navigationController
        if UserCenter.sharedCenter.userState == .none {
            // user is not logged in
            // hide tabbar and push the login
            let loginVC = LoginViewController()
            loginVC.modeForShowingLoginVc = modeForShowingLoginVc
            loginVC.hidesBottomBarWhenPushed = true
            navi?.pushViewController(loginVC, animated: true)
        }
    }
}
