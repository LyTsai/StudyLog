//
//  ABookRiskAssessmentViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ABookRiskAssessmentViewController: PlayingViewController {
    var cardsView: AssessmentTopView!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColorGray(233)

        // assessment
        cardsView = AssessmentTopView(frame: mainFrame)
        cardsView.cartCenter = CGPoint(x: width - 38, y: -44)
        cardsView.controllerDelegate = self
        view.addSubview(cardsView)
    }
    
    func checkCardsData() {
        // not good
        cachedResult.updateCurrentPlayState()
        cardsView.updateDisplayedCards()
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
    override func backButtonClicked() {
        let riskKey = dataCursor.focusingRiskKey!
        cachedResult.updateCurrentPlayState()
        
        if let categoryKey = dataCursor.focusingCategoryKey {
            //  not answered
            if !cachedResult.checkCurrentAnswerForRisk(riskKey, categoryKey: categoryKey) {
                self.navigationController?.popViewController(animated: true)
                return
            }
        }else {
            // chose all
            if MatchedCardsDisplayModel.getCurrentMatchedCards().count == 0 {
                self.navigationController?.popViewController(animated: true)
                return
            }
        }
        
        // answered
        let alert = UIAlertController(title: "You want To", message: nil, preferredStyle: .alert)
        let exit = UIAlertAction(title: "Exit without Save", style: .destructive) { (action) in
            // clear cached data
            if let categoryKey = self.dataCursor.focusingCategoryKey {
                self.cachedResult.clearCurrentAnswerForRisk(riskKey, categoryKey: categoryKey)
            }else {
                self.cachedResult.clearAnswerForUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), riskKey: riskKey)
            }
            
            
            // exit
            self.navigationController?.popViewController(animated: true)
        }
        
        let save = UIAlertAction(title: "Save and Resume Later", style: .default) { (action) in
            // save
            self.navigationController?.popViewController(animated: true)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(save)
        alert.addAction(exit)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // restart
//    func restartCurrentGame()  {
//        // replay the game
//        cardsView.restartCurrentGame()
//    }

}

