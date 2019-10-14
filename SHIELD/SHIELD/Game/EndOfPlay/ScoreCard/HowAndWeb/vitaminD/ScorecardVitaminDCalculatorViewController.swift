//
//  ScorecardVitaminDCalculatorViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/27.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardVitaminDCalculatorViewController: UIViewController {
    fileprivate var backView: ScorecardConcertoView!
    fileprivate var vtDRefView: VitaminDReferenceView!
    var measurement: MeasurementObjModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // go back dismiss
        let marginX = 8 * fontFactor
        let dismiss = UIButton(type: .custom)
        dismiss.setBackgroundImage(#imageLiteral(resourceName: "dismiss_white"), for: .normal)
        dismiss.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismiss.frame = CGRect(x: width - marginX - 35, y: topLength - 30 - marginX, width: 30, height: 30)
        view.addSubview(dismiss)
        
        // matched card score improving
        let backFrame = CGRect(x: 0, y: dismiss.frame.maxY, width: width, height: height - dismiss.frame.maxY - bottomLength + 49).insetBy(dx: marginX, dy: marginX)
        backView = ScorecardConcertoView(frame: backFrame)
        backView.hideCalendar()
        
        backView.title = "Individualized Calculator\n"
        backView.setupWithSubTitle("For Each Individual", concertoType: .how)
        
        view.addSubview(backView)
        backView.layoutSubviews()
        
        vtDRefView = VitaminDReferenceView(frame: backView.remainedFrame.insetBy(dx: 5, dy: 5))
        vtDRefView.setupWithMeasurement(measurement)
        backView.addSubview(vtDRefView)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
