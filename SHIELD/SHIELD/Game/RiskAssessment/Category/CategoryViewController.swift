//
//  CategoryViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/22.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// for test only now
class CategoryViewController: PlayingViewController {
    
    // REST api model source
//    fileprivate var applicationClassAccess: ApplicationClassAccess!
//    fileprivate var riskListAccess: RiskListAccess!
//    fileprivate var gameAccess: GameDataAccess!
//
//    // spinner
//    fileprivate let spinner = LoadingWhirlProcess()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backImage = WHATIF ? ProjectImages.sharedImage.categoryBackV : ProjectImages.sharedImage.categoryBack
        updateUI()

        
        // spinner
//        spinner.startLoadingOnView(view, length: 122 * fontFactor)
//
//        // get groups first
//        if collection.categoryLoaded == false {
//            // no data for group
//            if let riskFactorCategoryKey = ApplicationDataCenter.sharedCenter.riskFactorCategoryKey {
//                self.applicationClassAccess = ApplicationClassAccess(callback: self)
//                self.applicationClassAccess.getMetricGroupsByKey(riskFactorCategoryKey)
//            }
//        }else {
//            // has data
//            self.checkAndGetRisks()
//        }
    }
    
    
//    fileprivate func checkAndGetRisks() {
//        // do we have data?
//        let riskClassKey = cardsCursor.selectedRiskClassKey!
//        // focusDeckOfCardViewsOnRiskClass(riskClassKey) <- assumes risk model object was already loaded
//        // do we have risk model object loaded aready?
//        if collection.checkRiskObject(cardsCursor.focusingRiskKey) {
//            // have the risk object already
//            focusOntoRiskClass(riskClassKey)
//        }else {
//            // no.  need to load the object
//            riskListAccess = RiskListAccess(callback: self)
//            riskListAccess.getOneGraphByKey(key: cardsCursor.selectedRisk(riskClassKey)!)
//        }
//    }
    ////////////////////////////////////////////////////////////////////////////
    // set risk focus cursor position
    // !!! load a risk "game" and attach it to navigation cursor for card matching "game"
    fileprivate var categoryView: WindingCategoryCollectionView!
