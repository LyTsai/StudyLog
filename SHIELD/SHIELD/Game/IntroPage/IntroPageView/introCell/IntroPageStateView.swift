//
//  IntroPageStateView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/27.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class IntroPageStateView: UIView {
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var riskNameLabel: UILabel!
    @IBOutlet weak var answerInfoLabel: UILabel!
    @IBOutlet weak var processView: CustomProcessView!
    
    @IBOutlet weak var processImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var checkButton: GradientBackStrokeButton!
    
    @IBOutlet weak var notPlayView: UIView!
    
    fileprivate var riskKey: String!
    
    // create
    override func awakeFromNib() {
        super.awakeFromNib()
        updateUI()
    }
    
    fileprivate func updateUI() {
        processView.processColor = UIColorFromRGB(126, green: 211, blue:33)
        processView.layer.masksToBounds = true
        
        checkButton.setupWithTitle("See Previous Result")
        checkButton.isSelected = false
        
        riskNameLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)
        answerInfoLabel.font = UIFont.systemFont(ofSize: 10 * fontFactor)
        descriptionLabel.font = UIFont.systemFont(ofSize: 11 * fontFactor, weight: .light)
        checkButton.titleLabel?.font = UIFont.systemFont(ofSize: 12 * fontFactor)
    }
    fileprivate var lastMeasurement: MeasurementObjModel!
    func setupWithRisk(_ risk: RiskObjModel) {
        self.riskKey = risk.key
        
        let allCards = collection.getAllDisplayCardsOfRisk(riskKey)
        let answered = MatchedCardsDisplayModel.getCurrentMatchedCardsFromCards(allCards).count // may be some cards from other games
    
        if allCards.isEmpty || answered == 0 {
            notPlayView.isHidden = false
            return
        }
        
        // show view
        notPlayView.isHidden = true
        // image
        let cardImageUrl = allCards.first?.getDisplayOptions().first!.match?.imageUrl
        cardImageView.sd_setImage(with: cardImageUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, completed: nil)
        
        // record
        if userCenter.userState == .login {
            lastMeasurement = selectionResults.getLastMeasurementOfUser(userCenter.currentGameTargetUser.Key(), riskKey: riskKey, whatIf: false)
            let userName = userCenter.currentGameTargetUser.userInfo().name ?? "Played"
            answerInfoLabel.text = "\(userName) : \(answered) / \(allCards.count)"
        }
        
        // play info
        if lastMeasurement != nil {
            checkButton.isHidden = false
            let lastDate = ISO8601DateFormatter().date(from: lastMeasurement.timeString)!
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, yyyy"
            let lastTime = formatter.string(from: lastDate)

            let allAnsweredText = "You have completed playing this game previously on \(lastTime). You can choose to play this game again for yourself or play for someone else. Or you can play “What-if” to test drive lifestyle changes"
            let partAnsweredText = "You have not finished this game yet. You can continue or try other games."
            
            descriptionLabel.text = (answered == allCards.count) ? allAnsweredText : partAnsweredText
        }else {
            checkButton.isHidden = true
            descriptionLabel.text = "There is no record for this game."
        }
       
        // text
        riskNameLabel.text = risk.name
        
        // info
        processView.processVaule = CGFloat(answered) / CGFloat(allCards.count)
        processImageView.isHidden = (answered != allCards.count)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        processView.layer.cornerRadius = processView.bounds.height * 0.5
        checkButton.layer.cornerRadius = min(checkButton.bounds.height * 0.5, 8 * fontFactor)
    }
    // action
    @IBAction func checkScorecard(_ sender: Any) {
        cardsCursor.focusingRiskKey = riskKey
        
        if lastMeasurement != nil {
            let scoreCardVC = Bundle.main.loadNibNamed("ScoreCardViewController", owner: self, options: nil)?.first as! ScoreCardViewController
            scoreCardVC.setupWithMeasurement(lastMeasurement)
            navigation.pushViewController(scoreCardVC, animated: true)
        }
    }
}
