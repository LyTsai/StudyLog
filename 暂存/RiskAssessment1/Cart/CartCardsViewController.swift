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
    
    // view did load
    var chosenCards = [MatchedCardsDisplayModel]()
    var categoryTable: CartTableView!
    var cardAnswerView: CardAnswerChangeView!
    
    fileprivate let selectionLabel = UILabel()
    fileprivate let desLabel = UILabel()
    fileprivate let actionButton = UIButton.customThickRectButton("Save")
    fileprivate var answerHeight: CGFloat {
        return 155 * height / 667
    }
    fileprivate var editButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        automaticallyAdjustsScrollViewInsets = false
        
        navigationItem.title = "Cards I Selected"
        editButton = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(changeMode))
        navigationItem.rightBarButtonItem = editButton

        // category table
        chosenCards = MatchedCardsDisplayModel.getCurrentMatchedCards()
        categoryTable = CartTableView.createWithFrame(mainFrame, chosenCards: chosenCards)
        categoryTable.hostVC = self

        view.addSubview(categoryTable)
        
        addCommandBar()
        addCardAnswerView()
    }
    
    fileprivate func addCommandBar() {
        // command bar
        let cmdHeight = 70 * height / 667
        let cmdBar = UIView(frame: CGRect(x: -1, y: height - 49 - cmdHeight ,width: width + 2, height: cmdHeight))
        cmdBar.layer.borderColor = UIColorGray(231).cgColor
        cmdBar.layer.borderWidth = 1
        cmdBar.backgroundColor = UIColor.white.withAlphaComponent(0.95)
        
        // seletionInfo
        desLabel.frame = CGRect(x: 15, y: 0, width: 110, height: cmdHeight)
        desLabel.text = "Number of Cards"
        desLabel.textAlignment = .center
        desLabel.numberOfLines = 0
        desLabel.font = UIFont.systemFont(ofSize: cmdHeight * 0.21, weight: UIFontWeightMedium)
        
        selectionLabel.textColor = UIColor.red
        selectionLabel.frame = CGRect(x: desLabel.frame.maxX + 2, y: 0, width: 29, height: cmdHeight)
        selectionLabel.text = "\(chosenCards.count)"
        
        // delete or save
        actionButton.adjustThickRectButton(CGRect(center: CGPoint(x: width - 98 * height / 667, y: cmdHeight * 0.5), width: 137 * height / 667, height: 49 * height / 667))
        actionButton.addTarget(self, action: #selector(actionForCards), for: .touchUpInside)
        
        cmdBar.addSubview(desLabel)
        cmdBar.addSubview(selectionLabel)
        cmdBar.addSubview(actionButton)
        view.addSubview(cmdBar)
    }
    
    fileprivate func addCardAnswerView() {
        // answer change
        cardAnswerView = CardAnswerChangeView.createWithFrame(CGRect(x: 0, y: height - answerHeight - 49, width: width, height: answerHeight), topHeight: answerHeight / 4, card: chosenCards.first!.cardInfo, mainColor: tabTintGreen)
        cardAnswerView.layer.addBlackShadow(3)
        cardAnswerView.layer.shadowOffset = CGSize(width: 0, height: -1)

        cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight * 1.1)
        cardAnswerView.hostVC = self

        view.addSubview(cardAnswerView)
    }
    
    // MARK: --------- change card answer animation
    func bringUpWithCard(_ card: CardInfoObjModel, mainColor: UIColor) {
        cardAnswerView.setupWithCard(card, mainColor: mainColor)
        UIView.animate(withDuration: 0.5) {
            self.cardAnswerView.transform = CGAffineTransform.identity
        }
    }
    
    func answerIsSetForCard(_ card: CardInfoObjModel, result: Int) {
        // data is changed before
        for chosenCard in chosenCards {
            if chosenCard.cardInfo.key == card.key {
                chosenCard.changeAnswerToIndex(result)
                break
            }
        }
        
        // change table
        categoryTable.reloadDataWithCards(chosenCards)
        drawDown()
    }
    
    fileprivate func drawDown() {
        if cardAnswerView.transform == CGAffineTransform.identity {
            UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseIn, animations: {
                self.cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight * 1.1)
            }, completion: nil)
        }
    }
    
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
    func changeMode() {
        editingMode = !editingMode
        
        editButton.title = editingMode ? "Done" : "Edit"
        actionButton.setTitle(editingMode ? "Delete" : "Save", for: .normal)
        
        desLabel.text = editingMode ? "Number of Chosen Cards" : "Number of Cards"
        selectionLabel.text = editingMode ? "0" : "\(chosenCards.count)"
        
        // all changed
        categoryTable.editingMode = editingMode
        categoryTable.reloadData()
        
        drawDown()
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
        
        chosenCards = MatchedCardsDisplayModel.getCurrentMatchedCards()
        categoryTable.reloadDataWithCards(chosenCards)
        selectedCards.removeAll()
        
        changeMode()
        
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