//    fileprivate func focusOntoRiskClass(_ riskMetricKey: String) {
//        // set focusing risk in cardsCursor.
//        let riskKey = cardsCursor.focusingRiskKey!
//        let userKey = userCenter.currentGameTargetUser.Key()
//
//        // attach current risk factor metrics collection to deck of cards factory
//        if WHATIF {
//            // from local
//            selectionResults.getAllLocalMeasurementsForUser(userKey, riskKey: riskKey)
//            DispatchQueue.main.async {
//                self.updateUI()
//            }
//        }else {
//            // measurement
//            if !selectionResults.measurementLoadedFromBackendForUser(userKey, riskKey: riskKey) {
//                gameAccess = GameDataAccess(callback: self)
//
//                // get measurements
//                let gameInput = GameRiskInput()
//                gameInput.riskKey = riskKey
//                gameInput.userKey = userKey
//                gameAccess.riskMeasurementList(gameInput)
//            }else {
//                DispatchQueue.main.async {
//                    self.updateUI()
//                }
//            }
//        }
//    }

    fileprivate let whatIfHint = UIImageView()
    fileprivate func updateUI() {

//        spinner.loadingFinished()
        
        let userKey = userCenter.currentGameTargetUser.Key()
        let riskKey = cardsCursor.focusingRiskKey!
        selectionResults.useLastMeasurementForUser(userKey, riskKey: riskKey, whatIf: false)
  
        let cards = collection.getScoreCardsOfRisk(riskKey)
        if cards.isEmpty {
            // no data
            let alert = UIAlertController(title: nil, message: "No card is loaded for this game", preferredStyle: .alert)
            let goBack = UIAlertAction(title: "Got It", style: .cancel, handler: { (login) in
                for vc in self.navigationController!.viewControllers {
                    if vc.isKind(of: IntroPageViewController.self) {
                        self.navigationController?.popToViewController(vc, animated: true)
                        break
                    }
                }
            })
            
            alert.addAction(goBack)
            
            // alert
            present(alert, animated: true, completion: nil)
            return
        }
        
        let finish = GradientBackStrokeButton()
        finish.setupWithTitle("Finish")
        finish.frame = CGRect(center: CGPoint(x: view.frame.midX, y: mainFrame.maxY - 35 * fontFactor), width: width * 0.4, height: 44 * fontFactor)
        finish.addTarget(self, action: #selector(goToSummary), for: .touchUpInside)
        addCategory()
        
        // background
        backImage = WHATIF ? ProjectImages.sharedImage.categoryBackV : ProjectImages.sharedImage.categoryBack
        titleImageView.image = WHATIF ? #imageLiteral(resourceName: "category_title_whatIf") : #imageLiteral(resourceName: "category_title")
        
        // whatIfHint
        whatIfHint.isHidden = !WHATIF
        if WHATIF {
            whatIfHint.isUserInteractionEnabled = true
            whatIfHint.frame = CGRect(x: categoryView.startFrame.minX, y: topLength + categoryView.startFrame.maxY, width: 187 * fontFactor, height: 73 * fontFactor)
            whatIfHint.image = #imageLiteral(resourceName: "category_whatIfHint_full")
            view.addSubview(whatIfHint)
            
            // tap GR
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(fullOrPart))
            whatIfHint.addGestureRecognizer(tapGR)
            
            let panGR = UIPanGestureRecognizer(target: self, action: #selector(moveImage))
            whatIfHint.addGestureRecognizer(panGR)
        }
        
        setCartNumber()
    }
    
    fileprivate let titleImageView = UIImageView()
    fileprivate let titleLabel = UILabel()
    
    
    fileprivate func addCategory() {
        // set up category
        // collection
        // data here
        let categories = CategoryDisplayModel.loadCurrentCategories()
        categoryView = WindingCategoryCollectionView.createWithFrame(mainFrame, categories: categories)

        categoryView.hostVC = self
        view.addSubview(categoryView)
        
        // decoration
        // title and person
        let imageW = 155 * fontFactor
        titleImageView.frame = CGRect(x: width - imageW, y: topLength, width: imageW, height: 118 * fontFactor)
        view.addSubview(titleImageView)
        
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)
        let titleW = imageW * 0.8
        titleLabel.frame = CGRect(x: width - titleW, y: topLength, width: titleW, height: 52 * fontFactor)
        view.addSubview(titleLabel)
        
        // cart and bottom display
        checkDataAndReload()
    }
    
    @objc func goToSummary() {
        let summary = SummaryViewController()
        summary.forCart = false
        navigationController?.pushViewController(summary, animated: true)
    }
  
    
    func answerAll() {
        cardsCursor.focusingCategoryKey = nil
        let focusingKey = cardsCursor.focusingRiskKey
        let allCards = collection.getAllDisplayCardsOfRisk(focusingKey!)

        var unanswered = [CardInfoObjModel]()
        var answered = [CardInfoObjModel]()
        for card in allCards {
            if card.currentSelection() == nil {
                unanswered.append(card)
            }else {
                answered.append(card)
            }
        }
        answered.append(contentsOf: unanswered)

        let riskAssess = ABookRiskAssessmentViewController()
        riskAssess.displayCards = answered
        navigationController?.pushViewController(riskAssess, animated: true)
    }
    
    @objc func fullOrPart() {
        if whatIfHint.frame.width > 100 * fontFactor {
            // show part
            let scaleX: CGFloat = 50 / 187
            let scaleY: CGFloat = 45 / 73
            let transX = -(187 - 50) * 0.5 * fontFactor
            UIView.animate(withDuration: 0.2, animations: {
                self.whatIfHint.transform = CGAffineTransform(scaleX: scaleX
                    ,y: scaleY).rotated(by: CGFloat(Double.pi))
            }) { (true) in
                self.whatIfHint.image = #imageLiteral(resourceName: "category_whatIfHint")
                UIView.animate(withDuration: 0.2, animations: {
                    self.whatIfHint.transform = CGAffineTransform(scaleX: scaleX
                        ,y: scaleY).rotated(by: 2 * CGFloat(Double.pi))
                }) { (true) in
                     UIView.animate(withDuration: 0.2, animations: {
                        self.whatIfHint.transform = CGAffineTransform(translationX: transX, y: 0).scaledBy(x: scaleX
                            , y: scaleY)
                     })
                }
            }
        }else {
            // show full
            UIView.animate(withDuration: 0.2, animations: {
                self.whatIfHint.transform = CGAffineTransform.identity
            }) { (true) in
                self.whatIfHint.image = #imageLiteral(resourceName: "category_whatIfHint_full")
            }
        }
    }
    
    @objc func moveImage(_ panGR: UIPanGestureRecognizer) {
        let imageView = panGR.view!
        let confine = CGRect(x: 0, y: topLength + categoryView.startFrame.maxY, width: width, height: mainFrame.height - categoryView.startFrame.maxY).insetBy(dx: (imageView.frame.width * 0.5 + categoryView.startFrame.minX), dy: imageView.frame.height * 0.5)
        
        if panGR.state == .changed {
            let offset = panGR.translation(in: view)
            
            imageView.center.x = max(min(imageView.center.x + offset.x, confine.maxX), confine.minX)
            imageView.center.y = max(min(imageView.center.y + offset.y, confine.maxY), confine.minY)
            panGR.setTranslation(CGPoint.zero, in: view)
        }
    }

    // check and update
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        checkDataAndReload()
    }
    
    func checkDataAndReload() {
        setCartNumber()
        
        if categoryView != nil {
            categoryView.updateCategoryUI()
            // title
            titleLabel.text = (cartNumber == 0) ? "\"Please choose a Category\"" : "\"Tap the card to Modify your match selection\""
            
            let hintKey = "category box hint shown before key"
            if !userDefaults.bool(forKey: hintKey) && cartNumber == 0 && !CARDPLAYHINT {
                let hintVC = AbookHintViewController()
                let firstIndex = IndexPath(item: 0, section: 0)
                let top = categoryView.topMarginOfItemAt(firstIndex)
                let left = categoryView.leftMarginOfItemAt(firstIndex)
                let cSize = categoryView.itemSizeAtIndexPath(firstIndex)
                let firstFrame = CGRect(x: left, y: categoryView.frame.minY + top, width: cSize.width, height: cSize.height)
                hintVC.focusOnFrame(firstFrame, hintText: "Tap on any category to begin playing card-matching.")
                hintVC.hintKey = hintKey
                overCurrentPresentController?.present(hintVC, animated: true, completion: nil)
                
                CARDPLAYHINT = true
            }
        }
    }
   
    // result
    func showCategoryResult(_ cards: [CardInfoObjModel], title: String, desIndex: Int!) {
        let resultVC = CategoryResultViewController()
        resultVC.setupWithCards(cards, categoryName: title, desIndex: desIndex)
        presentOverCurrentViewController(resultVC, completion: nil)
    }
}


