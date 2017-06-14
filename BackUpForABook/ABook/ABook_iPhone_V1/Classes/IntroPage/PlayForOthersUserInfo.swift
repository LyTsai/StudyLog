//
//  IntroPageUserInfo.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/14.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class PlayForOthersUserInfoView: UIView {
    
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var lastDateLabel: UILabel!
    
    @IBOutlet weak var recentGamesView: RecentGamesCollectionView!
    
    class func createUserInfoView(_ userIcon: UIImage?, userName: String?, lastDate: Date?, tested: [RiskObjModel]) -> PlayForOthersUserInfoView {
        let userInfoView = Bundle.main.loadNibNamed("PlayForOthersViews", owner: self, options: nil)?.first as! PlayForOthersUserInfoView
        userInfoView.setupUserInfoView(userIcon, userName: userName, lastDate: lastDate, tested: tested)
        
        return userInfoView
    }
    
    func setupUserInfoView(_ userIcon: UIImage?, userName: String?, lastDate: Date?, tested: [RiskObjModel]) {
        // setup and use default
        userIconView.image = userIcon ?? UIImage(named: "userIcon")!
        userNameLabel.text = userName ?? "Not Given"
        
        // date
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        lastDateLabel.text = (lastDate == nil ? "Not Tested Yet" : dateFormat.string(from: lastDate!))
        
        // games
        recentGamesView.games = tested
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        layoutIfNeeded()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        userIconView.layer.cornerRadius = userIconView.bounds.width / 2
        userIconView.layer.masksToBounds = true
    }
}


