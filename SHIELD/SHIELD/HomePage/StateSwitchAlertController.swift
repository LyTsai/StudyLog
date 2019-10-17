//
//  StateSwitchAlertController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/3.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class StateSwitchAlertController: UIViewController {
    var chooseForContinue: (()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let switchView = Bundle.main.loadNibNamed("StateSwitchView", owner: self, options: nil)?.first as! StateSwitchView
        switchView.continueIsChosen = chooseForContinue
        switchView.setScaleAspectFrameInConfine(mainFrame.insetBy(dx: 15 * fontFactor, dy: 0), widthHeightRatio: 335 / 320)
        
        view.addSubview(switchView)
    }
}
