//
//  VitaminDHowMainView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/4.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class VitaminDHowMainView: UIView {
    weak var howView: ScorecardVitaminDHowView!
    @IBOutlet weak var dosageButton: UIButton!
    @IBOutlet weak var sourceButton: UIButton!
    
    func setup() {
        let shadowRadius = bounds.width / 334 * 4
        dosageButton.layer.addBlackShadow(shadowRadius)
        sourceButton.layer.addBlackShadow(shadowRadius)
    }
    
    var plannerUrl = ""
    @IBAction func viewDosage(_ sender: Any) {
        let nevershowKey = "Never show for dosage view"
        if userDefaults.bool(forKey: nevershowKey) {
            howView.toDosageView()
        }else {
            // introduction
            let planner = Bundle.main.loadNibNamed("VitaminDPlannerViewController", owner: self, options: nil)?.first as! VitaminDPlannerViewController
            planner.setupWithUrl(plannerUrl, keyString: nevershowKey)
            planner.howView = howView
            planner.modalPresentationStyle = .overCurrentContext
            
            viewController.present(planner, animated: true, completion: nil)
        }
    }
    
 
    @IBAction func viewSource(_ sender: Any) {
        howView.toSourceView()
    }
}
