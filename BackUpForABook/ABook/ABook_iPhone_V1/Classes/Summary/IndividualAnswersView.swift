//
//  IndividualAnswersView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/27.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IndividualAnswersView: UIView {
    weak var vcDelegate: ABookRiskAssessmentViewController!
    var indiTable: IndividualAnswerTableView!
    var answered = false
    
    fileprivate var metric: MetricObjModel {
        return RiskMetricCardsCursor.sharedCursor.selectedRiskClass
    }
    
    class func createWithFrame(_ frame: CGRect, results: [Int?]) -> IndividualAnswersView {
        let answers = IndividualAnswersView(frame: frame)
        answers.setup(results)
        
        return answers
    }
    
    fileprivate let promptLabel = UILabel()
    fileprivate let leftButton = UIButton.customNormalButton("Save")
    fileprivate let rightButton = UIButton.customNormalButton("Replay")

    func setup(_ results: [Int?]) {
        // UI
        backgroundColor = UIColor.white
        
        let width = bounds.width
        let height = bounds.height
        let margin = 7 * width / 375
        let titleHeight = height * 53 / 495
        let tableHeight = 345 * height / 495
        
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: titleHeight))
        titleLabel.textAlignment = .center
        titleLabel.text = "Your Answers"
        
        promptLabel.frame = CGRect(x: 1.5 * margin, y: titleHeight, width: width, height: titleHeight * 0.5)
        promptLabel.font = UIFont.systemFont(ofSize: promptLabel.frame.height * 0.4)
        
        let tableBack = UIView(frame: CGRect(x: -2, y: promptLabel.frame.maxY, width: width + 4, height: tableHeight + 2 * margin))
        tableBack.layer.borderColor = leftOdd.cgColor
        tableBack.layer.borderWidth = 1
        
        let tableFrame = CGRect(x: margin, y: promptLabel.frame.maxY + margin, width: width - 2 * margin, height: tableHeight)
        
        indiTable = IndividualAnswerTableView.createWith(tableFrame, results: results)
        indiTable.layer.cornerRadius = margin
        indiTable.layer.masksToBounds = true
        
        var answeredNumber = 0
        for result in results {
            if result != nil {
                answeredNumber += 1
            }
        }
        promptLabel.text = "Answered: \(answeredNumber)／\(results.count)"
        
        addSubview(titleLabel)
        addSubview(promptLabel)
        addSubview(tableBack)
        addSubview(indiTable)
        
        // button
        leftButton.isSelected = true
        
        let buttonHeight = height - tableBack.frame.maxY - margin
        let buttonX = 30 * width / 375
        let buttonY = tableBack.frame.maxY + 0.7 * margin
        let buttonWidth = 0.5 * (width - margin) - buttonX
        
        leftButton.adjustNormalButton( CGRect(x: buttonX, y: buttonY, width: buttonWidth, height: buttonHeight))
        let rightX = leftButton.frame.maxX + margin
        rightButton.adjustNormalButton(CGRect(x: rightX, y: buttonY, width: buttonWidth , height: buttonHeight))
        
        rightButton.addTarget(self, action: #selector(restartClicked), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
        
        let buttonFont = UIFont.systemFont(ofSize: buttonHeight / 3)
        rightButton.titleLabel?.font = buttonFont
        leftButton.titleLabel?.font = buttonFont
        
        addSubview(leftButton)
        addSubview(rightButton)
    }

    // MARK: -------------- actions
    // save
    fileprivate let alertVC = AssessGuideAlertController()
    func saveClicked() {
        leftButton.isSelected = true
        rightButton.isSelected = false
        answered = true
        
        // save data
        let answers = indiTable.answerIndexes
        let cardsFactory = VDeckOfCardsFactory.metricDeckOfCards
        
        var answeredNumber = 0
        for (i, answer) in answers.enumerated() {

            var value: Int!
            var option: CardOptionObjModel!
            
            let vCard = cardsFactory.getVCard(i)!
            let cardStyleKey = vCard.cardStyleKey
            
            if answer == -1 {
                value = nil
                option = nil
            }else {
                answeredNumber = answeredNumber + 1
                
                // judgement
                if cardStyleKey == JudgementCardTemplateView.styleKey() {
                    value = (answer == 0) ? 1 : -1
                    option = vCard.cardOptions.first
                }
                
                // multiple
                if cardStyleKey == SetOfCardsCardTemplateView.styleKey() {
                    option = vCard.cardOptions[answer]
                    value = answer
                }
            }
            CardSelectionResults.cachedCardProcessingResults.addUserCardInput(UserCenter.sharedCenter.currentGameTargetUser, metricKey: vCard.metricKey!, cardKey: vCard.key, riskKey: RiskMetricCardsCursor.sharedCursor.focusingRiskKey, selection: option, value: value as NSNumber?)
        }

        promptLabel.text = "Answered: \(answeredNumber)／\(answers.count)"
        
        // only registerted user can "save" result into backend
        if UserCenter.sharedCenter.userState == .login && UserCenter.sharedCenter.loginUserBackendAccess?.userKey != nil {
            alertVC.presentFromVC = vcDelegate
            alertVC.isLoading()
            vcDelegate.present(alertVC, animated: true, completion: nil)
            
            saveMeasurement()
        }
    }


    // for accessing the REST api backend service
    var measurementAccess: MeasurementAccess?
    var measurements = [MeasurementObjModel]()
    var cursor = 0
    var size = 0
    fileprivate func saveMeasurement() {
        let allMeasurements = CardSelectionResults.cachedCardProcessingResults.getAllUserRiskMeasurementsByCard()[UserCenter.sharedCenter.currentGameTargetUser.Key()]
        
        if allMeasurements != nil {
            // put into outgoing buffer
            measurements = Array(allMeasurements!.values)
            cursor = 0
            size = measurements.count
            
            if measurementAccess == nil {
                measurementAccess = MeasurementAccess(callback: self)
            }
            
            if size > 0 {
                measurementAccess?.beginApi(nil)
                measurementAccess?.addOne(oneData: measurements[cursor])
            }
        }
    }
    
    // restart
    func restartClicked() {
        answered = false
        leftButton.isSelected = false
        rightButton.isSelected = true
        
        vcDelegate.restartCurrentGame()
    }
}

extension IndividualAnswersView: DataAccessProtocal {
    
    func didFinishGetGraphByKey(_ obj: AnyObject) {
        
    }
    
    func failedGetDataByKey(_ error: String) {
        
        // show error messages.  !!! to do
        
    }
    
    func didFinishAddDataByKey(_ obj: AnyObject) {        
        // MARK: ------- may break here ----------
        var userKey = measurements[cursor].userKey
        if userKey == nil {
            userKey = measurements[cursor].pseudoUserKey
        }
        
        CardSelectionResults.cachedCardProcessingResults.markSavedUserRisk(userKey!, savedRiskKey: measurements[cursor].riskKey!)
        
        cursor = cursor + 1
        if cursor < measurements.count {
            measurementAccess?.addOne(oneData: measurements[cursor])
        }else {
            // alert
            alertVC.useCelebrateAlert()
        }
    }
    
    func failedAddDataByKey(_ error: String) {
        
    }
    
}
