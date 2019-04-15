//
//  SummaryViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/25.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class SummaryViewController: PlayingViewController {
    var mainColor = tabTintGreen
    var summaryRoad: SummaryOfCardsRoadCollectionView!
    var cardAnswerView: CardAnswerChangeView!
    var categoryResultView: CategoryResultChangeView!
    
    var cards = [CardInfoObjModel]()
    var forPart = false // change title during answering, for part is ture: check cart
    var roadTitle = "" {
        didSet{
            titleLabel.text = roadTitle
        }
    }
    
    fileprivate var allowModify = false {
        didSet{
            summaryRoad.allowsSelection = allowModify
        }
    }
    
    fileprivate let buttonsView = AlignedButtons()
    fileprivate var answerHeight: CGFloat {
        return 155 * height / 667
    }
    fileprivate var remained: CGFloat {
        return 65 * height / 667
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cartView.isHidden = forPart
        
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.categoryBack
        view.addSubview(backImageView)
        
        // subviews
        addRoadViewAndButtons()
        addTitleCloudAndHint()
        addCardAnswerView()
    }
    
    fileprivate func addRoadViewAndButtons() {
        // Summaries, if "cards" is not set, use for all as default
        if !forPart {
            cards = cardCollection.getSortedCardsForRiskKey(dataCursor.focusingRiskKey!)
        }else {
            cards = MatchedCardsDisplayModel.getSortedAnsweredCardsForRisk(dataCursor.focusingRiskKey!)
        }
        
        summaryRoad = SummaryOfCardsRoadCollectionView.createWithFrame(mainFrame, cards: cards, mainColor: mainColor, forPart: forPart)
        summaryRoad.allowsSelection = false
        summaryRoad.hostVC = self
        view.addSubview(summaryRoad)
        
        // save button
        if !forPart {
            buttonsView.frame = CGRect(x: 0, y: height - remained - 49, width: width, height: remained)
            let buttons = buttonsView.addButtonsWithTitles(["MODIFY", "SAVE"], buttonWRatio: 1.4, gap: 8, edgeInsets: UIEdgeInsets(top: 8, left: 25, bottom: 8, right: 25))
            buttons.first!.addTarget(self, action: #selector(modifyIsTouched), for: .touchUpInside)
            buttons.last!.addTarget(self, action: #selector(saveClicked), for: .touchUpInside)
            view.addSubview(buttonsView)
        }else {
            // add cartView, cart_display_total
            let cartImage = UIImage(named: "cart_display_total")!
            let firstIndex = IndexPath(item: 0, section: 0)
            let firstTop = summaryRoad.topMarginOfItemAt(firstIndex)
            let startHeight = firstTop * 0.88
            let startWidth = startHeight * cartImage.size.width / cartImage.size.height
            let cartImageView = UIImageView(image: cartImage)
            cartImageView.contentMode = .scaleToFill
            let startFrame = CGRect(x: 20 * standWP, y: mainFrame.minY + 28 * standHP, width: startWidth, height: startHeight)
            cartImageView.frame = startFrame
            let startPoint = CGPoint(x: startFrame.minX + startWidth * 45 / 208, y: startFrame.maxY - startFrame.height * 0.06)
            summaryRoad.startPoint = view.convert(startPoint, to: summaryRoad)
            
            // label
            let numberLabel = UILabel()
            numberLabel.text = "total: \(cards.count)"
            numberLabel.font = UIFont.systemFont(ofSize: 14 * standWP, weight: UIFontWeightSemibold)
            numberLabel.textAlignment = .center
            numberLabel.frame = CGRect(x: startFrame.width * 0.45, y: startFrame.height * 0.15, width: startFrame.width * 0.5, height: startFrame.height * 0.5)
            
            // add
            view.addSubview(cartImageView)
            cartImageView.addSubview(numberLabel)
        }
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate let titleImageView = UIImageView()
    fileprivate let hintTextImageView = UIImageView()
    fileprivate let hintArrowImageView = UIImageView()
    fileprivate func addTitleCloudAndHint() {
        let standW = width / 375
        
        // title part
        let titleImage = ProjectImages.sharedImage.roadCardTitle!
        let titleWidth = 188 * standW
//            200 * standW
        titleImageView.frame = CGRect(x: width - titleWidth, y: topLength - 15, width: titleWidth, height: titleImage.size.height * titleWidth / titleImage.size.width)
        titleImageView.image = titleImage
        
        // label on it
        titleLabel.frame = CGRect(x: width - 135 * standW, y: topLength + 4, width: 130 * standW, height: titleImageView.frame.height - 14 - standW * 50)
//        titleLabel.backgroundColor = UIColor.red.withAlphaComponent(0.6)
//            CGRect(x: width - 150 * standW, y: topLength + 4, width: 145 * standW, height: titleImageView.frame.height - 14 - standW * 31)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.font =  UIFont.systemFont(ofSize: 16 * standW, weight: UIFontWeightSemibold)
//            UIFont.systemFont(ofSize: forPart ? 18 * standW : 12 * standW, weight: UIFontWeightSemibold)
        
        
        // hint
        hintTextImageView.contentMode = .scaleAspectFit
        hintTextImageView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        hintArrowImageView.frame = CGRect.zero
        
        hintArrowImageView.image = UIImage(named: "tapHint_down") // 12 * 20
        
        // set up
//        if !forPart {
//            roadTitle = "Answered: \(cartView.number)\nTotal: \(cards.count)"
////            "Review your selections. Tab on “MODIFY” to make changes. Tab on “SAVE” after your review."
////
//        }else {
//            roadTitle = "What’s in my Cart" // What’s in my Shopping Cart : Cards I had selected. Tap to make changes to your selections in the cart.
//        }
//
        roadTitle = forPart ? "What’s in my Cart" : "Answered: \(cartView.number)\nTotal: \(cards.count)"
        hintTextImageView.image = UIImage(named: forPart ? "tapText_delete" : "tapText_change")
        
        // addSubview
        view.addSubview(hintTextImageView)
        view.addSubview(hintArrowImageView)
        view.addSubview(titleImageView)
        view.addSubview(titleLabel)
    }
    
    fileprivate let maskView = UIView()
    fileprivate var cardTemplateView: CardTemplateView!
    fileprivate func addCardAnswerView() {
        maskView.frame = view.bounds
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        maskView.isHidden = true
        
        view.addSubview(maskView)
        
        // answer change
        cardAnswerView = CardAnswerChangeView.createWithFrame(CGRect(x: 0, y: height - answerHeight - 49, width: width, height: answerHeight), topHeight: answerHeight / 4, card: cards.first!, mainColor: mainColor)
        cardAnswerView.layer.addBlackShadow(3)
        cardAnswerView.layer.shadowOffset = CGSize(width: 0, height: -1)

        cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight * 1.1)
        cardAnswerView.hostVC = self
        
        view.addSubview(cardAnswerView)
        
    }
   
    // MARK: --------- change state and data
    func showAnswerWithCard(_ card: CardInfoObjModel) {
        cardAnswerView.setupWithCard(card, mainColor: mainColor)
        
        UIView.animate(withDuration: 0.5) {
            self.cardAnswerView.transform = CGAffineTransform.identity
            self.buttonsView.transform = CGAffineTransform(translationX: 0, y: self.remained)
        }
    }

    func answerIsSetForCard(_ card: CardInfoObjModel, result: Int) {
        // data is changed before
        summaryRoad.changeAnswerOfCard(card, toIndex: result)
        if !forPart {
            setCartNumber()
            // change title
            titleLabel.text = "Answered: \(cartView.number)\nTotal: \(cards.count)"
        }
        drawDown()
    }
    
    func drawDown() {
        if cardAnswerView.transform == CGAffineTransform.identity {
            UIView.animate(withDuration: 0.5, delay: 0.4, options: .curveEaseIn, animations: {
                self.cardAnswerView.transform = CGAffineTransform(translationX: 0, y: self.answerHeight * 1.1)
                self.buttonsView.transform = CGAffineTransform.identity
            }, completion: nil)
        }
    }

    override func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: ACTIONS
    //------------------ save ----------------------
    func modifyIsTouched(_ button: UIButton) {
        allowModify = !allowModify
        button.setTitle(allowModify ? "MODIFY FINISHED" : "MODIFY", for: .normal)
        
//        if cartView.number == 0 {
//            presentNoAnwer()
//            return
//        }
//
//        let alert = UIAlertController(title: nil, message: "Do You Want to Clear Answers and Restart", preferredStyle: .alert)
//        let clear = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
//            if self.forPart {
//                // should added????
//            }else {
//                self.cachedResult.clearAnswerForUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), riskKey: self.dataCursor.focusingRiskKey)
//                let _ = self.navigationController?.popViewController(animated: true)
//            }
//        })
//        let giveUp = UIAlertAction(title: "No", style: .cancel, handler: nil)
//
//        alert.addAction(clear)
//        alert.addAction(giveUp)
//
//        // alert
//        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func hintDisplay(_ display: Bool) {
        titleLabel.isHidden = display
        titleImageView.isHidden = display
        
        if display {
            // hint
        }else {
            // cloud
            
        }
    }
    
    fileprivate func presentNoAnwer() {
        let alert = UIAlertController(title: "No Card Is Answered", message: "", preferredStyle: .alert)
        let giveUp = UIAlertAction(title: "Go To Answer", style: .cancel, handler: nil)
        alert.addAction(giveUp)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: ------------- save -------------------
    fileprivate let alertVC = CelebrateViewController()
    func saveClicked() {
        if cartView.number == 0 {
            presentNoAnwer()
            return
        }
        
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
//    fileprivate let cachedResult = CardSelectionResults.cachedCardProcessingResults
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
extension SummaryViewController: DataAccessProtocal {
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
            let errorAlert = UIAlertController(title: "Error!!!", message: "Net Error", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            errorAlert.addAction(cancelAction)
            present(errorAlert, animated: true, completion: nil)
        }
    }
    
}
