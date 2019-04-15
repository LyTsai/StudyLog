//
//  ABookRiskAssessmentViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/9/20.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import Foundation
import UIKit

class ABookRiskAssessmentViewController: UIViewController {

    var cardsView: AssessmentTopView!
    var categoryView: CategorySelectionView!
    
    fileprivate let maskView = UIView()
    fileprivate let cartView = CartView()
    fileprivate let titleLabel = UILabel()
    
    // singleton
    fileprivate let dataCursor = RiskMetricCardsCursor.sharedCursor
    fileprivate let cachedResult = CardSelectionResults.cachedCardProcessingResults
    fileprivate let cardCollection = AIDMetricCardsCollection.standardCollection
    
    fileprivate var playState: [String: [String]]! {
        cachedResult.updateCurrentPlayState()
        return cachedResult.riskPlayState[dataCursor.focusingRiskKey!]
    }

    
    // REST api model source
    fileprivate var applicationClassAccess: ApplicationClassAccess!
    fileprivate var riskListAccess: RiskListAccess!
    
    // spinner
    fileprivate var spinner: UIActivityIndicatorView!
    fileprivate var mainFrame: CGRect {
//        let topLength = UIApplication.shared.statusBarFrame.height + (navigationController?.navigationBar.frame.height)!
        
        return CGRect(x: 0, y: 64, width: width, height: height - 64 - 49)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColorGray(233)

        // barButtonItems
        setupBarButtons()
        
        // spinner
        spinner = StartSpinner(view)
        spinner.activityIndicatorViewStyle = .whiteLarge
        
        // get groups first
        if cardCollection.categoryLoaded == false {
            // no data for group
            if let riskFactorCategoryKey = ApplicationDataCenter.sharedCenter.riskFactorCategoryKey {
                applicationClassAccess = ApplicationClassAccess(callback: self)
                applicationClassAccess.getMetricGroupsByKey(riskFactorCategoryKey)
            }
            
        }else {
            // has data
            checkAndGetRisks()
        }
        
        // assessment
        cardsView = AssessmentTopView(frame: mainFrame)

        cardsView.cartCenter = CGPoint(x: width - 38, y: -44)
        cardsView.controllerDelegate = self
        view.insertSubview(cardsView, at: 0)
    }
    
    fileprivate func setupBarButtons() {
        // sizes
        let imageLength: CGFloat = 35
        let sHeight: CGFloat = 38
        let sWidth: CGFloat = 38
        let labelWidth = width - imageLength * 3 - sWidth
        
        // left items: back, userView
        // back
        let spacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        spacer.width = -12
        
        let backButton = UIButton(type: .custom)
        backButton.frame = CGRect(x: 0, y: 0, width: 13 * width / 375, height: 22 * width / 375)
        backButton.setBackgroundImage(UIImage(named: "barButton_back"), for: .normal)
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        navigationController?.view.clipsToBounds = true
        
        // user, much larger than the round image
        let userView = UserDisplayView.createWithFrame(CGRect(x: 0, y: 0, width: 5 * imageLength, height: imageLength), userInfo: UserCenter.sharedCenter.currentGameTargetUser.userInfo())
        
        // right item: start over, title
        // start over
        let rightSpacer = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: self, action: nil)
        rightSpacer.width = -12
        
