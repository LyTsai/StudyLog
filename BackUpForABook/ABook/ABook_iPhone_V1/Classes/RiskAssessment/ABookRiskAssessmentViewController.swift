//
//  ABookRiskAssessmentViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ABookRiskAssessmentViewController: UIViewController {
    // (1) top status bar 20
    let sGap = UIApplication.shared.statusBarFrame.height
    // (2) navigation bar 44
    var nGap: CGFloat {
        return (navigationController?.navigationBar.frame.height)!
    }
    // (3) tab bar 49
    var tGap: CGFloat {
        return (tabBarController?.tabBar.frame.height)!
    }

    var metricCollection: MetricInfoCollectionView!
    
    var cardsView: AssessmentTopView!
    
    fileprivate let cursor = RiskMetricCardsCursor.sharedCursor
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false

        view.backgroundColor = UIColorGray(233)
        
        // barButtonItems
        setupBarButtons()
        
        // assessment
        cardsView = AssessmentTopView(frame:CGRect(x: 0, y: (sGap + nGap), width: width, height: height - (sGap + nGap + tGap)))
        cardsView.controllerDelegate = self
        
        view.addSubview(cardsView)
    }

    
    fileprivate func setupBarButtons() {
        // sizes
        let imageLength: CGFloat = 35
        let sWidth = 56 * width / 375
        let sHeight = sWidth / 56 * 33
        let labelWidth = width - imageLength * 3 - sWidth
        
        // left items: back, userView
        // back
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 13 * width / 375, height: 22 * width / 375)
        backButton.setBackgroundImage(UIImage(named: "barButton_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        
        // user, much larger than the round image
        let userView = UserDisplayView.createWithFrame(CGRect(x: 0, y: 0, width: 5 * imageLength, height: imageLength), userInfo: UserCenter.sharedCenter.currentGameTargetUser.userInfo())
        
        // right item: start over, title
        // start over
        let startOverButton = UIButton(type: .custom)
        startOverButton.frame = CGRect(origin: CGPoint.zero, size: CGSize(width: sWidth, height: sHeight))
        startOverButton.setBackgroundImage(UIImage(named: "startOver"), for: .normal)
        startOverButton.addTarget(self, action: #selector(restartCurrentGame), for: .touchUpInside)
    
        // title
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: labelWidth, height: 44))
        titleLabel.text = "\(cursor.selectedRiskClass.name ?? "") Assessment"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        
        // set
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: backButton), UIBarButtonItem(customView: userView)]
        navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: startOverButton),UIBarButtonItem(customView: titleLabel)]
    }
        
    // actions
    func showGuide()  {
        let userDefaults = UserDefaults.standard
        let shouldShow = userDefaults.value(forKey: "welcome never Shows")
        
        // should show
        if shouldShow == nil {
            let welcomeAlert = AssessGuideAlertController()
            welcomeAlert.useWelcomeAlert()
            welcomeAlert.modalPresentationStyle = .overCurrentContext
            present(welcomeAlert, animated: true, completion: nil)
        }
    }
    
    // interruption
    func backButtonClicked() {
        if answerView.superview != nil && answerView.answered == true {
            getBackToIntro()
            return
        }
        
        let alert = UIAlertController(title: "You want To", message: nil, preferredStyle: .alert)
        let exit = UIAlertAction(title: "Exit without Save", style: .destructive) { (action) in
            // exit
            self.getBackToIntro()
        }
        let save = UIAlertAction(title: "Save and Resume Later", style: .default) { (action) in
            // save
//            CardSelectionResults.cachedCardProcessingResults.saveTargetUserCardResults(UserCenter.sharedCenter.currentGameTargetUser)
            self.getBackToIntro()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(exit)
        alert.addAction(save)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func getBackToIntro(){
        for vc in (navigationController?.viewControllers)! {
            if vc.isKind(of: IntroPageViewController.self) {
                let _ = navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
        
        self.navigationController!.popViewController(animated: true)
    }

    // Summaries
    var answerView = IndividualAnswersView()
    func showIndividualSummary()  {
        // save data
        let results = CardSelectionResults.cachedCardProcessingResults.resultsOfCurrentPlay(UserCenter.sharedCenter.currentGameTargetUser)

        // TODO: -------- frame
        let indiFrame = CGRect(x: 0, y: 64, width: width, height: height - 64)
        answerView = IndividualAnswersView.createWithFrame(indiFrame, results: results)
        answerView.vcDelegate = self
        view.addSubview(answerView)
        
        print(view.frame)
    }
    
    func showTotalSummary() {
        let totalSummary = TotalSummaryViewController()
        navigationController?.pushViewController(totalSummary, animated: true)
    }

    // restart
    func restartCurrentGame()  {
        // replay the game
        
        for subview in view.subviews {
            if subview.isKind(of: IndividualSummaryView.self) {
                subview.removeFromSuperview()
                break
            }
        }
        
        answerView.removeFromSuperview()
        cardsView.restartCurrentGame()
    }
   
}
