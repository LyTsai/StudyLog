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
  
    override var playerReachable: Bool {
        return false
    }
    
    var displayCards = [CardInfoObjModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // back
        let topGray = UIView(frame: CGRect(x: -2 * standHP, y: mainFrame.minY - 4 * standHP, width: width + 4 * standHP, height: 45 * standHP))
        topGray.backgroundColor = UIColorGray(235)
        topGray.layer.borderWidth = 2 * standHP
        topGray.layer.borderColor = UIColorFromRGB(126, green: 211, blue: 33).cgColor
        view.addSubview(topGray)
        
        // assessment, with all card views and process
        cardsView = AssessmentTopView(frame: mainFrame)
        cardsView.loadWithCards(displayCards)
        cardsView.cartCenter = CGPoint(x: width - 38, y: -44)
        cardsView.controllerDelegate = self
        view.addSubview(cardsView)
        
        setupWithState()
    }
    
    func setupWithState() {
        backImage = WHATIF ? ProjectImages.sharedImage.playCardsBackV : ProjectImages.sharedImage.backImage
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if let _ = userDefaults.object(forKey: "TextHint") {
            
        }else {
            let alert = CatCardAlertViewController()
            alert.addTitle("You can swipe the scrolling text to read the full content, or back!", subTitle: nil, buttonInfo: [("Got It", true, nil)])
            userDefaults.set(true, forKey: "TextHint")
            userDefaults.synchronize()
            presentOverCurrentViewController(alert, completion: nil)
        }
    }
    
    // interruption
    override func backButtonClicked() {
        let riskKey = cardsCursor.focusingRiskKey!
        let userKey = userCenter.currentGameTargetUser.Key()
        
        if let categoryKey = cardsCursor.focusingCategoryKey {
            //  not answered
            if selectionResults.getNumberOfCardsPlayedForUser(userKey, riskKey: riskKey, categoryKey: categoryKey) == 0 {
                self.navigationController?.popViewController(animated: true)
                return
            }
        }else {
            // choose all
            if !MatchedCardsDisplayModel.riskIsCurrentPlayed() {
                self.navigationController?.popViewController(animated: true)
                return
            }
        }
        
        // answered
        let alert = CatCardAlertViewController()
        alert.addTitle("You Want To", subTitle: nil, buttonInfo: [ ("Go to First Card", false, goToFirst), ("Cancel", false, nil), ("Save And Resume Later", true, resumeLater)])
        presentOverCurrentViewController(alert, completion: nil)
    }
    
    fileprivate func resumeLater() {
        let userKey = userCenter.currentGameTargetUser.Key()
        let riskKey = cardsCursor.focusingRiskKey!
        let measurement = selectionResults.prepareOneMeasurementForUser(userKey, ofRisk: riskKey)
        selectionResults.saveAsLastRecord(measurement)
        
        // upload???
        self.navigationController?.popViewController(animated: true)
    }
    
    fileprivate func goToFirst() {
        self.cardsView.goToCard(0)
    }
}