        // cart
        let cartBackFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: sWidth * 1.3, height: 44))
        let cartSpaceView = UIView(frame: cartBackFrame)
        cartView.frame = CGRect(center: CGPoint(x: cartBackFrame.midX, y: cartBackFrame.midY), width: sWidth, height: sHeight)
        setCartNumber(nil)
        cartView.addTarget(self, action: #selector(checkCart), for: .touchUpInside)
        cartSpaceView.addSubview(cartView)
        
        // title
        titleLabel.frame = CGRect(x: 0, y: 0, width: labelWidth, height: 44)
        let riskTypeName = cardCollection.getRiskTypeByKey(dataCursor.riskTypeKey)?.name ?? "Assessment"
        titleLabel.text = "\(dataCursor.selectedRiskClass.name ?? "") \(riskTypeName)"
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        
        // set
        navigationItem.leftBarButtonItems = [spacer, UIBarButtonItem(customView: backButton), UIBarButtonItem(customView: userView)]
        navigationItem.rightBarButtonItems = [rightSpacer, UIBarButtonItem(customView: cartSpaceView),UIBarButtonItem(customView: titleLabel)]
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setCartNumber(nil)
        
        // with data
        if categoryView != nil {
            showCategory = true
        }

    }
    // actions
    func showGuide()  {
        let userDefaults = UserDefaults.standard
        let shouldShow = userDefaults.value(forKey: "welcome never Shows")
        
        // should show
        if shouldShow == nil {
            let welcomeAlert = AssessGuideAlertController()
            welcomeAlert.useWelcomeAlert()
            welcomeAlert.modalPresentationStyle = .overCurrentContext
            present(welcomeAlert, animated: true, completion: nil)
        }
    }
    
    // interruption
    func backButtonClicked() {
        cachedResult.updateCurrentPlayState()
        
        if answerView.superview != nil && answerView.answered == true {
            getBackToIntro()
            return
        }
        let userKey = UserCenter.sharedCenter.currentGameTargetUser.Key()
        let riskKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey
        
        let alert = UIAlertController(title: "You want To", message: nil, preferredStyle: .alert)
        let exit = UIAlertAction(title: "Exit without Save", style: .destructive) { (action) in
            
            // clear cached data
            CardSelectionResults.cachedCardProcessingResults.clearAnswerForUser(userKey, riskKey: riskKey!)
            
            // exit
            self.getBackToIntro()
        }
        
        let save = UIAlertAction(title: "Save and Resume Later", style: .default) { (action) in
            // save

            
//            let result = CardSelectionResults.cachedCardProcessingResults.getAllUserRiskMeasurementsByCard()
//            if let measurement = result[userKey]?[riskKey!] {
//                let  measurementAccess = MeasurementAccess(callback: self)
//                if measurement.values.count > 0 {
//                    measurementAccess.addOne(oneData: measurement)
//                }
//            }

//            CardSelectionResults.cachedCardProcessingResults.saveTargetUserCardResults(UserCenter.sharedCenter.currentGameTargetUser)
            self.getBackToIntro()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        

        alert.addAction(save)
        alert.addAction(exit)
        alert.addAction(cancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    // show category
    var showCategory = true {
        didSet{
            let duration: TimeInterval = 0.4
            if showCategory {
                // check for display
                categoryView.playState = playState
                
                // hide cards and show category
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
                    self.categoryView.transform = CGAffineTransform.identity
                }, completion: { (true) in
                    self.maskView.isHidden = false
                })
            } else {
                // show cards
                UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
                    self.categoryView.transform = CGAffineTransform(translationX: self.width, y: 0)
                }, completion: { (true) in
                    self.cardsView.updateDisplayedCards()
                    self.maskView.isHidden = true
                })
            }
        }
    }

    // Summaries
    var answerView = IndividualAnswersView()
    func showIndividualSummary()  {
        // save data
        let results = cachedResult.resultsOfCurrentPlay(UserCenter.sharedCenter.currentGameTargetUser)

        answerView = IndividualAnswersView.createWithFrame(mainFrame, results: results)
        answerView.vcDelegate = self
        view.addSubview(answerView)
    }
    

    // check cart
    func checkCart() {
        if cartView.number == 0 {
            print("no card")
            
            let alert = UIAlertController(title: nil, message: "No Card\n is Answered", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Go To Answer", style: .default, handler: nil)
            alert.addAction(ok)
            present(alert, animated: true, completion: nil)
            return
        }
        
        // check matched cards
        let cartVC = CartCardsViewController()
        cartVC.presentedFrom = self
        navigationController?.pushViewController(cartVC, animated: true)
    }
    
    func cartIsAdded() {
        cartView.cardAddAnimation()
        let shakeAngle = CGFloat(Double.pi) / 12
        UIView.animate(withDuration: 0.15, delay: 0.3, options: .curveLinear, animations: {
            self.cartView.transform = CGAffineTransform(rotationAngle: shakeAngle)
        }) { (true) in
            UIView.animate(withDuration: 0.15, animations: {
                self.cartView.transform = CGAffineTransform(rotationAngle: -shakeAngle)
            }) { (true) in
                self.cartView.transform = CGAffineTransform.identity
                self.setCartNumber(nil)
            }
        }
    }
    
    // restart
    func restartCurrentGame()  {
        // replay the game
        
        // answer shows, re choose
        if answerView.superview != nil {
            answerView.removeFromSuperview()
            showCategory = true
        }else {
            if showCategory == true {
                // category shows
                showCategory = false
            }else {
                cardsView.restartCurrentGame()
            }
        }
    }
   
    // action
    func setCartNumber(_ number: Int?)  {
        var answered = cachedResult.numberOfCurrentCardsCached()
        if number != nil {
            // set directly
            answered += number!
        }
        
        cartView.number = answered
    }
    
    // MQRK: -------------------------------- data -------------------
    fileprivate func checkAndGetRisks() {
        // user, much larger than the round ima
        // data for chosen risk
        riskListAccess = RiskListAccess(callback: self)
        
        // do we have data?
        let riskClassKey = dataCursor.selectedRiskClassKey!
        // switch to REST api data source instead of local coredata
        // focusDeckOfCardViewsOnRiskClass(riskClassKey) <- assumes risk model object was already loaded
        // do we have risk model object loaded aready?
        if dataCursor.checkRiskObject(dataCursor.focusingRiskKey) {
            // have the risk object already
            focusOntoRiskClass(riskClassKey)
        }else {
            // no.  need to load the object
            loadRiskGraph(key: dataCursor.selectedRisk(riskClassKey)!)
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // set risk focus cursor position
    // !!! load a risk "game" and attach it to navigation cursor for card matching "game"
    fileprivate func focusOntoRiskClass(_ riskMetricKey: String) {
        // set focusing risk in dataCursor.
        let riskKey = dataCursor.focusOnRiskClass(riskMetricKey)
        
        // attach current risk factor metrics collection to deck of cards factory
        VDeckOfCardsFactory.metricDeckOfCards.attachToRiskModel(riskKey)
        
        // set up category
        maskView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        view.addSubview(maskView)
        maskView.frame = view.bounds
        
        let categoryFrame = mainFrame.insetBy(dx: 10, dy: 10)
        categoryView = CategorySelectionView.createWithFrame(categoryFrame, playState: playState)
        categoryView.backgroundColor = UIColor.white
        categoryView.layer.cornerRadius = 8
        categoryView.hostVC = self
        view.addSubview(categoryView)
        
        EndSpinner(spinner)
    }
    
    func getBackToIntro(){
        for vc in (navigationController?.viewControllers)! {
            if vc.isKind(of: IntroPageViewController.self) {
                let _ = navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
        
        self.navigationController!.popViewController(animated: true)
    }
    
    // load a full risk object graph from REST api backend
    func loadRiskGraph(key: String) {
        riskListAccess.getOneGraphByKey(key: key)
    }
}

extension ABookRiskAssessmentViewController: DataAccessProtocal {
    func didFinishGetGraphByKey(_ obj: AnyObject) {
        
        if obj is RiskObjListModel {
            cardCollection.updateRiskModelObjects(obj as! RiskObjListModel)
        }
        
        focusOntoRiskClass(dataCursor.selectedRiskClassKey)
    }
    
    func failedGetDataByKey(_ error: String) {
        
        // show error messages.  !!! to do
        // re login
        if error == unauthorized {
            let alert = UIAlertController(title: nil, message: "You are not authorized due to overtime idleness", preferredStyle: .alert)
            let relogin = UIAlertAction(title: "Log In", style: .default, handler: { (login) in
                let loginVC = LoginViewController()
                self.present(loginVC, animated: true, completion: nil)
            })
            let giveUp = UIAlertAction(title: "No", style: .destructive, handler: nil)
            
            alert.addAction(relogin)
            alert.addAction(giveUp)
            
            // alert
            present(alert, animated: true, completion: nil)
        }
    }
    
    // metric group ---- the category
    func didFinishGetAttribute(_ obj: [AnyObject]) {
        if obj is [MetricGroupObjModel] {
            cardCollection.updateCategory(obj as! [MetricGroupObjModel])
        }
        
        // get risks
        checkAndGetRisks()
    }
}
