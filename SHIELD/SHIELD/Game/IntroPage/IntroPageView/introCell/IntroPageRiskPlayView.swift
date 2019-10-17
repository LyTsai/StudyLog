//
//  IntroPageRiskPlayView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/27.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

// 355 * 258
class IntroPageRiskPlayView: UIView {
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var iconBackView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var playRealButton: UIButton!
    @IBOutlet weak var insightButton: UIButton!
    @IBOutlet weak var whatIfBottomView: UIView!
    @IBOutlet weak var playWhatIfButton: UIButton!
    
    // player
    // loginUser
    @IBOutlet weak var loginUserIcon: UIImageView!
    @IBOutlet weak var loginUserButton: UIButton!
    @IBOutlet weak var loginUserName: UILabel!
    // PseudoUser
    @IBOutlet weak var otherUserIcon: UIImageView!
    @IBOutlet weak var otherUserButton: UIButton!
    @IBOutlet weak var otherUserName: UILabel!
    
    @IBOutlet weak var soundButton: UIButton!
    
    // voice
    @IBOutlet weak var assistView: UIView!
    @IBOutlet weak var voiceHintLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupBasicUI()
    }
    
    // set up
    fileprivate let bubble = TalkBubbleLayer()
    fileprivate func setupBasicUI() {
        // buttons
        playRealButton.titleLabel?.numberOfLines = 0
        playRealButton.titleLabel?.textAlignment = .center
        
        // fonts
        authorNameLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)
        dateLabel.font = UIFont.systemFont(ofSize: 10 * fontFactor)
        
        insightButton.layer.addBlackShadow(4 * fontFactor)
        
        loginUserName.font = UIFont.systemFont(ofSize: 9 * fontFactor)
        otherUserName.font = UIFont.systemFont(ofSize: 9 * fontFactor)
        
        // icon
        iconBackView.layer.cornerRadius = 5 * fontFactor
        
        // voice hint
        voiceHintLabel.font = UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)
        
        bubble.fillColor = UIColor.white.withAlphaComponent(0.95).cgColor
        bubble.strokeColor = UIColorFromHex(0x008E86).cgColor
        bubble.lineWidth = fontFactor
        bubble.addBlackShadow(3 * fontFactor)
        
        assistView.layer.insertSublayer(bubble, at: 0)
    }
    
    fileprivate var riskKey: String!
    fileprivate var allowVoice = true
    func fillDataWithRisk(_ risk: RiskObjModel) {
        riskKey = risk.key
        
        let riskUrl = risk.imageUrl ?? risk.metric?.imageUrl
        iconImageView.sd_setImage(with: riskUrl, placeholderImage: ProjectImages.sharedImage.imagePlaceHolder, options: .refreshCached, completed: nil)
        iconBackView.backgroundColor = collection.getRiskTypeByKey(risk.riskTypeKey)?.realColor ?? tabTintGreen
        
        // labels
        let authorName = risk.authorName ?? "Anonymity"
        let publisher = risk.publisher ?? "AnnielyticX, Inc."
        
        let attributedS = NSMutableAttributedString(string: "Assessment Algorithm and Model based on the research & published work of: ", attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor, weight: .light)])
        attributedS.append(NSAttributedString(string: authorName, attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)]))
        attributedS.append(NSAttributedString(string: "\nGame creator: ", attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor, weight: .light)]))
        attributedS.append(NSAttributedString(string: publisher, attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)]))
        authorNameLabel.attributedText = attributedS
        
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        dateLabel.text = dateFormat.string(from: risk.pubDate ?? Date())
        
        playWhatIfButton.isEnabled = false
        if userCenter.userState == .login {
            let currentUserKey = userCenter.currentGameTargetUser.Key()
            if selectionResults.getLastMeasurementOfUser(currentUserKey, riskKey: riskKey, whatIf: false) != nil {
                playWhatIfButton.isEnabled = true
            }
        }
        
        if let type = collection.getRisk(riskKey).riskTypeKey {
            let riskTypeType = RiskTypeType.getTypeOfRiskType(type)
            let noWhatIf = (riskTypeType == .iCa && riskTypeType == .iRa && riskTypeType == .iPa)
            playWhatIfButton.isHidden = noWhatIf
            whatIfBottomView.isHidden = noWhatIf
        }
        
        allowVoice = userDefaults.bool(forKey: allowVoiceKey)
        soundButton.isSelected = !allowVoice
        
        assistView.isHidden = userDefaults.bool(forKey: "voiceHint")
   
        setupWithUser()
    }
    
    fileprivate func setupWithUser() {
        if userCenter.userState != .login {
            // not log in
            loginUserButton.isSelected = false
            loginUserName.isHidden = true
            loginUserIcon.isHidden = true
            
            // rightPart
            otherUserButton.isSelected = false
            otherUserName.isHidden = true
            otherUserIcon.isHidden = true
        }else {
            let current = userCenter.currentGameTargetUser.Key()
            let isLoginUser = (current == userCenter.loginKey)
            
            // leftPart
            loginUserButton.isSelected = isLoginUser
            loginUserName.isHidden = !isLoginUser
            loginUserIcon.isHidden = !isLoginUser
            
            // rightPart
            otherUserButton.isSelected = !isLoginUser
            otherUserName.isHidden = isLoginUser
            otherUserIcon.isHidden = isLoginUser
            
            // dataFill
            let currentInfo = userCenter.currentGameTargetUser.userInfo()
            if isLoginUser {
                loginUserIcon.image = currentInfo?.imageObj ?? ProjectImages.sharedImage.tempAvatar
            }else {
                otherUserIcon.image = currentInfo?.imageObj ?? ProjectImages.sharedImage.tempAvatar
                otherUserName.text = currentInfo?.displayName
            }
        }
    }
   
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.layoutSubviews()
        for view in backView.subviews {
            view.layoutSubviews()
        }
        
        loginUserIcon.layer.cornerRadius = loginUserIcon.frame.width * 0.5
        otherUserIcon.layer.cornerRadius = otherUserIcon.frame.width * 0.5
        
        // bubble
        assistView.layoutSubviews()
        let top = assistView.bounds.height * 0.5
        let triE = assistView.bounds.height * 0.3
        bubble.setLeftBubbleWithFrame(assistView.bounds, bubbleRadius: top * 0.2, topSpace: (top - triE * 0.5), triE: triE, triH: voiceHintLabel.frame.minX)

        setNeedsDisplay()
    }
    
    // Actions
    @IBAction func playForSelf(_ sender: Any) {
        if userCenter.userState != .login {
            let loginVC = LoginViewController.createFromNib()
            loginVC.invokeFinishedClosure = setupWithUser
            loginVC.hidesBottomBarWhenPushed = true
            navigation.pushViewController(loginVC, animated: true)
        }else {
            userCenter.setLoginUserAsTarget()
            setupWithUser()
        }
    }
    
    @IBAction func chooseOthers(_ sender: Any) {
        if userCenter.userState != .login {
            let loginVC = LoginViewController.createFromNib()
            loginVC.invokeFinishedClosure = goToChooseOthers
            loginVC.hidesBottomBarWhenPushed = true
            navigation.pushViewController(loginVC, animated: true)
        }else {
            goToChooseOthers()
        }
        
    }
    
    fileprivate func goToChooseOthers() {
        let playerVC = ABookPlayerViewController.initFromStoryBoard()
        navigation.pushViewController(playerVC, animated: true)
    }
    
    
    @IBAction func playForReal(_ sender: Any) {
        playGame(false)
    }
    
    @IBAction func playForVirtual(_ sender: Any) {
        let alert = StateSwitchAlertController()
        alert.chooseForContinue = playVirtual
        viewController.presentOverCurrentViewController(alert, completion: nil)
    }
    fileprivate func playVirtual() {
        playGame(true)
    }
    
    func playGame(_ whatIf: Bool) {
        WHATIF = whatIf
        
        if userCenter.userState != .login {
            let loginVC = LoginViewController.createFromNib()
            loginVC.invokeFinishedClosure = goToCategoryViewController
            loginVC.hidesBottomBarWhenPushed = true
            navigation.pushViewController(loginVC, animated: true)
        }else {
            goToCategoryViewController()
        }
        
    }
    
    fileprivate func goToCategoryViewController() {
        if riskKey != nil {
            cardsCursor.focusingRiskKey = riskKey!
            
            let loadTool = GroupedCardsAndRecordLoadTool()
            loadTool.loadForRisk(riskKey, loadingOn: viewController) { (success) in
                if success {
                    let riskAssess = CategoryViewController()
                    self.navigation?.pushViewController(riskAssess, animated: true)
                }else {
                    // failed
                    let errorAlert = UIAlertController(title: "Error!!!", message: "Net Error", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "Go Back and Retry", style: .cancel, handler: {
                        (reload) in
        
                    })
                    errorAlert.addAction(cancelAction)
                    self.viewController.present(errorAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func goToInsight(_ sender: Any) {
        
    }
    
    @IBAction func setVoice(_ sender: Any) {
        allowVoice = !allowVoice
        soundButton.isSelected = !allowVoice
        
        userDefaults.set(allowVoice, forKey: allowVoiceKey)
        userDefaults.synchronize()
        
        hideVoiceHint()
    }
    
    @IBAction func hideAssistBubbule(_ sender: Any) {
        hideVoiceHint()
    }
    
    @objc func hideVoiceHint() {
        userDefaults.set(true, forKey: "voiceHint")
        userDefaults.synchronize()
        assistView.isHidden = true
    }
    
    override func draw(_ rect: CGRect) {
        let topColor = UIColorFromHex(0x429321)
        let topPath = UIBezierPath()
        topPath.lineWidth = 8 * fontFactor
        topPath.move(to: CGPoint(x: 0, y: 0))
        topPath.addLine(to: CGPoint(x: bounds.width, y: 0))
        topColor.setStroke()
        topPath.stroke()
        
        let bottomColor = UIColorFromHex(0x8BC34A)
        let bottomPath = UIBezierPath()
        bottomPath.lineWidth = 10 * fontFactor
        bottomPath.move(to: CGPoint(x: 0, y: bounds.height))
        bottomPath.addLine(to: CGPoint(x: bounds.width, y: bounds.height))
        bottomColor.setStroke()
        bottomPath.stroke()
    }
}
