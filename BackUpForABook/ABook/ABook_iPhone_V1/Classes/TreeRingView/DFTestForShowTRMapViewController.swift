//
//  DFTestForShowTRMapViewController.swift
//  ABook_iPhone_V1
//
//  Created by dingf on 17/3/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import UIKit

class DFTestForShowTRMapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func test(_ sender: Any) {
        let vc = ABookTreeRingViewController()
    
        print(RiskMetricCardsCursor.sharedCursor.currentFocusingRisk()!)
        print(UserCenter.sharedCenter.loginUserObj)
        
        let allMeasurements = CardSelectionResults.cachedCardProcessingResults.getAllUserRiskMeasurements()
        let measurements = allMeasurements[UserCenter.sharedCenter.loginUserObj.key]?[RiskMetricCardsCursor.sharedCursor.currentFocusingRisk()!]
        if measurements != nil {
            vc.showTRMapOfMode_5([measurements!])
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
