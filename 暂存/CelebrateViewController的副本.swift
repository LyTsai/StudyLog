//
//  CelebrateViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/20.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CelebrateViewController: UIViewController, LandingProtocol {
    weak var presentFromVC: UIViewController!
    
    // private
    fileprivate let dismissButton = UIButton(type: .custom)
    fileprivate let backView = UIView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        modalPresentationStyle = .overCurrentContext
        
        // back
        backView.backgroundColor = UIColor.white
        backView.layer.cornerRadius = 8
        // dismiss
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.rectCrossDismiss, for: .normal)
        
        // play
        playOtherRisk.addTarget(self, action: #selector(playOtherRiskCards), for: .touchUpInside)
    }

    // unloading data
    func showActivity() {
        backView.removeFromSuperview()
    }
    
    func showCelebrate() {
        for sub in view.subviews {
            sub.removeFromSuperview()
        }
        
        // white back
        let backFrame = CGRect(x: 15 * standWP, y: 100 * standHP, width: width - 30 * standWP, height: height - bottomLength - 120 * standHP)
        backView.frame = backFrame
        view.addSubview(backView)
        
        // person
        let personImageView = UIImageView(image: UIImage(named: "celebrate_icon"))
        personImageView.frame = CGRect(x: 9 * standWP, y: -59 * standHP, width: 133 * standWP, height: 148 * standHP)
        personImageView.contentMode = .scaleAspectFit
        backView.addSubview(personImageView)
        
        // dismiss
        dismissButton.frame = CGRect(x: backFrame.width - 36 * standWP, y: 10 * standHP, width: 26 * standWP, height: 26 * standWP)
        backView.addSubview(dismissButton)
        
        // congratatulations
        let titleLabel = UILabel(frame: CGRect(x: 50 * standWP, y: 20 * standHP, width: backFrame.width - 100 * standWP, height: 54 * standHP))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "Congratulations\n\(UserCenter.sharedCenter.loginUserObj.displayName ?? "To You")!"
        titleLabel.font = UIFont.systemFont(ofSize: 22 * standHP, weight: UIFontWeightBold)
        titleLabel.shadowColor = UIColor.white
        titleLabel.shadowOffset = CGSize(width: -2, height: 0)
        
        backView.addSubview(titleLabel)
        
        let options = ["Play a new game", "Different Options", "Play For Someone Else", "Put into Action"]
        var buttons = [CustomButton]()
        for i in 0..<options.count {
            let button = CustomButton(type: .custom)
            button.setBackgroundImage(UIImage(named: "cong_\(i)"), for: .normal)
            buttons.append(button)
            backView.addSubview(button)
        }
        
        let leftHeight = backView.frame.height - titleLabel.frame.maxY

        
        let cursor = RiskMetricCardsCursor.sharedCursor
        
        let r = min(backView.bounds.width, leftHeight) * 0.5
        
        let riskIcon = cursor.focusingRisk.imageUrl
        let riskIconView = UIImageView(frame: CGRect(center: CGPoint(x: backView.bounds.midX, y: titleLabel.frame.maxY + r), length: 50 * standWP))
        riskIconView.sd_setImage(with: riskIcon, placeholderImage: ProjectImages.sharedImage.placeHolder, options: .refreshCached, completed: nil)
        backView.addSubview(riskIconView)
        
        ButterflyLayout.layoutEvenCircleWithRootFrame(riskIconView.frame, children: buttons, radius: r * 0.6, startAngle: 0, expectedLength: 56 * standWP)
        
        for (i, option) in options.enumerated() {
            let desLabel = UILabel()
            desLabel.text = option
            let button = buttons[i]
            button.addSubview(desLabel)
            desLabel.frame = CGRect(x: -20 * standWP, y: -20 * standWP, width: button.bounds.width + 40 * standWP, height: 18 * standWP)
            desLabel.font = UIFont.systemFont(ofSize: 14 * standWP)
            desLabel.numberOfLines = 0
            if i == 1 {
                let collection = AIDMetricCardsCollection.standardCollection
                let numberOfRisks = collection.getModelsOfRiskClass(cursor.selectedRiskClassKey!, riskTypeKey: cursor.riskTypeKey).count
                if numberOfRisks == 1 {
                    desLabel.textColor = UIColorGray(187)
                    button.isEnabled = false
                }
            }
        }
        
        // option
       
        
    }
    
    

    // MARK: -------- new design
    fileprivate let playOtherRisk = UIButton.customActButton("Different Opinions")
    func showCelebrateB() {
        for sub in view.subviews {
            sub.removeFromSuperview()
        }
        
        // white back
        let backFrame = CGRect(x: 15 * standWP, y: 150 * standHP, width: width - 30 * standWP, height: 375 * standHP)
        backView.frame = backFrame
        view.addSubview(backView)
        
        let gradientLayer = CAGradientLayer()
        backView.layer.addSublayer(gradientLayer)
        gradientLayer.colors = [tabTintGreen.cgColor, UIColor.white.cgColor]
        gradientLayer.locations = [0.3, 0.8]
        gradientLayer.cornerRadius = 8
        
        // person
        let personImageView = UIImageView(image: UIImage(named: "celebrate_icon"))
        personImageView.frame = CGRect(x: 9 * standWP, y: -59 * standHP, width: 133 * standWP, height: 148 * standHP)
        personImageView.contentMode = .scaleAspectFit
        backView.addSubview(personImageView)
        
        // dismiss
        dismissButton.frame = CGRect(x: backFrame.width - 36 * standWP, y: 10 * standHP, width: 26 * standWP, height: 26 * standWP)
        backView.addSubview(dismissButton)

        // congratatulations
        let titleLabel = UILabel(frame: CGRect(x: 50 * standWP, y: 20 * standHP, width: backFrame.width - 100 * standWP, height: 54 * standHP))
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = "Congratulations\n\(UserCenter.sharedCenter.loginUserObj.displayName ?? "To You")!"
        titleLabel.font = UIFont.systemFont(ofSize: 22 * standHP, weight: UIFontWeightBold)
        titleLabel.shadowColor = UIColor.white
        titleLabel.shadowOffset = CGSize(width: -2, height: 0)

        backView.addSubview(titleLabel)
        
        // other riskType
        let collection = AIDMetricCardsCollection.standardCollection
        let cursor = RiskMetricCardsCursor.sharedCursor
        
        let windowView = UIView(frame: CGRect(x: 0, y: titleLabel.frame.maxY + 8 * standHP, width: backFrame.width, height: 220 * standHP))
        backView.addSubview(windowView)
        windowView.clipsToBounds = true
        
        let landing = LandingMainView.createWithFrame(CGRect(x: 0, y: 0, width: windowView.frame.width, height: windowView.frame.height * 2), plateLength: windowView.frame.width * 0.8)
        landing.delegate = self
        windowView.addSubview(landing)
        
        
        // play new
        var currentY = windowView.frame.maxY + 10 * standHP
        let currentX = 68 * standWP
        let playSize = CGSize(width: backFrame.width - 2 * currentX, height: 38 * standHP)

        // play other risk
        playOtherRisk.adjustActButtonWithFrame(CGRect(origin: CGPoint(x: currentX, y: currentY), size: playSize))
        backView.addSubview(playOtherRisk)
        
        let numberOfRisks = collection.getModelsOfRiskClass(cursor.selectedRiskClassKey!, riskTypeKey: cursor.riskTypeKey).count
        if numberOfRisks == 1 {
            let lockImageView = UIImageView(image: UIImage(named: "end_lock"))
            lockImageView.frame = CGRect(center: CGPoint(x: playOtherRisk.frame.maxX + playSize.height * 0.65, y: playOtherRisk.frame.midY), length: playSize.height * 0.65)
            backView.addSubview(lockImageView)
            playOtherRisk.isEnabled = false
        }
        
        currentY += playSize.height * 1.5
        
        // to act?


        // adjust frame is necessary
        backView.frame = CGRect(x: backFrame.minX, y: backFrame.minY, width: backFrame.width, height: currentY + 20 * standHP)
        gradientLayer.frame = backView.bounds
    }
    
    func goToGame(_ button: CustomButton)  {
        RiskMetricCardsCursor.sharedCursor.riskTypeKey = button.key
        RiskTypeDisplayModel.sharedRiskType.setupWithKey(button.key)
        
        // button is selected
        button.isSelected = true
        holdAndPush(IntroPageViewController())
    }

    func playOtherRiskCards()  {
        holdAndPush(IntroPageViewController())
    }
    
    // MARK: --------------------- actions
    // dismiss and pushVC
    fileprivate func holdAndPush(_ vc: UIViewController) {
        if presentFromVC != nil {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.dismissVC()
                self.presentFromVC.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func goToViewController(_ viewController: UIViewController) {
        self.dismissVC()
        self.presentFromVC.navigationController?.pushViewController(viewController, animated: true)
    }

}

// for button
extension UIButton {
    class func customActButton(_ text: String) -> UIButton {
        let normalBack = UIImage(named: "act_normal")
        let selectedBack = UIImage(named: "act_selected")
        let disabledBack = UIImage(named: "act_disabled")
        
        let button = UIButton.customCenterTextButton(text, textColor: UIColor.black, selectedTextColor: UIColor.black, backImage: normalBack, selectedBackImage: selectedBack)
        button.setTitleColor(UIColorGray(155), for: .disabled)
        button.setBackgroundImage(disabledBack, for: .disabled)
    
        return button
    }
    
    func adjustActButtonWithFrame(_ frame: CGRect) {
        self.frame = frame
        let margin = frame.height * 0.15
        titleEdgeInsets = UIEdgeInsets(top: 0, left: margin, bottom: frame.height * 0.08, right: margin)
        titleLabel?.font = UIFont.systemFont(ofSize: frame.height * 0.42, weight: UIFontWeightSemibold)
    }
}
