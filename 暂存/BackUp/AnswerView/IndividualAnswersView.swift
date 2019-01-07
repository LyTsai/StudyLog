//
//  IndividualAnswersView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/27.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IndividualAnswersView: UIView {
    weak var vcDelegate: SummaryViewController!
    var indiTable: IndividualAnswerTableView!
    var answered = false
    
    func updateData()  {
        let results = CardSelectionResults.cachedCardProcessingResults.resultsOfCurrentPlay(UserCenter.sharedCenter.currentGameTargetUser)
        indiTable.setupAnswerIndexes(results)
        indiTable.reloadData()
        // number
        setTableAnsweredNumber()
    }
    
    fileprivate var metric: MetricObjModel {
        return RiskMetricCardsCursor.sharedCursor.selectedRiskClass
    }
    
    class func createWithFrame(_ frame: CGRect, results: [Int?]) -> IndividualAnswersView {
        let answers = IndividualAnswersView(frame: frame)
        answers.setup(results)
        
        return answers
    }
    
    fileprivate let promptLabel = UILabel()
    fileprivate let leftButton = UIButton.customThickRectButton("SAVE")
    fileprivate let rightButton = UIButton.customThickRectButton("REPLAY")
    fileprivate var answeredNumber: Int {
        var number = 0
        let results = CardSelectionResults.cachedCardProcessingResults.resultsOfCurrentPlay(UserCenter.sharedCenter.currentGameTargetUser)
        for result in results {
            if result != nil {
                number += 1
            }
        }
        return number
    }
    
    func setup(_ results: [Int?]) {
        // UI
        backgroundColor = UIColor.white
        
        let width = bounds.width
        let height = bounds.height
        let margin = 7 * width / 375
        let titleHeight = height * 53 / 495
        let tableHeight = 345 * height / 495
        
        let titleLabel = UILabel(frame: CGRect(x: margin, y: 0, width: width - 2 * margin, height: titleHeight))
        titleLabel.textAlignment = .center
        titleLabel.text = "My Choices : These are the cards I have just selected"
        titleLabel.numberOfLines = 0
        
        promptLabel.frame = CGRect(x: 1.5 * margin, y: titleHeight, width: width, height: titleHeight * 0.5)
        promptLabel.font = UIFont.systemFont(ofSize: promptLabel.frame.height * 0.4)
        
        let tableBack = UIView(frame: CGRect(x: -2, y: promptLabel.frame.maxY, width: width + 4, height: tableHeight + 2 * margin))
        tableBack.layer.borderColor = leftOdd.cgColor
        tableBack.layer.borderWidth = 1
        
        let tableFrame = CGRect(x: margin, y: promptLabel.frame.maxY + margin, width: width - 2 * margin, height: tableHeight)
        
        indiTable = IndividualAnswerTableView.createWith(tableFrame, results: results)
        indiTable.hostView = self
        indiTable.layer.cornerRadius = margin
        indiTable.layer.masksToBounds = true
    
        // add
        addSubview(titleLabel)
        addSubview(promptLabel)
        addSubview(tableBack)
        addSubview(indiTable)
        
        // button
        leftButton.isSelected = true
        
        let buttonHeight = height - tableBack.frame.maxY - 1.4 * margin
        let buttonX = 30 * width / 375
        let buttonY = tableBack.frame.maxY + 0.7 * margin
        let buttonWidth = 0.5 * (width - margin) - buttonX
        
        leftButton.adjustThickRectButton(CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
        let rightX = leftButton.frame.maxX + margin
        rightButton.adjustThickRectButton(CGRect(x: rightX, y: buttonY, width: buttonWidth , height: buttonHeight))
        
        rightButton.addTarget(self, action: #selector(restartClicked), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
        
        let buttonFont = UIFont.systemFont(ofSize: buttonHeight / 3)
        rightButton.titleLabel?.font = buttonFont
        leftButton.titleLabel?.font = buttonFont
        
        addSubview(leftButton)
        addSubview(rightButton)
        
        setTableAnsweredNumber()
    }

    func setTableAnsweredNumber() {
        promptLabel.text = "Answered: \(answeredNumber)／\(indiTable.answerIndexes.count)"
        if vcDelegate != nil {
            vcDelegate.setCartNumber()
        }
    }
    
    
    // MARK: -------------- actions
    // save
    fileprivate let alertVC = CelebrateViewController()
    func saveClicked() {
        leftButton.isSelected = true
        rightButton.isSelected = false
        answered = true
        
        // only registerted user can "save" result into backend
        if UserCenter.sharedCenter.userState == .login && UserCenter.sharedCenter.loginUserBackendAccess?.userKey != nil {
            alertVC.presentFromVC = vcDelegate
            alertVC.modalPresentationStyle = .overCurrentContext
            alertVC.showActivity()
            vcDelegate.present(alertVC, animated: true, completion: {
                self.saveMeasurement()
            })
        }
    }


    // for accessing the REST api backend service
    var measurementAccess: MeasurementAccess?
    fileprivate func saveMeasurement() {
        // only save current risk and current user
        let userKey = UserCenter.sharedCenter.currentGameTargetUser.Key()
        let riskKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey
        
        let result = CardSelectionResults.cachedCardProcessingResults.getAllUserRiskMeasurementsByCard()
        if let measurement = result[userKey]?[riskKey!] {
            
            if measurementAccess == nil {
                measurementAccess = MeasurementAccess(callback: self)
            }
            
            if measurement.values.count > 0 {
                measurementAccess?.beginApi(nil)
                
                measurement.collectUser = nil
                measurement.user = nil
                measurement.pseudoUser = nil
                measurement.risk = nil
                measurement.report = nil
                
                for value in measurement.values {
                    value.match = nil
                    value.metric = nil
                }
                
                measurementAccess?.addOne(oneData: measurement)
            }else {
                alertVC.showCelebrate()
            }
        }
    }
    
    // restart
    func restartClicked() {
        answered = false
        leftButton.isSelected = false
        rightButton.isSelected = true
//        vcDelegate.answerView.removeFromSuperview()
//        vcDelegate.restartCurrentGame()
    }
}

extension IndividualAnswersView: DataAccessProtocal {
    
    func didFinishGetGraphByKey(_ obj: AnyObject) {
        
    }
    
    func failedGetDataByKey(_ error: String) {
        
        // show error messages.  !!! to do
        
    }
    
    func didFinishAddDataByKey(_ obj: AnyObject) {
        // alert
        print("save successed")
        alertVC.showCelebrate()
        
        // save data for treeRingMap
        RiskMetricCardsCursor.sharedCursor.setLastRiskKey()
        UserCenter.sharedCenter.setLastUserKey()
    }
    
    func failedAddDataByKey(_ error: String) {
        print(error)
        alertVC.dismissVC()
        
        // relogin
        if error == unauthorized {
            let alert = UIAlertController(title: nil, message: "You are not authorized due to overtime idleness", preferredStyle: .alert)
            let relogin = UIAlertAction(title: "Log In", style: .default, handler: { (login) in
                let loginVC = LoginViewController()
                self.vcDelegate.present(loginVC, animated: true, completion: nil)
            })
            let giveUp = UIAlertAction(title: "No", style: .destructive, handler: nil)
            
            alert.addAction(relogin)
            alert.addAction(giveUp)
            
            // alert
            vcDelegate.present(alert, animated: true, completion: nil)
        }
    }
    
}
