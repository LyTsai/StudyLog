//
//  HomePageLandingView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/28.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class HomePageLandingView: UIView, LandingProtocol {
    var landing: LandingMainView!
    fileprivate let topLabel = UILabel()
    fileprivate let bottomImageView = UIImageView()
    fileprivate var plateLength: CGFloat = 0
    fileprivate var gap: CGFloat = 0
    let tiltButton = UIButton(type: .custom)
    func createHomePlate(_ frame: CGRect) {
        self.frame = frame
        self.backgroundColor = UIColor.clear

        plateLength = min(bounds.width, bounds.height - 120 * maxOneP)

        // top
        gap = (bounds.height - plateLength) * 0.5
        topLabel.frame = CGRect(x: 0, y: 0, width: width, height: gap)
        topLabel.numberOfLines = 0
        topLabel.textAlignment = .center
        topLabel.textColor = UIColor.white
        
        let topText = "Gamification of Individualized Assessment\n"
        let attributedTop = NSMutableAttributedString(string: topText, attributes: [ .font: UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)])
        attributedTop.append(NSAttributedString(string: "G.I.A.™", attributes: [.font: UIFont.systemFont(ofSize: 24 * fontFactor, weight: .bold)]))
        topLabel.attributedText = attributedTop
        addSubview(topLabel)
        
        // plate
        let plateCenter = CGPoint(x: frame.midX, y: gap + plateLength * 0.5)
        landing = LandingMainView.createWithFrame(bounds, plateLength: plateLength, plateCenter: plateCenter)
        landing.delegate = self
        
        // bottom
        let bottomH = min(width * 0.6 * 21 / 105, gap * 0.65)
        bottomImageView.frame = CGRect(center: CGPoint(x: frame.midX, y: bounds.height - gap * 0.5), width: bottomH / 21 * 105, height: bottomH)
        bottomImageView.contentMode = .scaleAspectFit
        bottomImageView.image = #imageLiteral(resourceName: "tierTag_-1")
        
        // add
        addSubview(bottomImageView)
        addSubview(landing)
        
        // topLabel for tier2
        // splash

        tiltButton.frame = CGRect(x: bounds.width - 50 * fontFactor, y: bottomImageView.frame.midY - 20 * fontFactor, width: 42 * fontFactor, height: 43 * fontFactor) // 45 * 46
        tiltButton.setBackgroundImage(UIImage(named: "landing_titled"), for: .normal)
        tiltButton.addTarget(self, action: #selector(showTiltPlate), for: .touchUpInside)
        addSubview(tiltButton)
    }
    
    func stopTimers() {
        if landing != nil {
            landing.stopTierTwoTimer()
            landing.stopTierThreeTimer()
        }
    }
    
    func focusOnCurrentData()  {
        tiltButton.isHidden = (GameTintApplication.sharedTint.focusingTierIndex == -1)
        landing.focusOnCurrentData()
    }
    
    // ACTIONS
    @objc func showTiltPlate() {
        landing.setTiltState()
        tiltButton.isHidden = true
    }
    
    // delegate
    func landingView(_ view: LandingMainView, tierIsChosen tierIndex: Int) {
        landing.titleLabel.transform = CGAffineTransform.identity
        
        bottomImageView.isHidden = false
        bottomImageView.image = UIImage(named: "tierTag_\(tierIndex)")
        topLabel.isHidden = !landing.tilted
        bottomImageView.isHidden = false
    }
    
    func sliceIsChosen() {
        bottomImageView.isHidden = true
        let offsetH = gap * 0.8
        if landing.transform == .identity {
            UIView.animate(withDuration: 0.3) {
                self.landing.transform = CGAffineTransform(translationX: 0, y: offsetH)
                self.landing.titleLabel.transform = CGAffineTransform(translationX: 0, y: -offsetH)
            }
        }
    }
    
    func landingView(_ view: LandingMainView, chosen button: CustomButton) {
        cardsCursor.selectedRiskClassKey = button.key
        
        // tier 3
        if button.tag >= 300 {
            landing.stopTierThreeTimer()
            
            let selectedIndex = button.tag - 300
            landing.riskClassIsOnShow(selectedIndex)
        }else {
            landing.titleLabel.text = button.itemTitle
            cardsCursor.riskTypeKey = (button.tag / 100 == 1) ? GameTintApplication.sharedTint.iCaKey : GameTintApplication.sharedTint.iPaKey
            goToIntroPageForPlay()
        }
    }
    
    func goToIntroPageForPlay() {
        let riskTypeKey = cardsCursor.riskTypeKey!
        let metricKey = cardsCursor.selectedRiskClassKey!
        let keyString = (riskTypeKey == GameTintApplication.sharedTint.iCaKey) ? "noLongShowFor\(riskTypeKey)\(metricKey)" : "noLongShowFor\(riskTypeKey)"
        
        // should show
        if userDefaults.bool(forKey: keyString) {
            goToNextView()
        }else {
            // show hint
            let typeHint = Bundle.main.loadNibNamed("MetricIntroductionViewController", owner: self, options: nil)?.first as! MetricIntroductionViewController
            typeHint.buttonIsSelected = goToNextView
            typeHint.setupWithRiskType(riskTypeKey, metricKey: metricKey, keyString: keyString)
            viewController.presentOverCurrentViewController(typeHint, completion: nil)
        }
    }
    
    func goToNextView() {
        let riskTypeKey = cardsCursor.riskTypeKey
        let metricKey = cardsCursor.selectedRiskClassKey!
        if riskTypeKey != nil && RiskTypeType.getTypeOfRiskType(riskTypeKey!) == .iFa && userCenter.userState == .login {
            // reach record
            if let iAaRisk = collection.getRiskModelKeys(cardsCursor.selectedRiskClassKey, riskType: GameTintApplication.sharedTint.iAaKey).first {
                let iAaPlayed = selectionResults.getMeasurementsOfRisk(iAaRisk)
                if iAaPlayed.isEmpty {
                    // no record of iAa, play
                    let alert = UIAlertController(title: "No Record", message: "You shold play iAa game first", preferredStyle: .alert)
                    let action1 = UIAlertAction(title: "Check Others", style: .default, handler: { (action) in
                    })
                    let action2 = UIAlertAction(title: "Go to play", style: .default, handler: { (action) in
                        let introPageVC = IntroPageViewController()
                        cardsCursor.riskTypeKey = GameTintApplication.sharedTint.iAaKey
                        self.navigation.pushViewController(introPageVC, animated: true)
                    })
                    alert.addAction(action1)
                    alert.addAction(action2)
                    viewController.present(alert, animated: true, completion: nil)
                    
                    return
                }
            }
            
            // record
            let fulfilled = selectionResults.getAllLocalFulfillsForUser(userCenter.currentGameTargetUser.Key(), metricKey: metricKey)
            let alert = UIAlertController(title: "Fulfillments", message: "numberOfRecord: \(fulfilled.count)", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            })
            alert.addAction(action)
            
            viewController.present(alert, animated: true, completion: nil)
        }else {
            let introPageVC = IntroPageViewController()
            navigation.pushViewController(introPageVC, animated: true)
        }
    }
    
    func arcButtonIsChosen(_ button: CustomButton) {
        cardsCursor.riskTypeKey = button.key
        CardViewImagesCenter.sharedCenter.setupImagesWithRiskType(button.key)
        goToIntroPageForPlay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self.landing)
        let touchedIndex = landing.tierIndexForPoint(point)
        if landing.tilted {
            tiltButton.isHidden = false
            landing.focusOnTier(touchedIndex, selectionIndex: nil)
        }else {
            if point.y < (landing.bounds.height - plateLength) * 0.5 {
                return
            }

            if touchedIndex != -1 && touchedIndex != landing.tierIndex {
                landing.focusOnTier(touchedIndex, selectionIndex: nil)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if landing.arcButtons.transform == CGAffineTransform.identity {
            landing.shakeToRemind()
        }
    }
}
