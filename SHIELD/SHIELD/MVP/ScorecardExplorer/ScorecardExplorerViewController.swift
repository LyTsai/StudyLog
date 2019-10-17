//
//  ScorecardExplorerViewController.swift
//  AnnielyticX
//
//  Created by L on 2019/4/25.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardExplorerViewController: UIViewController {
    fileprivate var topButtons = [UIButton]()
    fileprivate var topMasks = [UIImageView]()
    fileprivate var boards = [LandingMainView]()
    fileprivate let backImageView = UIImageView(image: ProjectImages.sharedImage.landingBack)
    fileprivate let dismiss = UIButton(type: .custom)
    fileprivate var backButton: UIButton!
    fileprivate let scorecardView = ScorecardDisplayAllView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Scorecard Explorer"
        
        backButton = createBackButton()
        dismiss.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        dismiss.setBackgroundImage(UIImage(named: "dismiss_white"), for: .normal)
        dismiss.addTarget(self, action: #selector(hideScorecard), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: dismiss)
        dismiss.isHidden = true
        
        view.layer.contents = ProjectImages.sharedImage.categoryBack?.cgImage
        
        // setup
        let gapY = 5 * fontFactor
        let gapX = 8 * fontFactor
        let topH = 45 * fontFactor
        
        // buttons
        let buttonGap = gapY
        let oneLength = (width - 2 * gapX - 2 * buttonGap) / 3
        for i in 0..<3 {
            // 119 * 45
            let topButton = UIButton(type: .custom)
            topButton.tag = 100 + i
            topButton.setBackgroundImage(UIImage(named: "IA_\(i)"), for: .normal)
            
            // frame
            topButton.setScaleAspectFrameInConfine(CGRect(x: gapX + CGFloat(i) * (oneLength + buttonGap), y: gapY + topLength, width: oneLength, height: topH), widthHeightRatio: 119 / 45)
            topButton.addTarget(self, action: #selector(focusOnIndex), for: .touchUpInside)
            view.addSubview(topButton)
            topButtons.append(topButton)
        }
        
        let boardY = topButtons.first!.frame.maxY + gapY
        let boardFrame = CGRect(x: gapX, y: boardY, width: width - 2 * gapX, height: height - bottomLength - boardY - gapY)
        backImageView.frame = boardFrame
        // backImage
        backImageView.layer.cornerRadius = 12 * fontFactor
        backImageView.layer.masksToBounds = true
        view.addSubview(backImageView)
        
        // top
        for (i, button) in topButtons.enumerated() {
            let imageView = UIImageView(image: UIImage(named: "IA_\(i)_selected"))
            imageView.frame = CGRect(x: button.frame.minX, y: button.frame.minY, width: button.frame.width, height: button.frame.width / 118 * 57)
            imageView.layer.addBlackShadow(6 * fontFactor)
            view.addSubview(imageView)
            topMasks.append(imageView)
        }
        
        // scorecard
        scorecardView.isHidden = true
        scorecardView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        scorecardView.setupWithoutBottom()
        scorecardView.frame = mainFrame
        scorecardView.transform = CGAffineTransform(scaleX: 0.02, y: 0.02)
        view.addSubview(scorecardView)
        
        // boards
        for tier in 0..<3 {
            let plateL = tier == 2 ? boardFrame.width * 0.75 : boardFrame.width * 0.9
            let plateCenter = CGPoint(x: boardFrame.midX, y: boardFrame.height * 0.6)
            let tierBoard = LandingMainView(frame: boardFrame)
            tierBoard.delegate = self
            tierBoard.displayedTireIndex = tier
            tierBoard.showAll = false
            tierBoard.addWithPlateLength( plateL, plateCenter: plateCenter)
           
            boards.insert(tierBoard, at: 0) // tier3's index is 0
            view.addSubview(tierBoard)
            
            // check
            for button in tierBoard.buttonsOn {
                let risks = MatchedCardsDisplayModel.getRisksPlayedForRiskClass(button.key, ofTier: tier)
                button.showCheck = (risks.count != 0)
            }
        }
        
        explorWheelTable(0)
    }
    
    // action
    fileprivate var currentTier = 0
    fileprivate var landing: LandingMainView! {
        return boards[2 - currentTier]
    }
    @objc func focusOnIndex(_ button: UIButton) {
        let index = button.tag - 100
        explorWheelTable(index)
    }
    
    fileprivate func explorWheelTable(_ index: Int) {
        currentTier = 2 - index
        
        // top
        for (i, maskImage) in topMasks.enumerated() {
            maskImage.isHidden = (i != index)
        }
        
        for (i, board) in boards.enumerated() {
            board.isHidden = (i != index)
        }
    }
   
    fileprivate var riskKey: String!
    fileprivate var riskClassKey: String!
    fileprivate var riskTypeKey: String!
    fileprivate func displayScorecard() {
        landing.titleLabel.isHidden = true
        
        let measurement = selectionResults.getLastMeasurementOfUser(userCenter.currentGameTargetUser.Key(), riskKey: riskKey, whatIf: WHATIF)!
        scorecardView.setupWithMeasurement(measurement)
        scorecardView.isHidden = false
        
        let scaleRatio: CGFloat = 0.3
        let plateCenter = landing.convert(landing.plateCenter, to: view)
        let offsetY = height - bottomLength - plateCenter.y // - radius
        let offsetX = plateCenter.x - (landing.plateLength * scaleRatio * 0.55)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
            self.landing.transform = CGAffineTransform(translationX: -offsetX, y: offsetY).scaledBy(x: scaleRatio, y: scaleRatio)
            self.scorecardView.transform = CGAffineTransform.identity
        }, completion: { (true) in
            self.backButton.isHidden = true
            self.dismiss.isHidden = false
            self.landing.setUserInteractionEnabled(false)
        })
    }
    
    @objc func hideScorecard() {
        self.landing.setUserInteractionEnabled(false)
        touchCenterOfLandingView(landing)
    }
    
    fileprivate func alertForNoScorecard() {
        let alertController = UIAlertController(title: "You haven't played this game yet", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Check Others", style: .default) { (true) in
        }
        let answer = UIAlertAction(title: "Go To Access Tab and Play", style: .default) { (true) in
            // go to play
            self.goToPlayCards()
        }
        alertController.addAction(action)
        alertController.addAction(answer)
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func goToPlayCards() {
        cardsCursor.selectedRiskClassKey = riskClassKey
        cardsCursor.riskTypeKey = riskTypeKey
        GameTintApplication.sharedTint.focusingTierIndex = currentTier
        
        let tabbar = tabBarController!
        tabbar.selectedIndex = 0
        let firstNavi = tabbar.viewControllers?.first! as! ABookNavigationController
        for vc in firstNavi.viewControllers {
            if vc.isKind(of: IntroPageViewController.self) {
                firstNavi.popToViewController(vc, animated: true)
                return
            }
            
            if vc.isKind(of: ABookLandingPageViewController.self) {
                firstNavi.popToViewController(vc, animated: true)
                firstNavi.pushViewController(IntroPageViewController(), animated: true)
                return
            }
        }
    }
}
    
