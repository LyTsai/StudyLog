//
//  SingleScorecardViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/8/13.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class SingleScorecardViewController: UIViewController {

    fileprivate let scorecard = ScorecardDisplayAllView()
    fileprivate let nameLabel = UILabel()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let top = topLength - 44
        let dismissButton = UIButton(type: .custom)
        dismissButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        dismissButton.setBackgroundImage(ProjectImages.sharedImage.circleCrossDismiss, for: .normal)
        let length = 30 * fontFactor
        dismissButton.frame = CGRect(x: width - 40 * fontFactor, y: top, width: length, height: length)
        
        view.addSubview(dismissButton)
        
        // name
        nameLabel.frame = CGRect(x: 0, y: top, width: width, height: 70 * fontFactor).insetBy(dx: 45 * fontFactor, dy: 8 * fontFactor)
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
//        nameLabel.textColor = UIColor.white
        nameLabel.backgroundColor = UIColorFromHex(0xE1B590)
        view.addSubview(nameLabel)
        nameLabel.addBand()
        
        // scorecard
        scorecard.setupWithoutBottom()
        scorecard.frame = CGRect(x: 0, y: nameLabel.frame.maxY, width: width, height: height - nameLabel.frame.maxY - bottomLength)
        
        view.addSubview(scorecard)
    }
    
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        let risk = collection.getRisk(measurement.riskKey)!
        let metricName = collection.getMetric(risk.metricKey!)?.name ?? ""
        let riskTypeFullName = collection.getFullNameOfRiskType(risk.riskTypeKey!)
        
        let topString = "\(metricName)\n- \(riskTypeFullName)"
        let basicString = NSMutableAttributedString(string: topString, attributes: [ .font: UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)])
        basicString.addAttributes([ .font: UIFont.systemFont(ofSize: 10 * fontFactor, weight: .medium)], range: NSMakeRange(metricName.count + 1, riskTypeFullName.count + 2))
        nameLabel.attributedText = basicString
        
        scorecard.setupWithMeasurement(measurement)
        
        if let tabbar = tabBarController?.tabBar {
            tabbar.isHidden = true
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true) {
        }
    }
}
