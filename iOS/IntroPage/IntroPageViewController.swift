//
//  IntroPageViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/9.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IntroPageViewController: UIViewController {
    fileprivate var riskTypeKey: String {
        return RiskMetricCardsCursor.sharedCursor.riskTypeKey
    }
    fileprivate var riskMetric: MetricObjModel! {
        return RiskMetricCardsCursor.sharedCursor.selectedRiskClass
    }
    
    // table view
    var risksView: IntroPageRisksView!
    var pageTableView:IntroPageTableView!
    
    // access
    fileprivate var riskAccess: RiskAccess!
    fileprivate let spinner = LoadingWhirlProcess()
    
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.title = "" // keep the title in center
        navigationItem.title = "Welcome to the game"
        
        let backButton = createBackButton()
        backButton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let topic = GameTintApplication.sharedTint.gameTopic
        view.layer.contents = (topic == .blueZone ? ProjectImages.sharedImage.blueBackImage?.cgImage : ProjectImages.sharedImage.backImage?.cgImage)
        
        // get risks from backends
        if riskMetric == nil || riskMetric!.key == nil {
            print("risk metric is nil")
        }else {
            spinner.startLoading(nil, onView: view, size: CGSize(width: 122 * standWP, height: 122 * standWP))
            // risks
            if AIDMetricCardsCollection.standardCollection.getModelsOfRiskClass(riskMetric!.key, riskTypeKey: riskTypeKey).count == 0 {
                // get risks
                riskAccess = RiskAccess(callback: self)
                riskAccess.getRisksByMetricAndType(metricKey: riskMetric!.key, riskTypeKey: riskTypeKey)
            } else {
                createTable()
            }
        }
    }
    
    func backButtonClicked() {
        for vc in navigationController!.viewControllers {
            print(vc)
            if vc.isKind(of: ABookLandingPageViewController.self){
                self.navigationController?.popToViewController(vc, animated: true)
                break
            }
        }
    }
    
    fileprivate func createTable() {
        spinner.loadingFinished()
        
        // risks
        let risks = AIDMetricCardsCollection.standardCollection.getModelsOfRiskClass(riskMetric!.key, riskTypeKey: riskTypeKey)
        risksView = IntroPageRisksView.createWithFrame(CGRect(x: 0, y: topLength, width: width, height: risks.count <= 1 ? 165 * standHP: 240 * standHP),footerHeight: 24 * standHP, risks: risks)
        risksView.hostVC = self
        
        // introduce
        let pageY = risksView.frame.maxY - 4 * standHP
        // frame fix
        pageTableView = IntroPageTableView.createTableViewWithFrame(CGRect(x: 10, y: pageY, width: width - 20, height: height - pageY - bottomLength), riskMetric: riskMetric!, riskTypeKey: riskTypeKey)
        pageTableView.hostNavi = navigationController
        
        // back
        let backView = UIView(frame: mainFrame.insetBy(dx: 10, dy: 0))
        backView.backgroundColor = UIColor.white
        view.addSubview(backView)
        
        // add
        view.addSubview(pageTableView)
        view.addSubview(risksView)
        
        if risks.count > 1 {
            risksView.risksCollectionView.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
        }
        
        // splash
        if GameTintApplication.sharedTint.gameTopic == .blueZone {
            let splashKey = "blue zone splash is shown before"
            let userDefaults = UserDefaults.standard
            
            if userDefaults.bool(forKey: splashKey) {
                return
            }
            
            // first time
            userDefaults.set(true, forKey: splashKey)
            
            let splash = BlueZoneSplashViewController()
            var splashInfo = [(imageUrl: URL?, title: String?, content: String?)]()
            
            let images = riskMetric!.info_graphUrls
            let abstr = riskMetric!.info_abstract
            for (i, url) in images.enumerated() {
                let sTitle = (i * 2 < abstr.count) ? abstr[i * 2] : ""
                let detail = (i * 2 + 1 < abstr.count) ? abstr[i * 2 + 1] : ""
                splashInfo.append((url, sTitle, detail))
            }
            
            splash.setupWithData(splashInfo)
            present(splash, animated: true, completion: nil)
        }
    }
    
    // for title and reload
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Welcome to the game"
        if pageTableView != nil {
            pageTableView.riskMetric = riskMetric!

            risksView.risks = AIDMetricCardsCollection.standardCollection.getModelsOfRiskClass(riskMetric!.key, riskTypeKey: riskTypeKey)
            risksView.cellIsFolded = false
            risksView.updateData()
        }
    }
}

// REST
extension IntroPageViewController: DataAccessProtocal {
    func didFinishGetAttribute(_ obj: [AnyObject]) {
        if obj is [RiskObjModel] {
            AIDMetricCardsCollection.standardCollection.saveRisks(obj as! [RiskObjModel], forRiskClass : riskMetric!.key, riskType: riskTypeKey, fromNet: true)
            createTable()
        }
    }
    
    func failedGetAttribute(_ error: String) {
//        loadRisksFromLocalOfClass
        let localDB = LocalDatabase.sharedDatabase
        if USERECORD && localDB.database.open() && localDB.database.tableExists("Risk") {
            localDB.database.close()
            
            AIDMetricCardsCollection.standardCollection.loadRisksFromLocalOfClass(riskMetric!.key, riskTypeKey: riskTypeKey)
            createTable()
        }else {
            let errorAlert = UIAlertController(title: "Error!!!", message: "Net Error", preferredStyle: .alert)
            let reloadAction = UIAlertAction(title: "Reload", style: .default, handler: { (action) in
                self.riskAccess.getRisksByMetricAndType(metricKey: self.riskMetric!.key, riskTypeKey: self.riskTypeKey)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.navigationController?.popViewController(animated: true)
            })
            errorAlert.addAction(cancelAction)
            errorAlert.addAction(reloadAction)
            
            if localDB.database.open() && localDB.database.tableExists("Risk") {
                localDB.database.close()
                let recordAction = UIAlertAction(title: "Use Record", style: .default, handler: { (action) in
                    AIDMetricCardsCollection.standardCollection.loadRisksFromLocalOfClass(self.riskMetric!.key, riskTypeKey: self.riskTypeKey)
                    self.createTable()
                    USERECORD = true
                })
               errorAlert.addAction(recordAction)
            }
            
            present(errorAlert, animated: true, completion: nil)
        }
    
    }
}
