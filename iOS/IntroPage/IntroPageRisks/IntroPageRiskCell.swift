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
let introPageRisksCellID = "introPage risks cell identifier"
class IntroPageRiskCell: UICollectionViewCell {
    var hostView: IntroPageRisksView!
    
    @IBOutlet var playStateImageView: UIImageView!
    @IBOutlet var riskNameLabel: UILabel!
    @IBOutlet var authorNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var likeLabel: UILabel!
    @IBOutlet var playedNumberLabel: UILabel!
    @IBOutlet var playForElseButton: UIButton!
    @IBOutlet var playForSelfButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupBasicUI()
    }
    
    fileprivate func setupBasicUI() {
        
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
        if likeLabel != nil {
            likeLabel.font = UIFont.systemFont(ofSize: 10 * fontFactor)
            playedNumberLabel.font = UIFont.systemFont(ofSize: 10 * fontFactor)
        }
    }
    
    
    fileprivate var riskKey: String!
    func configureWithRisk(_ risk: RiskObjModel)  {
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

        if likeLabel != nil {
            let numFormat = NumberFormatter()
            numFormat.numberStyle = .decimal
            likeLabel.text = numFormat.string(for: 930)
            playedNumberLabel.text = numFormat.string(for: 1100)
        }
        
    }

    // Actions
    @IBAction func playForSelf(_ sender: Any) {
        // set risk model (algorithm)
        if riskKey != nil {
            RiskMetricCardsCursor.sharedCursor.focusingRiskKey = riskKey!
        }
        
        checkForLogin(ModeForShowingLoginVc.abookRiskAssessment)
        if UserCenter.sharedCenter.userState != .none {
            UserCenter.sharedCenter.setLoginUserAsTarget()
            // logged or default
            let navi = hostView.hostVC.navigationController
            let riskAssess = CategoryViewController()
            navi?.pushViewController(riskAssess, animated: true)
        }
    }
    @IBAction func playForElse(_ sender: Any) {
        // set risk model (algorithm)
        if riskKey != nil {
            RiskMetricCardsCursor.sharedCursor.focusingRiskKey = riskKey!
        }
        checkForLogin(ModeForShowingLoginVc.playForOthers)
        if UserCenter.sharedCenter.userState != .none {
            let playForOthers = PlayForOthersViewController()
            let navi = hostView.hostVC.navigationController
            navi?.pushViewController(playForOthers, animated: true)
        }
    }


    // for others
    fileprivate func checkForLogin(_ modeForShowingLoginVc: ModeForShowingLoginVc) {
        if hostView == nil || hostView.hostVC == nil{
            print("not added yet")
            return
        }

        let navi = hostView.hostVC.navigationController
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