// delegate of landing
extension ScorecardExplorerViewController: LandingProtocol {
    // original state
    func touchCenterOfLandingView(_ view: LandingMainView) {
        riskKey = nil
        UIView.animate(withDuration: 0.3, animations: {
            self.landing.transform = CGAffineTransform.identity
            self.scorecardView.transform = CGAffineTransform(scaleX: 0.02, y: 0.02)
        }) { (true) in
            self.landing.titleLabel.isHidden = false
            self.scorecardView.isHidden = true
            self.backButton.isHidden = false
            self.dismiss.isHidden = true
        }
    }
    
    func landingView(_ view: LandingMainView, chosen button: CustomButton) {
        riskClassKey = button.key
        
        let risks = MatchedCardsDisplayModel.getRisksPlayedForRiskClass(button.key, ofTier: currentTier)
        if currentTier == 2 {
            touchCenterOfLandingView(self.landing)
            var types = [String]()
            for riskKey in risks {
                if let risk = collection.getRisk(riskKey) {
                    types.append(risk.riskTypeKey!)
                }
            }
            
            landing.arcButtons.setButtonsHidden(false)
            for button in landing.arcButtons.buttons {
                button.darken = !types.contains(button.key)
            }
        }else {
            // not played
            if risks.isEmpty {
                // no data, back
                touchCenterOfLandingView(self.landing)
                if currentTier == 0 {
                    riskTypeKey = GameTintApplication.sharedTint.iCaKey
                }else {
                    riskTypeKey = GameTintApplication.sharedTint.iPaKey
                }
                alertForNoScorecard()
            }else {
                if  riskKey == nil || riskKey != risks.first! {
                    riskKey = risks.first!
                    displayScorecard()
                }
            }
        }
    }
    
    func arcButtonIsChosen(_ button: CustomButton) {
        riskTypeKey = button.key
        if !button.darken {
            let risks = collection.getRiskModelKeys(riskClassKey, riskType: button.key)
            if  riskKey == nil || riskKey != risks.first! {
                riskKey = risks.first!
                displayScorecard()
            }
        }else {
            alertForNoScorecard()
        }
    }
}
