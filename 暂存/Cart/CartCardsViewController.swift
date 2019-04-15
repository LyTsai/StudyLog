//
//  CartCardsViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/7/13.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CartCardsViewController: UIViewController {
    weak var presentedFrom: UIViewController!
    
    // default as by risk
    fileprivate var chosenSegIndex: Int = 0
    fileprivate var segments = [CartSegmentView]()
    fileprivate var tables = [CartTableView]()
    
    fileprivate let selectionLabel = UILabel()
    fileprivate let actionButton = UIButton.customThickRectButton("Save")
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.title = "Answered Cards"
        let editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(changeMode))
        navigationItem.rightBarButtonItem = editButton

        // segment
        let segHeight = height * 40 / 667
        let tableFrame = CGRect(x: 0, y: 64 + segHeight, width: width, height: height - 49 - 64 - segHeight)
        // risk
        let riskSeg = CartSegmentView()
        riskSeg.setWithFrame(CGRect(x: 0, y: 64, width: width * 0.5, height: segHeight), title: "Overall", selected: false)
        let riskTap = UITapGestureRecognizer(target: self, action: #selector(changeTable))
        riskSeg.addGestureRecognizer(riskTap)
        let riskTable = CartTableView.createWithFrame(tableFrame, byRisk: true)
        riskTable.hostVC = self
        // add risk
        segments.append(riskSeg)
        tables.append(riskTable)
        
        view.addSubview(riskSeg)
        view.addSubview(riskTable)
        
        // category
        let categorySeg = CartSegmentView()
        categorySeg.setWithFrame(CGRect(x: width * 0.5, y: 64, width: width * 0.5, height: segHeight), title: "Category", selected: true)
        let categoryTap = UITapGestureRecognizer(target: self, action: #selector(changeTable))
        categorySeg.addGestureRecognizer(categoryTap)
        let categoryTable = CartTableView.createWithFrame(tableFrame, byRisk: false)
        categoryTable.hostVC = self
        
        // add category
        segments.append(categorySeg)
        tables.append(categoryTable)
        view.addSubview(categorySeg)
        view.addSubview(categoryTable)
        
        // set category as default
        riskTable.isHidden = true
        chosenSegIndex = 1
        
        // command bar
        let cmdHeight = 70 * height / 667
        let cmdBar = UIView(frame: CGRect(x: -1, y: height - 49 - cmdHeight ,width: width + 2, height: cmdHeight))
        cmdBar.layer.borderColor = UIColorGray(231).cgColor
        cmdBar.layer.borderWidth = 1
        cmdBar.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        
        // seletionInfo
        let desLabel = UILabel(frame: CGRect(x: 15, y: 0, width: 110, height: cmdHeight))
        desLabel.text = "Number of Cards"
        desLabel.textAlignment = .center
        desLabel.numberOfLines = 0
        desLabel.font = UIFont.systemFont(ofSize: cmdHeight * 0.21, weight: UIFontWeightMedium)
        
        selectionLabel.textColor = UIColor.red
        selectionLabel.frame = CGRect(x: desLabel.frame.maxX + 2, y: 0, width: 29, height: cmdHeight)
        selectionLabel.text = "0"
        
        // delete or save
        actionButton.adjustThickRectButton(CGRect(center: CGPoint(x: width - 98 * height / 667, y: cmdHeight * 0.5), width: 137 * height / 667, height: 49 * height / 667))
        actionButton.addTarget(self, action: #selector(actionForCards), for: .touchUpInside)
        
        cmdBar.addSubview(desLabel)
        cmdBar.addSubview(selectionLabel)
        cmdBar.addSubview(actionButton)
        view.addSubview(cmdBar)
        
//        
//        fileprivate func addCardAnswerView() {
//            // answer change
//            cardAnswerView = CardAnswerChangeView.createWithFrame(CGRect(x: 0, y: height - answerHeight - 49, width: width, height: answerHeight), topHeight: answerHeight / 4, card: cards.first!, mainColor: mainColor)
//            cardAnswerView.layer.addBlackShadow(3)
//            cardAnswerView.layer.shadowOffset = CGSize(width: 0, height: -1)
//            
//            cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight * 1.1)
//            cardAnswerView.hostVC = self
//            
//            view.addSubview(cardAnswerView)
//        }
//        
//        // tap to hide
//        //        let tapGR = UITapGestureRecognizer(target: self, action: #selector(drawDown))
//        //        view.addGestureRecognizer(tapGR)
//        
//        
//        // MARK: --------- change state and data
//        func showAnswerWithCard(_ card: CardInfoObjModel) {
//            cardAnswerView.setupWithCard(card, mainColor: mainColor)
//            
//            UIView.animate(withDuration: 0.5) {
//                self.cardAnswerView.transform = CGAffineTransform.identity
//                self.buttonsView.transform = CGAffineTransform(translationX: 0, y: self.remained)
//            }
//        }
//        
//        func answerIsSetForCard(_ card: CardInfoObjModel, result: Int) {
//            // data is changed before
//            summaryRoad.changeAnswerOfCard(card, toIndex: result)
//            setCartNumber()
//            if !forPart {
//                // change title
//                titleLabel.text = "Answered: \(MatchedCardsDisplayModel.getCurrentMatchedCards().count)\nTotal: \(cards.count)"
//            }
//            drawDown()
//        }
//        
//        func drawDown() {
//            if cardAnswerView.transform == CGAffineTransform.identity {
//                UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseIn, animations: {
//                    self.cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight * 1.1)
//                    self.buttonsView.transform = CGAffineTransform.identity
//                }, completion: nil)
//            }
//        }
//        
//        func updateViewAfterChange() {
//            // data changed
//            if !forPart {
//                title = "Answered: \(MatchedCardsDisplayModel.getCurrentMatchedCards().count)\nTotal: \(cards.count)"
//            }
//            
//            summaryRoad.reloadData()
//            cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight)
//        }

    }
    
    // selection for all
    
    // cardKey: [risk]
    func getAllSelectedCardsInfo() -> [String: [String]] {
        var results = [String: [String]]()
        // cardInfo.key
        for card in selectedCards {
            var riskKeys = [String]()
            for risk in card.risks {
                riskKeys.append(risk.key)
            }
            
            results[card.cardInfo.key] = riskKeys
        }
        
        return results
    }
    
    var selectedCards = [MatchedCardsDisplayModel]() {
        didSet{
            selectionLabel.text = "\(selectedCards.count)"
        }
    }
    
    
    // MARK: ------------- action --------------
    var editingMode = false
    func changeMode(_ barButtonItem: UIBarButtonItem) {
        editingMode = !editingMode
        
        barButtonItem.title = editingMode ? "Done" : "Edit"
        actionButton.setTitle(editingMode ? "Delete" : "Save", for: .normal)
        
        // all changed
        for table in tables {
            table.editingMode = editingMode
            table.reloadData()
        }
        
//        let currentTable = tables[chosenSegIndex]
//
//        currentTable.editingMode = editingMode
//        currentTable.reloadData()
    }
    
    
    func changeTable(_ tap: UITapGestureRecognizer) {
        let tapped = tap.view as! CartSegmentView
        let current = segments[chosenSegIndex]
        
        if tapped !== current {
            let oldIndex = chosenSegIndex
            current.setUIWithState(false)
            
            for (i, seg) in segments.enumerated() {
                if tapped === seg {
                    seg.setUIWithState(true)
                    chosenSegIndex = i
                    break
                }
            }
            let displayTable = tables[self.chosenSegIndex]
            
            UIView.animate(withDuration: 0.4, animations: { 
                self.tables[oldIndex].isHidden = true
                
                displayTable.isHidden = false
                displayTable.updateFoldForSelection()
                displayTable.reloadData()
            })
        }
    }
    
    // MARK: ------------------- action --------------------
    func actionForCards() {
        if editingMode {
            deleteSelectedCards()
        }else {
            saveClicked()
        }
    }
    
    func deleteSelectedCards() {
        let cardInfos = getAllSelectedCardsInfo()
        for (cardKey, riskKeys) in cardInfos {
            for riskKey in riskKeys {
                CardSelectionResults.cachedCardProcessingResults.deleteUserCardInput(UserCenter.sharedCenter.currentGameTargetUser, cardKey: cardKey, riskKey: riskKey)
            }
        }
        
        selectedCards.removeAll()
        
        for table in tables {
            table.reloadAllInfo()
        }
        
        // updateUI of others
        if presentedFrom.isKind(of: SummaryViewController.self) {
            let vc = presentedFrom as! SummaryViewController
            vc.updateViewAfterChange()
        }else if presentedFrom.isKind(of: ABookRiskAssessmentViewController.self) {
            let vc = presentedFrom as! ABookRiskAssessmentViewController
            vc.checkCardsData()
        }
    }

    
    // MARK: ------------- save -------------------
    fileprivate let alertVC = CelebrateViewController()
    func saveClicked() {
        // only registerted user can "save" result into backend
        if UserCenter.sharedCenter.userState == .login && UserCenter.sharedCenter.loginUserBackendAccess?.userKey != nil {
            alertVC.presentFromVC = self
            alertVC.modalPresentationStyle = .overCurrentContext
            alertVC.showActivity()
            present(alertVC, animated: true, completion: {
                self.saveMeasurement()
            })
        }
    }
    
    
    // for accessing the REST api backend service
    var measurementAccess: MeasurementAccess?
    fileprivate let cachedResult = CardSelectionResults.cachedCardProcessingResults
    fileprivate func saveMeasurement() {
        // only save current risk and current user
        let userKey = UserCenter.sharedCenter.currentGameTargetUser.Key()
        let riskKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey
        
        let result = cachedResult.getAllUserRiskMeasurementsByCard()
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
}

// REST
extension CartCardsViewController: DataAccessProtocal {
    func didFinishAddDataByKey(_ obj: AnyObject) {
        // alert
        print("save successed")
        alertVC.showCelebrate()
        
        // save data for treeRingMap
        RiskMetricCardsCursor.sharedCursor.setLastRiskKey()
        UserCenter.sharedCenter.setLastUserKey()
    }
    
    func failedAddDataByKey(_ error: String) {
        alertVC.dismissVC()
        
        // relogin
        if error == unauthorized {
            let alert = UIAlertController(title: nil, message: "You are not authorized due to overtime idleness", preferredStyle: .alert)
            let relogin = UIAlertAction(title: "Log In", style: .default, handler: { (login) in
                let loginVC = LoginViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
            })
            let giveUp = UIAlertAction(title: "No", style: .destructive, handler: nil)
            
            alert.addAction(relogin)
            alert.addAction(giveUp)
            
            // alert
            present(alert, animated: true, completion: nil)
        }else {
            let errorAlert = UIAlertController(title: "Error!!!", message: error, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            errorAlert.addAction(cancelAction)
            present(errorAlert, animated: true, completion: nil)
        }
    }
    
}