// REST
//extension CategoryViewController: DataAccessProtocal {
//    // riskFactors
//    func didFinishGetGraphByKey(_ obj: AnyObject) {
//        if obj is RiskObjListModel {
//            collection.updateRiskModelFromList((obj as! RiskObjListModel).risk)
//        }
//
//        focusOntoRiskClass(cardsCursor.selectedRiskClassKey)
//    }
//
//    // metric group ---- the category
//    func didFinishGetAttribute(_ obj: [AnyObject]) {
//        if obj is [MetricGroupObjModel] {
//            collection.updateCategory(obj as! [MetricGroupObjModel], fromNet: true)
//        }
//
//        // get risks
//        checkAndGetRisks()
//    }
//
//    // failed
//    func failedGetDataByKey(_ error: String) {
//        if USERECORD{
//            updateUI()
//            return
//        }
//
//        // re login
//        if error == unauthorized {
//            let alert = UIAlertController(title: nil, message: "You are not authorized due to overtime idleness", preferredStyle: .alert)
//            let relogin = UIAlertAction(title: "Log In", style: .default, handler: { (login) in
//                let loginVC = LoginViewController.createFromNib()
//                self.navigationController?.pushViewController(loginVC, animated: true)
//            })
//            let giveUp = UIAlertAction(title: "No", style: .destructive, handler: nil)
//
//            alert.addAction(relogin)
//            alert.addAction(giveUp)
//
//            // alert
//            present(alert, animated: true, completion: nil)
//        }else {
//            let errorAlert = UIAlertController(title: "Error!!!", message: "Net Error", preferredStyle: .alert)
//            let cancelAction = UIAlertAction(title: "Go Back and Retry", style: .cancel, handler: {
//                (reload) in
//
//                for vc in self.navigationController!.viewControllers {
//                    if vc.isKind(of: IntroPageViewController.self) {
//                        self.navigationController?.popToViewController(vc, animated: true)
//                        return
//                    }
//                }
//
//                self.navigationController?.popViewController(animated: true)
//            })
//            errorAlert.addAction(cancelAction)
//            present(errorAlert, animated: true, completion: nil)
//        }
//    }
//
//    func failedAddDataByKey(_ error: String) {
//
//    }
//
//    func failedGetAttribute(_ error: String) {
//        if USERECORD {
//            collection.updateCategory([], fromNet: false)
//            checkAndGetRisks()
//        }
//    }
//
//    // measurement
//    func didFinishGetDataByKey(_ obj: AnyObject) {
//        if obj is MeasurementListObjModel {
//            let measurementList = (obj as! MeasurementListObjModel).measurementList
//            if let measurement = measurementList.first {
//                selectionResults.loadMeasurementFromBackend(measurement)
//                selectionResults.useLastMeasurementForUser(userCenter.currentGameTargetUser.Key(), riskKey: cardsCursor.focusingRiskKey, whatIf: false)
//            }
//
//            updateUI()
//        }
//    }
//}
