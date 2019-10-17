//
//  GroupsRoadCollectionView.swift
//  AnnielyticX
//
//  Created by Lydire on 2019/5/11.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class GroupsRoadCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    fileprivate let roadDraw = RoadDrawModel()
    fileprivate var data = [(MetricGroupObjModel, [MetricObjModel])]()
    fileprivate var riskTypesView: RiskTypesDisplayView!

    class func createWithFrame(_ frame: CGRect, data: [(MetricGroupObjModel, [MetricObjModel])]) -> GroupsRoadCollectionView {
        // layout
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let oneSize = frame.width / 375
        let headerHeight = 45 * oneSize
        layout.headerReferenceSize = CGSize(width: frame.width, height: headerHeight)
        //cell
        let gap = oneSize * 10
        layout.minimumInteritemSpacing = gap
        layout.minimumLineSpacing = gap
        
        let left = 113 * oneSize
        let right = 30 * oneSize
        layout.sectionInset = UIEdgeInsets(top: gap, left: left, bottom: gap, right: right)
        
        layout.itemSize = CGSize(width: 110 * oneSize, height: 67 * oneSize)
        
        // create
        let collectionView = GroupsRoadCollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor.clear
        collectionView.data = data
        collectionView.roadDraw.roadPlayedColor = UIColorFromHex(0x346AD9)
        collectionView.roadDraw.turningRadius = 30 * oneSize
        collectionView.roadDraw.roadWidth = 15 * oneSize
        
        // register
        collectionView.register(GroupRoadHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: groupRoadHeaderID)
        collectionView.register(GroupRoadCell.self, forCellWithReuseIdentifier: groupRoadCellID)
        
        // delegate
        collectionView.dataSource = collectionView
        collectionView.delegate = collectionView
        
        
        return collectionView
    }
    
    // data source
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].1.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: groupRoadCellID, for: indexPath) as! GroupRoadCell
        let metric = data[indexPath.section].1[indexPath.row]
        let group = data[indexPath.section].0
        cell.configureWithImageUrl(metric.imageUrl, name: metric.name, color: group.color ?? UIColor.cyan)
 
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let group = data[indexPath.section].0
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: groupRoadHeaderID, for: indexPath) as! GroupRoadHeaderView
        header.configureWithIcon(group.imageUrl, name: group.name, color: group.color ?? UIColor.cyan)
        
        return header
    }
    
    // delegate
    // MARK: -------- road display
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        setupRoad()
        setNeedsDisplay()
    }
    
    // road
    fileprivate func setupRoad() {
        let middleX = frame.width / 375 * (45 * 1.5)
        let gap = middleX * 0.6
        let startPoint = CGPoint(x: middleX, y: frame.width / 375 * (45 * 0.6))
        roadDraw.startPoint = startPoint
        // nodes
        var anchors = [(CGPoint, Bool)]()
        for i in 0..<Int(contentSize.height / gap + 3) {
            var offset: CGFloat = 0
            if i % 3 == 2 {
                offset = middleX * 0.4
            }else if i % 3 == 1 {
                offset = -middleX * 0.5
            }else {
                offset = 0
            }
            
            anchors.append(( CGPoint(x: middleX + offset, y: CGFloat(i) * gap + startPoint.y) , true))
        }
        
        roadDraw.anchorInfo = anchors
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if riskTypesView != nil {
            setupOneFrame()
            
            if riskTypesView.frame.minY < frame.minY || riskTypesView.frame.minY >= frame.maxY {
                riskTypesView.isHidden = true
            }

        }
        
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        roadDraw.drawRoadWithMaxX(113 * bounds.width / 375)
    }
    
    // MARK: -------- data loading
    fileprivate var riskAccess: RiskAccess!
    fileprivate var riskTypeAccess: RiskTypeAccess!
    fileprivate let loadingVC = LoadingViewController()
    fileprivate var metricKey: String!
    fileprivate var riskTypes = [String]() {
        didSet{
            riskTypeCursor = 0
        }
    }
    fileprivate var riskTypeCursor = 0
    fileprivate var chosenIndexPath: IndexPath!
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if chosenIndexPath != nil && indexPath == chosenIndexPath {
            if riskTypesView != nil {
                riskTypesView.isHidden = !riskTypesView.isHidden
                
                if !riskTypesView.isHidden {
                    setupOneFrame()
                }
                return
            }
        }
        
        if riskTypesView != nil {
            riskTypesView.isHidden = true
        }
        
        let metric = data[indexPath.section].1[indexPath.row]
        self.metricKey = metric.key
        
        self.chosenIndexPath = indexPath
        
        // scroll
        performBatchUpdates({
            self.scrollToItem(at: indexPath, at: .top, animated: true)
        }) { (true) in
            if metric.key == facialRejuvenationMetricKey {
                // TODO: ----------- facial
                // open
                self.visitOtherApp()
            }else {
            
                self.metricCellIsChosen()
            }
        }
    }
    
    fileprivate func visitOtherApp() {
        if let urlShemes = URL(string: "facialRejuvenationByDesign://") {
            if UIApplication.shared.canOpenURL(urlShemes) {
                let alert = UIAlertController(title: "Will leave to vist facial Rejuvenation by design", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let leave = UIAlertAction(title: "OK", style: .default) { (action) in
                    UIApplication.shared.open(urlShemes, options: [:], completionHandler: nil)
                }
                alert.addAction(cancel)
                alert.addAction(leave)
                self.viewController.present(alert, animated: true, completion: nil)
            }else {
                // can not open
                let alert = UIAlertController(title: "Facial Rejuvenation by design is not installed", message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Visit in this app", style: .cancel){ (action) in
                    self.metricCellIsChosen()
                }
                let leave = UIAlertAction(title: "Search in store", style: .default) { (action) in
                    //                        let appstoreUrl = URL(string: "")
                    //                        UIApplication.shared.open(appstoreUrl, options: [:], completionHandler: nil)
                }
                alert.addAction(leave)
                alert.addAction(cancel)
                self.viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    fileprivate func metricCellIsChosen() {
        if userCenter.userState == .login {
            self.checkAndLoadRisks()
        }else {
            let login = LoginViewController.createFromNib()
            login.invokeFinishedClosure = self.checkAndLoadRisks
            self.navigation.pushViewController(login, animated: true)
        }
    }
    
    fileprivate func checkAndLoadRisks() {
        if !collection.risksLoadedForMetric(metricKey) {
            if riskAccess == nil {
                riskAccess = RiskAccess(callback: self)
            }
            
            // present loading view controller
            viewController.present(loadingVC, animated: true) {
                self.riskAccess.getRisksByMetric(self.metricKey)
            }
        }else {
            let risks = collection.getAllRisksOfRiskClass(metricKey)
            var allTypes = Set<String>()
            for riskKey in risks {
                if let risk = collection.getRisk(riskKey) {
                    if let riskTypeKey = risk.riskTypeKey {
                        allTypes.insert(riskTypeKey)
                    }
                }
            }
            riskTypes = Array(allTypes)
            riskTypeCursor = 0
            checkAndLoadRiskTypes()
        }
    }
    
    
    fileprivate func checkAndLoadRiskTypes() {
        var neeedLoad = false

        // check each riskType
        for i in riskTypeCursor..<riskTypes.count {
            let riskTypeKey = riskTypes[i]
            
            // not loaded
            if !collection.riskTypeIsLoaded(riskTypeKey) {
                 neeedLoad = true
                
                // not loaded
                riskTypeCursor = i
               
                if riskTypeAccess == nil {
                    riskTypeAccess = RiskTypeAccess(callback: self)
                }
                
                if !loadingVC.isLoading {
                    viewController.present(loadingVC, animated: true, completion: {
                        self.riskTypeAccess.getOneByKey(key: riskTypeKey)
                    })
                }else {
                    riskTypeAccess.getOneByKey(key: riskTypeKey)
                }
                
                return
            }
        }
        
        if !neeedLoad {
            dataAllLoaded()
        }
    }
    
    fileprivate func dataAllLoaded() {
        cardsCursor.selectedRiskClassKey = metricKey
        if riskTypes.count == 1 {
            cardsCursor.riskTypeKey = riskTypes.first!
            goToIntroPageForPlay()
        }else if riskTypes.isEmpty {
            cardsCursor.riskTypeKey = nil
            let catAlert = CatCardAlertViewController()
            catAlert.addTitle("No RiskType Is Loaded", subTitle: "Coming Soon", buttonInfo: [("Got It", false, visitIntroView)])
            if loadingVC.isLoading {
                loadingVC.dismiss(animated: true) {
                    self.viewController.presentOverCurrentViewController(catAlert, completion: nil)
                }
            }else {
                viewController.presentOverCurrentViewController(catAlert, completion: nil)
            }
            
        }else {
            // more than one
            if loadingVC.isLoading {
                loadingVC.dismiss(animated: true) {
                }
            }
            riskTypes.sort(by: {collection.getRiskTypeByKey($0)?.seqNumber ?? 0 < collection.getRiskTypeByKey($1)?.seqNumber ?? 0})
         
            // location
            if riskTypesView == nil {
                riskTypesView = RiskTypesDisplayView.createWithOneFrame(CGRect.zero)
                riskTypesView.layer.borderWidth = fontFactor
                riskTypesView.cellIsChosen = goToIntroPageForPlay
                
                superview?.addSubview(riskTypesView)
            }
            
            setupOneFrame()
            
            // load again
            riskTypesView.isHidden = false
            let group = data[chosenIndexPath.section].0
            riskTypesView.layer.borderColor = group.color?.cgColor ?? tabTintGreen.cgColor
            riskTypesView.setupWithRiskTypes(riskTypes)
        }
    }
    
    // risk type view
    fileprivate func setupOneFrame() {
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellRect = layout.layoutAttributesForItem(at: chosenIndexPath)!.frame
        var typeOneFrame = CGRect(x: cellRect.minX, y: cellRect.maxY, width: cellRect.width, height: cellRect.height * 0.8)
        typeOneFrame = convert(typeOneFrame, to: superview)
        riskTypesView.setupOneFrame(typeOneFrame)
    }
    
    // go to game play view
    func goToIntroPageForPlay() {
        if riskTypesView != nil {
            riskTypesView.isHidden = true
        }
        
        let riskTypeKey = cardsCursor.riskTypeKey!
        let metricKey = cardsCursor.selectedRiskClassKey!
        let keyString = "noLongShowFor\(String(describing: riskTypeKey))"
       
        // should show
        if userDefaults.bool(forKey: keyString) {
            if loadingVC.isLoading {
                loadingVC.dismiss(animated: true) {
                    self.visitIntroView()
                }
            }else {
                visitIntroView()
            }
        }else {
            // show hint
            let typeHint = Bundle.main.loadNibNamed("MetricIntroductionViewController", owner: self, options: nil)?.first as! MetricIntroductionViewController
            typeHint.buttonIsSelected = visitIntroView
            typeHint.setupWithRiskType(riskTypeKey, metricKey: metricKey, keyString: keyString)
            
            if loadingVC.isLoading {
                loadingVC.dismiss(animated: true) {
                    self.viewController.presentOverCurrentViewController(typeHint, completion: nil)
                }
            }else {
                viewController.presentOverCurrentViewController(typeHint, completion: nil)
            }
        }
    }
    
    fileprivate func visitIntroView() {

        let intro = IntroPageViewController()
        navigation.setNavigationBarHidden(false, animated: true)
        if loadingVC.isLoading {
            loadingVC.dismiss(animated: true) {
                self.navigation.pushViewController(intro, animated: true)
            }
        }else {
            self.navigation.pushViewController(intro, animated: true)
        }
    }
}

// data loading
extension GroupsRoadCollectionView: DataAccessProtocal {
    // risk
    func didFinishGetAttribute(_ obj: [AnyObject]) {
        if obj is [RiskObjModel] {
            let risks = obj as! [RiskObjModel]
            collection.loadRisks(risks, metricKey: metricKey, fromNet: true)
            var allTypes = Set<String>()
            for risk in risks {
                if let riskTypeKey = risk.riskTypeKey {
                    allTypes.insert(riskTypeKey)
                }
            }
            riskTypes = Array(allTypes)
            riskTypeCursor = 0
            
            checkAndLoadRiskTypes()
        }
    }
    
    func failedGetAttribute(_ error: String) {
        let catAlert = CatCardAlertViewController()
        catAlert.addTitle("Load Games Error", subTitle: error, buttonInfo: [("Got It", false, nil), ("Reload", true, checkAndLoadRisks)])
        loadingVC.dismiss(animated: true) {
            self.viewController.presentOverCurrentViewController(catAlert, completion: nil)
        }
    }
    
    // riskType
    func didFinishGetDataByKey(_ obj: AnyObject) {
        if obj is RiskTypeObjModel {
            collection.updateRiskTypes([obj as! RiskTypeObjModel], fromNet: true)
            riskTypeCursor += 1
            
            checkAndLoadRiskTypes()
        }else {
            print("type is wrong")
        }
    }
    
    func failedGetDataByKey(_ error: String) {
        let catAlert = CatCardAlertViewController()
        catAlert.addTitle("Get RiskTypeError", subTitle: error, buttonInfo: [("Got It", false, nil), ("Reload", true, checkAndLoadRisks)])
        loadingVC.dismiss(animated: true) {
            self.viewController.presentOverCurrentViewController(catAlert, completion: nil)
        }
    }
}
