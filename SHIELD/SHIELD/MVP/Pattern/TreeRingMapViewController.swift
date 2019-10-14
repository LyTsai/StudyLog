//
//  TreeRingMapViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2019/1/29.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class TreeRingMapViewController: UIViewController {

    fileprivate let topTitleLabel = UILabel()
    fileprivate var logo: UIImageView!
    fileprivate var treeRingMap: TreeRingMapView!
    fileprivate var chooseView: TreeRingMapTypeChooseView!
    fileprivate var mapExplainView: TreeRingMapExplainView!
    fileprivate let dataModel = TreeRingMapDataModel()
    fileprivate var chooseOffsetY: CGFloat = 0

    fileprivate let treeRingMapTypes: [TreeRingMapType] = [.PersonCardsPeriod, .DatePeopleCards, .GamePeopleDates]
    
    fileprivate var chosenType = TreeRingMapType.PersonCardsPeriod
    fileprivate var topGap = 2 * fontFactor
    fileprivate let bottomHeight = 15 * fontFactor
    fileprivate var printBarButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Multi-variate Pattern Explorer: Multi-dimensional Tree Ring Map"
        view.backgroundColor = UIColor.white
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createBackButton())
        printBarButton = UIBarButtonItem(image: UIImage(named: "icon_printer"), style: .plain, target: self, action: #selector(printCurrentMap))
        navigationItem.rightBarButtonItem = printBarButton
        
        // all parts
        topTitleLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        topTitleLabel.textAlignment = .center
   
        treeRingMap = TreeRingMapView()
        treeRingMap.bottomCenterIsTouched = showChooseTable
        
        // choose type, left
        var titles = [String]()
        for type in treeRingMapTypes {
            titles.append(type.getNameOfType())
        }
        
        let chooseFrame = CGRect(x: 0, y: 0, width: 201 * fontFactor, height: 210 * fontFactor)
        chooseView = TreeRingMapTypeChooseView.createWithFrame(chooseFrame, titles: titles, tableFrame: CGRect(x: 5 * fontFactor, y: 6 * fontFactor, width: 191 * fontFactor, height: chooseFrame.height - bottomHeight - 6 * fontFactor), bottomHeight: bottomHeight)
        chooseOffsetY = bottomHeight - chooseView.frame.height
        chooseView.titleIsChosen = changeType
        chooseView.bottomIsTouched = goToChooseOrHide
        chooseView.layer.addBlackShadow(4 * fontFactor)
   
        // display current
        mapExplainView = TreeRingMapExplainView.createWithFrame(CGRect(x: height - 200 * fontFactor, y: 0, width: 116 * fontFactor, height: width - 70), bottomHeight: bottomHeight, topMargin: topGap, titleHeight: 30 * fontFactor, horizontalMargin: 5 * fontFactor)
        mapExplainView.bottomIsTouched = showOrHideExplain
        mapExplainView.layer.addBlackShadow(4 * fontFactor)
        
        // add
        view.addSubview(topTitleLabel)
        view.addSubview(treeRingMap)
        view.addSubview(chooseView)
        view.addSubview(mapExplainView)
        
        mapExplainView.isHidden = true
        chooseView.isHidden = true
    }

    fileprivate func setScreenLandscape(_ landscape: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.shouldRotate = landscape
        
        let rotateKey = "orientation"
        UIDevice.current.setValue(NSNumber(value: UIInterfaceOrientation.unknown.rawValue), forKey: rotateKey)
        
        let orientationMask = landscape ? UIInterfaceOrientation.landscapeRight : .portrait
        UIDevice.current.setValue(NSNumber(value: orientationMask.rawValue), forKey: rotateKey)
        
        tabBarController?.tabBar.isHidden = landscape
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        checkData()
    }
    
    fileprivate func checkData() {
        let loadTool = GroupedCardsAndRecordLoadTool()
        loadTool.loadForRisk(SHIELDKey, loadingOn: self) { (success) in
            if success {
                self.loadMapView()
            }else {
                // failed
                let errorAlert = UIAlertController(title: "Error!!!", message: "Net Error", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Go Back and Retry", style: .cancel, handler: {
                    (reload) in
                    
                })
                errorAlert.addAction(cancelAction)
                self.present(errorAlert, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate var firstDisplay = true
    
    fileprivate func loadMapView() {
        var defaultUser = userCenter.currentGameTargetUser.Key()
        let allMeasurements = selectionResults.getAllBaselineMeasuremes()
        if allMeasurements.isEmpty {
            let catAlert = CatCardAlertViewController()
            catAlert.addTitle("No Record", subTitle: "Go to play some games", buttonInfo: [("Got It", true, goToAssess)])
            presentOverCurrentViewController(catAlert, completion: nil)
            
            return
        }
        
        // show map
        setScreenLandscape(true)
        // relayout
        if firstDisplay && width > height {
            relayoutForLandscape()
            mapExplainView.isHidden = false
            chooseView.isHidden = false
            firstDisplay = false
        }
        
        // assign
        // default data
        var available = selectionResults.filterWithPlayers([defaultUser], inMeasurements: allMeasurements)
        if available.isEmpty {
            defaultUser = allMeasurements.first!.playerKey!
            available = selectionResults.filterWithPlayers([defaultUser], inMeasurements: allMeasurements)
        }
        var riskKey = available.first?.riskKey!
        if cardsCursor.focusingRiskKey != nil {
            if !selectionResults.filterWithRisks([cardsCursor.focusingRiskKey], inMeasurements: available).isEmpty {
                riskKey = cardsCursor.focusingRiskKey
            }
        }
        available = selectionResults.filterWithRisks([riskKey!], inMeasurements: allMeasurements)// default data
        
        setupWithPlayers([defaultUser], risks: [riskKey!], times: selectionResults.getDayTimeStringsInMeasurements(available))
        
//        // hint
//        let hintKey = "treeRingMapCenterHint"
//        if !userDefaults.bool(forKey: hintKey) && mapExplainView != nil && !TREERINGMAPHINT {
//            let hintVC = AbookHintViewController()
//            hintVC.blankAreaIsTouched = goToChooseTable
//            let area = CGRect(center: CGPoint(x: treeRingMap.mapCenter.x, y: treeRingMap.mapCenter.y - treeRingMap.mapCenterHeight * 0.5), width: treeRingMap.mapCenterHeight * 2.5, height: treeRingMap.mapCenterHeight * 1.5)
//            hintVC.focusOnFrame(view.convert(area, from: treeRingMap), hintText: "Please tap on dashboard to choose the data you want to view")
//            hintVC.hintKey = hintKey
//            overCurrentPresentController?.present(hintVC, animated: true, completion: nil)
//
//            TREERINGMAPHINT = true
//        }
    }
    
    fileprivate func relayoutForLandscape() {
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        let left = window!.safeAreaInsets.left
        let right = window!.safeAreaInsets.right
        
        let top =  window!.safeAreaInsets.top + navigationController!.navigationBar.frame.height
        let bottom = window!.safeAreaInsets.bottom
        let gapX = 10 * fontFactor
        
        chooseView.frame.origin = CGPoint(x: left + gapX, y: top - topGap)
        mapExplainView.frame.origin = CGPoint(x: width - right - gapX - mapExplainView.frame.width, y: top - topGap)
        topTitleLabel.frame = CGRect(x: left, y: top + bottomHeight, width: width - left - right, height: 20 * fontFactor)
        
        treeRingMap.frame = CGRect(x: left, y: topTitleLabel.frame.maxY, width: width - left - right, height: height - bottom - topTitleLabel.frame.maxY).insetBy(dx: gapX, dy: 0)
        treeRingMap.resizeWithStandardPoint()
    }
    
    // MARK: --------- actions
    override func backButtonClicked() {
        setScreenLandscape(false)
        
        tabBarController?.moreNavigationController.popViewController(animated: true)
//        navigationController?.popViewController(animated: true)
//
//        tabBarController?.selectedIndex = 0
//        (tabBarController?.viewControllers?[0] as! ABookNavigationController).popToRootViewController(animated: true)
    }
    
    func goToAssess() {
        setScreenLandscape(false)
        
        tabBarController?.selectedIndex = 0
        (tabBarController?.viewControllers?[0] as! ABookNavigationController).popToRootViewController(animated: true)
    }
    
    // choose action
    func changeType(_ index: Int) {
        chosenType = treeRingMapTypes[index]
        
        let hintKey = "hintNevershowFor\(chosenType.getNameOfType())"
        if userDefaults.bool(forKey: hintKey) {
            goToChooseTable()
        }else {
            showHintOfTreeRingMap(hintKey)
        }
    }
    
    fileprivate func showHintOfTreeRingMap(_ hintKey: String) {
        let hintVC = Bundle.main.loadNibNamed("TreeRingMapHintViewController", owner: self, options: nil)?.first as! TreeRingMapHintViewController
        hintVC.buttonIsTouched = goToChooseTable
        hintVC.setupWithType(chosenType, hintKey: hintKey)
        overCurrentPresentController?.present(hintVC, animated: true, completion: nil)
    }
    
    // tables
    fileprivate func goToChooseTable() {
        UIView.animate(withDuration: 0.2, delay: 0.1, options: .curveEaseIn, animations: {
            self.chooseView.transform = CGAffineTransform(translationX: 0, y: self.chooseOffsetY)
        }) { (true) in
            self.chooseView.setDisplayState(false)
            self.showChooseTable()
        }
    }
    
    func goToChooseOrHide() {
        if self.chooseView.transform == CGAffineTransform.identity {
            UIView.animate(withDuration: 0.2, animations: {
                self.chooseView.transform = CGAffineTransform(translationX: 0, y: self.chooseOffsetY)
            }) { (true) in
                self.chooseView.setDisplayState(false)
            }
        }else {
            self.chooseView.setDisplayState(true)
            UIView.animate(withDuration: 0.2, animations: {
                self.chooseView.transform = CGAffineTransform.identity
            })
        }
    }
    
    // show tables
    func showChooseTable() {
        let chooseVC = TreeRingMapDatabaseChooseViewController.createFromNib()
        chooseVC.setupWithType(chosenType)
        chooseVC.mapViewController = self
        
        presentOverCurrentViewController(chooseVC, completion: nil)
    }
    
    // map setup
    func setupWithPlayers(_ players: [String], risks: [String], times: [String]) {
        dataModel.type = chosenType
        topTitleLabel.text = chosenType.getOneLineName()
        
        // mapTable
        let mapTable = dataModel.loadDataWithPlayers(players, risks: risks, times: times)
        treeRingMap.loadMapWithDataTable([mapTable])
        
        // right data
        var userKey: String!
        var riskKey: String!
        var timeKey: String!
        switch chosenType {
        case .PersonGamesDates: userKey = players.first
        case .GamePeopleDates: riskKey = risks.first
        case .DatePeopleGames:  timeKey = times.first
        case .DatePeopleCards:
            riskKey = risks.first
            timeKey = times.first
        case .PersonCardsPeriod:
            userKey = players.first
            riskKey = risks.first
        }
        
        mapExplainView.display = true
        mapExplainView.transform = CGAffineTransform.identity
        mapExplainView.loadViewWithPlayer(userKey, risk: riskKey, time: timeKey)
    }
    
    func resignChange() {
        for (i, type) in treeRingMapTypes.enumerated() {
            if type == dataModel.type {
                chooseView.chosenTypeIndex = i
                chooseView.updateTable()
                
                break
            }
        }
    }
    
    
    // explain part
    func showOrHideExplain() {
        if self.mapExplainView.transform == CGAffineTransform.identity {
            UIView.animate(withDuration: 0.2, animations: {
                self.mapExplainView.transform = CGAffineTransform(translationX: 0, y: self.bottomHeight - self.mapExplainView.frame.height)
            }) { (true) in
                self.mapExplainView.display = false
            }
        }else {
            self.mapExplainView.display = true
            UIView.animate(withDuration: 0.2, animations: {
                self.mapExplainView.transform = CGAffineTransform.identity
            })
        }
    }
    
    // print
    @objc func printCurrentMap() {
        // set for print view
        navigationController?.setNavigationBarHidden(true, animated: true)
        chooseView.isHidden = true
        if !mapExplainView.display {
            showOrHideExplain()
        }
        mapExplainView.forPrint = true
        let oldOriginY = mapExplainView.frame.origin.y
        mapExplainView.frame.origin.y = 15
        if logo == nil {
            logo = UIImageView(image: UIImage(named: "treeRingMap_logo"))
            var logoFrame = CGRect(center: treeRingMap.mapCenter, length: treeRingMap.mapCenterHeight * 2)
            logoFrame = view.convert(logoFrame, from: treeRingMap)
            logo.frame = logoFrame
            view.addSubview(logo)
        }else {
            logo.isHidden = false
        }
        
        // use as data
        let mapImage = UIImage.imageFromView(view)!
        
        // set back
        chooseView.isHidden = false
        mapExplainView.forPrint = false
        mapExplainView.frame.origin.y = oldOriginY
        navigationController?.setNavigationBarHidden(false, animated: true)
        logo.isHidden = true
        
        let printReview = Bundle.main.loadNibNamed("TreeRingMapPrintReviewViewController", owner: self, options:  nil)?.first as! TreeRingMapPrintReviewViewController
        printReview.treeRingMapVC = self
        printReview.setWithImage(mapImage)
        presentOverCurrentViewController(printReview, completion: nil)
    }
    
    func printImage(_ image: UIImage) {
        // cut top
        if let printData = image.pngData() {
            if UIPrintInteractionController.canPrint(printData){
                let printInfo = UIPrintInfo(dictionary: nil)
                printInfo.outputType = .photo
                printInfo.jobName = "Print TreeRingMap"
                
                // print
                let printController = UIPrintInteractionController.shared
                printController.printInfo = printInfo
                printController.showsNumberOfCopies = true
                printController.printingItem = printData
                
                if ISPHONE {
                    printController.present(animated: true, completionHandler: nil)
                }else {
                    printController.present(from: printBarButton, animated: true, completionHandler: nil)
                }
            }else {
                // cannot print
            }
        }
    }
}
