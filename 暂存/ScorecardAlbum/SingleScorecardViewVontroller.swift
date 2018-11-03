//
//  SingleScorecardViewVontroller.swift
//  AnnielyticX
//
//  Created by iMac on 2018/8/13.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class SingleScorecardViewVontroller: UIViewController {
//    var measurement: MeasurementObjModel!
    fileprivate let scorecard = ScorecardDisplayAllView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let dismissButton = UIButton(type: .custom)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.circleCrossDismiss, for: .normal)
        let length = 34 * min(standHP, standWP)
        dismissButton.frame = CGRect(x: width - max(50 * min(standHP, standWP), width * 0.05), y: UIApplication.shared.statusBarFrame.size.height, width: length, height: length)
        
        view.addSubview(dismissButton)
        
        scorecard.indicatorView.isHidden = true
        scorecard.frame = CGRect(x: 0, y: dismissButton.frame.maxY, width: width, height: mainFrame.height - dismissButton.frame.maxY)
        
        view.addSubview(scorecard)
//        measurement.riskKey
//        measurement.userKey
        
    }
    
    func setupWithRiskKey(_ riskKey: String, userKey: String) {
        scorecard.setupWithRisk(riskKey, userKey: userKey)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissVC()
    }
    
   
    
    func dismissVC() {

        dismiss(animated: true) {
           
        }
    }
}
