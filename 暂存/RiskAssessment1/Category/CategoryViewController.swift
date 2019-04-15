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
    fileprivate var applicationClassAccess: ApplicationClassAccess!
    fileprivate var riskListAccess: RiskListAccess!
    fileprivate var gameAccess: GameDataAccess!
    
    // spinner
//    fileprivate var spinner: UIActivityIndicatorView!
    fileprivate let spinner = LoadingWhirlProcess()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        cartView.isHidden = true
        print("userkey = \(UserCenter.sharedCenter.currentGameTargetUser.Key())")
        // backImage, gradient
        let backImageView = UIImageView(frame: view.bounds)
        backImageView.image = ProjectImages.sharedImage.categoryBack
        view.addSubview(backImageView)
        
        // spinner
//        spinner = StartSpinner(view)
//        spinner.activityIndicatorViewStyle = .gray
        spinner.startLoading(nil, onView: view, size: CGSize(width: 100 * standWP, height: 100 * standWP))
        
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
    }
    
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
    fileprivate let buttonsView = AlignedButtons()
    fileprivate var categoryView: WindingCategoryCollectionView!
    fileprivate func focusOntoRiskClass(_ riskMetricKey: String) {
        // set focusing risk in dataCursor.
        let riskKey = dataCursor.focusOnRiskClass(riskMetricKey)
        
        // attach current risk factor metrics collection to deck of cards factory
        VDeckOfCardsFactory.metricDeckOfCards.attachToRiskModel(riskKey)
        
        // measurement
        let userKey = UserCenter.sharedCenter.currentGameTargetUser.Key()
        if !cachedResult.loadedLastRecordForUser(userKey , riskKey: riskKey) {
            gameAccess = GameDataAccess(callback: self)
            print("userKey = \(userKey), riskKey = \(riskKey)")
            // get measurements
            let gameInput = GameRiskInput()
            gameInput.riskKey = riskKey
            gameInput.userKey = userKey
            gameAccess.riskMeasurementList(gameInput)
        }else {
            updateUI()
        }
    }
    
    fileprivate func updateUI() {
        spinner.loadingFinished()
        
        // set up category
        // collection
        // data here
        categoryView = WindingCategoryCollectionView.createWithFrame(mainFrame, categories:  CategoryDisplayModel.loadCurrentCategories())
        categoryView.hostVC = self
        view.addSubview(categoryView)
        
        // decoration
        let categoryLogo = UIImage(named: "category_logo")!
        let logoWidth: CGFloat = 50 * width / 375
        let logoHeight = logoWidth * categoryLogo.size.height / categoryLogo.size.width
        let categoryImageView  = UIImageView(frame: CGRect(x: width - logoWidth, y: mainFrame.midY - logoHeight * 0.5, width: logoWidth, height: logoHeight))
        categoryImageView.image = categoryLogo
        view.addSubview(categoryImageView)
        
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(answerAll))
        categoryImageView.isUserInteractionEnabled = true
        categoryImageView.addGestureRecognizer(tapGR)
        
        // exit
        let remained: CGFloat = 65 * height / 667
        buttonsView.frame = CGRect(x: 0, y: height - remained - 49, width: width, height: remained)
        let buttons = buttonsView.addButtonsWithTitles(["Review", "Save"], buttonWRatio: 0.7, gap: 8, edgeInsets: UIEdgeInsets(top: 8, left: 25, bottom: 8, right: 25))
        buttons.first!.addTarget(self, action: #selector(checkAll), for: .touchUpInside)
        buttons.last!.addTarget(self, action: #selector(saveTouched), for: .touchUpInside)
        view.addSubview(buttonsView)
        checkButton()
        setCartNumber()
        
//        EndSpinner(spinner)
    }
    
    // load a full risk object graph from REST api backend
    func loadRiskGraph(key: String) {
        riskListAccess.getOneGraphByKey(key: key)
    }
    
    fileprivate func checkButton() {
        var answered: Int = 0
        
        for (_, value) in playState {
            answered += value.count
        }
        
        buttonsView.isHidden = (answered == 0)
        if categoryView != nil {
            categoryView.setupWithPlayState(playState)
        }
    }
    
    func answerAll() {
       let focusingKey = dataCursor.focusingRiskKey
        VDeckOfCardsFactory.metricDeckOfCards.attachCategoryCards(cardCollection.getMetricCardOfRisk(focusingKey!))
        RiskMetricCardsCursor.sharedCursor.focusingCategoryKey = nil
        
        let riskAssess = ABookRiskAssessmentViewController()
        navigationController?.pushViewController(riskAssess, animated: true)
        
    }

    func checkAll() {
        let summary = SummaryViewController()
        summary.forPart = false
        navigationController?.pushViewController(summary, animated: true)
    }
    
    func saveTouched() {
        checkCart()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkButton()
    }
}

// REST
extension CategoryViewController: DataAccessProtocal {
    // riskFactors
    func didFinishGetGraphByKey(_ obj: AnyObject) {
        if obj is RiskObjListModel {
            cardCollection.updateRiskModelObjects(obj as! RiskObjListModel)
        }
        
        focusOntoRiskClass(dataCursor.selectedRiskClassKey)
    }
    
    // metric group ---- the category
    func didFinishGetAttribute(_ obj: [AnyObject]) {
        if obj is [MetricGroupObjModel] {
            cardCollection.updateCategory(obj as! [MetricGroupObjModel])
        }
        
        // get risks
        checkAndGetRisks()
    }
    
    // measurement
    func didFinishGetDataByKey(_ obj: AnyObject) {
        if obj is MeasurementListObjModel {
            let measurementList = (obj as! MeasurementListObjModel).measurementList
            cachedResult.loadRecordForUser(UserCenter.sharedCenter.currentGameTargetUser.Key(), riskKey: RiskMetricCardsCursor.sharedCursor.focusingRiskKey, measurementList: measurementList)
            updateUI()
        }
    }
    
    // failed
    func failedGetDataByKey(_ error: String) {
        // re login
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
