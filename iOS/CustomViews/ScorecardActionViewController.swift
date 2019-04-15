//
//  ScorecardActionViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/14.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardActionViewController: UIViewController {
    var measurement: MeasurementObjModel!   // the matched cards (iRa, iPa, iCa) for actions
    var riskKey: String!                    // the key of current playing risk
    var userKey: String!                    // user key
    var index: Int!
    fileprivate var actionView: ScorecardActionView!
    fileprivate var vitaminD: ScorecardVitaminDHowView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let marginX = 8 * fontFactor
        let dismiss = UIButton(type: .custom)
        dismiss.setBackgroundImage(#imageLiteral(resourceName: "present_goBack"), for: .normal)
        dismiss.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismiss.frame = CGRect(x: marginX, y: topLength - 30 - marginX, width: 30, height: 30)
        view.addSubview(dismiss)
        
        let mainFrame = CGRect(x: 0, y: dismiss.frame.maxY, width: width, height: height - dismiss.frame.maxY - bottomLength + 49).insetBy(dx: marginX, dy: marginX)
        
        if index == 1 && riskKey != nil && userKey != nil && collection.getRisk(riskKey).metricKey == vitaminDMetricKey {
            // vitmain D action planners
            vitaminD = ScorecardVitaminDHowView(frame: mainFrame)
            vitaminD.setupWithRiskAndUser(riskKey!, userKey: userKey!)
            view.addSubview(vitaminD)
        } else if index == 0 && measurement != nil {
            // matched card score improving
            actionView = ScorecardActionView(frame: mainFrame)
            actionView.setupCardBasedActionView(measurement)
            view.addSubview(actionView)
        } else if index != nil {
            // url based action recommandation views
            actionView = ScorecardActionView(frame: mainFrame)
            actionView.setupURLBasedActionView(riskKey, actionIndex: index)
            view.addSubview(actionView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if actionView != nil {
            if actionView.spinner != nil {
                 actionView.spinner.startLoadingOnView(actionView, size: CGSize(width: 80 * fontFactor, height: 80 * fontFactor))
            }
        }
    }
    
    @objc func dismissVC() {
        if vitaminD != nil {
            if !vitaminD.onMainRoad {
                vitaminD.goBackToLastView()
                return
            }
        }
        
        dismiss(animated: true, completion: {
            if self.actionView != nil {
                if self.actionView.spinner != nil {
                    self.actionView.spinner.loadingFinished()
                    self.actionView.spinner = nil
                }
            }
            
            if self.vitaminD != nil && self.vitaminD.spinner != nil {
                self.vitaminD.spinner.loadingFinished()
                self.vitaminD.spinner = nil
            }
        })
        
    }
}
