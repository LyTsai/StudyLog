//
//  ABookHomePageViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class ABookHomePageViewController: UIViewController {
    // UI
    @IBOutlet weak var subLabel: UILabel!
    @IBOutlet weak var subDecoLabel: UILabel!
    
    @IBOutlet var bottomButtons: [UIButton]!
    
    @IBOutlet fileprivate weak var nextButton: UIButton!
    @IBOutlet fileprivate weak var slowAgingButton: UIButton!

    @IBOutlet fileprivate weak var slowAgingView: UIView!
    @IBOutlet fileprivate weak var sTopLabel: UILabel!
    @IBOutlet fileprivate weak var sBottomLabel: UILabel!
    
    @IBOutlet fileprivate weak var topTitleBackLabel: UILabel!
    @IBOutlet fileprivate weak var topTitleLabel: UILabel!
    @IBOutlet fileprivate weak var bottomTitleBackLabel: UILabel!
    @IBOutlet fileprivate weak var bottomTitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var sNextButton: UIButton!

    // data
    fileprivate var applicationAccess: ApplicationAccess!
    fileprivate var processBar: DownloadingBarProcess!

    // for loading riskClasses
    fileprivate var applicationClassAccess: ApplicationClassAccess!
    fileprivate var downloading: DownloadingBarProcess!
    
    // data specific for this applciation domain (slowagingbydesign)
    // subject groups
    fileprivate var riskClassGroup = [MetricGroupObjModel]()
    fileprivate var metricGroupAccess: MetricGroupAccess!
    //  risk assessment types
    fileprivate var allRiskTypes = [RiskTypeObjModel]()
    fileprivate var riskAccess: RiskAccess!
    
    fileprivate var slowAgingApplicationClassKey: String! {
        return AppTopic.SlowAgingByDesign.getTopicKey()
    }
    
    // light
    @IBOutlet fileprivate weak var spinner: UIImageView!
    fileprivate var dotTimer: Timer!
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()

        GameTintApplication.sharedTint.appTopic = .SlowAgingByDesign
        navigationController?.navigationBar.isHidden = true
        slowAgingView.isHidden = true
        
        for button in bottomButtons {
            button.layer.shadowRadius = 3 * fontFactor
            button.layer.shadowOffset = CGSize.zero
            button.layer.shadowOpacity = 1
            button.layer.shadowColor = UIColorFromHex(0xB3FE6F).cgColor
        }
        
        // check data
        if !ApplicationDataCenter.sharedCenter.loadedFromNet {
            // application keys
            applicationAccess = ApplicationAccess(callback: self)
            
            // load
            applicationAccess.getOneByKey(key: AnnieLyticxSlowAgingByDesign)
            
            slowAgingButton.isEnabled = false
            nextButton.isHidden = true
            createProcessBar(0.01, firstPage: true)
        }
     
        // fonts
        let subString = "IAaaS®: Individualized Assessment as a Service\n"
        let subFont = UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)
        let appendString = "The Gamification of Individualized Assessments"
        let subAttributedString = NSMutableAttributedString(string: subString, attributes: [ .font: subFont, .foregroundColor : UIColor.white])
        let appendAttributedString = NSMutableAttributedString(string: appendString, attributes: [ .font: UIFont.systemFont(ofSize: 12 * fontFactor), .foregroundColor : UIColorFromHex(0xD1FFA2)])
        subAttributedString.append(appendAttributedString)
        subLabel.attributedText = subAttributedString
        
        subAttributedString.addAttributes([ .strokeColor: UIColor.black, .strokeWidth: NSNumber(value: -15)], range: NSMakeRange(0, subString.count + appendString.count))
        subDecoLabel.attributedText = subAttributedString
        
        // page2
        let labelFont = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        sTopLabel.font = labelFont
        sBottomLabel.font = labelFont
    
        let titleFont = UIFont.systemFont(ofSize: 22 * fontFactor, weight: .heavy)
        topTitleLabel.font = titleFont
        bottomTitleLabel.font = titleFont
        
        let topAttri = [NSAttributedString.Key.font: titleFont, .strokeColor: UIColorFromRGB(0, green: 9, blue: 171), .strokeWidth: NSNumber(value: 20)]
        let bottomAttri = [NSAttributedString.Key.font: titleFont, .strokeColor: UIColorFromRGB(182, green: 0, blue: 0), .strokeWidth: NSNumber(value: 20)]
        topTitleBackLabel.attributedText = NSAttributedString(string: "The \"Blue Zones\"", attributes: topAttri)
        bottomTitleBackLabel.attributedText = NSAttributedString(string: "The \"Red Zones\"", attributes: bottomAttri)
        
        // shadows
        topTitleBackLabel.layer.addBlackShadow(6 * fontFactor)
        topTitleBackLabel.layer.shadowOffset = CGSize(width: 0, height: 4 * fontFactor)
        bottomTitleBackLabel.layer.addBlackShadow(6 * fontFactor)
        bottomTitleBackLabel.layer.shadowOffset = CGSize(width: 0, height: 4 * fontFactor)
    }

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       // dot
        if dotTimer == nil {
            var angle = CGFloat(Double.pi) * 7 / 6
            self.dotTimer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { (timer) in
                self.spinner.transform = CGAffineTransform(rotationAngle: angle)
                angle += 0.018
    
                if angle > 2 * CGFloat(Double.pi) {
                    angle -= 2 * CGFloat(Double.pi)
                }
            })
        }
        
        // button
        for (i, button) in bottomButtons.enumerated() {
            let basicAnimation = CABasicAnimation(keyPath: "position")
            basicAnimation.duration = 2
            basicAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            basicAnimation.fromValue = button.center
            
            let desY = (i == 1 ? subLabel.frame.maxY + button.frame.height * 0.5 : nextButton.frame.maxY - button.frame.height * 0.5)
            basicAnimation.toValue = CGPoint(x: button.center.x, y: desY)
            basicAnimation.autoreverses = true
            basicAnimation.repeatCount = 2000
            button.layer.add(basicAnimation, forKey: nil)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if dotTimer != nil {
            dotTimer.invalidate()
            dotTimer = nil
        }
        
        for button in bottomButtons {
            button.layer.removeAllAnimations()
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func enableButtons() {
        endProcessBar(true)
        slowAgingButton.isEnabled = true
    }
    
    // slow aging by design
    @IBAction func slowAgingTouched(_ sender: Any) {
        let typesVC = HomeTypesDescriptionViewController()
        typesVC.modalTransitionStyle = .flipHorizontal
        typesVC.modalPresentationStyle = .overCurrentContext
        present(typesVC, animated: true, completion: nil)
    }
    
    // button is touched
    @IBAction func bottomButtonIsTouched(_ sender: UIButton) {
 
    }
    
    @IBAction func goToNext() {
        loadGroups()
    }
    
    @IBAction func sNextButtonClicked(_ sender: Any) {
        presentTabAndLandingPage()
    }
    fileprivate func presentTabAndLandingPage() {
        let tabbar = storyboard?.instantiateViewController(withIdentifier: TABBARID) as! ABookTabBarController
        tabbar.selectedIndex = 0

        GameTintApplication.sharedTint.focusingTierIndex = -1
        navigationController?.pushViewController(tabbar, animated: true)
    }
    
    // data
    fileprivate var typeCursor: Int = 0
    fileprivate var groupCursor: Int = 0
    
}

// loading riskClasses
extension ABookHomePageViewController {
    fileprivate func loadGroups() {
        let applicationClassKey = ApplicationDataCenter.sharedCenter.riskCategoryKey!
        if !collection.metricGroupsLoadedForApplicationClass(applicationClassKey) {
            // change UI
            sNextButton.isHidden = true
            // load risk class
            // subject groups specific for this application (slowagingbydesign) only
            applicationClassAccess = ApplicationClassAccess(callback: self)
            applicationClassAccess.getMetricGroupsByKey(applicationClassKey)
            
            createProcessBar(0.01, firstPage: false)
        } else {
            checkAndLoadRiskClasses()
        }
    }
    
    // MARK: ---------- move on
    fileprivate func checkAndLoadRiskClasses() {
        var needLoad = false
        for i in groupCursor..<riskClassGroup.count {
            let group = riskClassGroup[groupCursor]
            if !collection.metricsLoadedForGroup(group.key) {
                groupCursor = i
                needLoad = true
                metricGroupAccess = MetricGroupAccess(callback: self)
                break
            }
        }
        
        if needLoad {
            // load metrics
            metricGroupAccess.getMetricsByKey(riskClassGroup[groupCursor].key)
            if downloading == nil {
                createProcessBar(0.01, firstPage: false)
            }
        }else {
            checkRiskTypes()
        }
    }
    
    fileprivate func loadRiskByRiskTypes() {
        typeCursor = 0
        
        // ignore iFa
        for type in allRiskTypes {
            if type.name!.lowercased().contains("ifa") {
                collection.loadRisks([], riskTypeKey: type.key, fromNet: true)
                break
            }
        }

        // load risks
        for type in allRiskTypes {
            if collection.risksLoadedForTypeFromNet(type.key) {
                typeCursor += 1
            }else {
                riskAccess = RiskAccess(callback: self)
                riskAccess.getRisksByRiskType(type.key)
                
                sNextButton.isHidden = true
                if downloading == nil {
                    createProcessBar(0.01, firstPage: false)
                }
                
                break
            }
        }
        
        if typeCursor == allRiskTypes.count {
            // all loaded
            endProcessAndPush()
        }
    }
    
    fileprivate func createProcessBar(_ dValue: CGFloat, firstPage: Bool) {
        slowAgingView.isHidden = firstPage
        if downloading != nil {
            downloading.startProcess()
        }else {
            let barFrame = CGRect(x: 0, y: height - 15 * standHP, width: width, height: 15 * standHP).insetBy(dx: -fontFactor, dy: 0)
            downloading = DownloadingBarProcess.createWithFrame(barFrame, onView: view, dValue: dValue)
        }
    }
    
    fileprivate func checkRiskTypes() {
        if !collection.riskTypeLoadedFromNet {
            // change UI
            sNextButton.isHidden = true
            // get data
            if applicationClassAccess == nil {
                applicationClassAccess = ApplicationClassAccess(callback: self)
            }
            
            if let riskTypeKey = ApplicationDataCenter.sharedCenter.riskTypeKey {
                applicationClassAccess.getRiskTypesByKey(riskTypeKey)
                if downloading == nil {
                    createProcessBar(0.01, firstPage: false)
                }
            }
        }else {
            allRiskTypes = collection.getAllRiskTypes()
            loadRiskByRiskTypes()
        }
    }
    
    fileprivate func endProcessAndPush() {
        if downloading == nil {
            presentTabAndLandingPage()
        }else {
            downloading.processIsFinished({
                self.sNextButton.isHidden = false
                self.downloading = nil
            })
        }
    }
    
    fileprivate func endProcessBar(_ firstPage: Bool) {
        if downloading != nil {
            downloading.processIsFinished({
                if firstPage {
                    self.nextButton.isHidden = false
                }else {
                    self.sNextButton.isHidden = false
                }
                self.downloading = nil
            })
        }
    }
}

// data of application data
extension ABookHomePageViewController: DataAccessProtocal {
    func didFinishGetDataByKey(_ obj: AnyObject) {
        if obj is ApplicationObjModel {
            let application = obj as! ApplicationObjModel
            let applicationDic = application.applicationClassDic
            // show buttons
            ApplicationDataCenter.sharedCenter.updateDictionary(applicationDic)
            ApplicationDataCenter.sharedCenter.loadedFromNet = true
            enableButtons()
            
            // dataBase
            if localDB.database.open() {
                application.saveToLocalDatabase()
                localDB.database.close()
            }
        }
    }
    
    func failedGetDataByKey(_ error: String) {
        print(error)
        if processBar != nil {
            processBar.pauseProcess()
        }
    
        if USERECORD && ApplicationDataCenter.sharedCenter.riskCategoryKey != nil {
            self.enableButtons()
        }else {
            collection.getApplicationFromLocal()
            if downloading != nil {
                downloading.pauseProcess()
            }
            // no record or ask for reload
            let alert = UIAlertController(title: "Experiencing excessive network latency delay.", message: "You can check your net state and Reload or use record", preferredStyle: .alert)
            let action = UIAlertAction(title: "Reload", style: .default, handler: { (action) in
                // try to reload data
                self.applicationAccess.getOneByKey(key: AnnieLyticxSlowAgingByDesign)
                self.createProcessBar(0.01, firstPage: true)
            })
            alert.addAction(action)
            
            // has record, can use record
            if ApplicationDataCenter.sharedCenter.riskCategoryKey != nil {
                let useRecord = UIAlertAction(title: "Use Record", style: .default, handler: { (action) in
                    USERECORD = true
                    self.enableButtons()
                })
                
                alert.addAction(useRecord)
            }
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    // riskClasses
    func didFinishGetAttribute(_ obj: [AnyObject]) {
        if obj is [MetricGroupObjModel]  {
            riskClassGroup = obj as! [MetricGroupObjModel]
            collection.loadMetricGroups(riskClassGroup, applicationClassKey: slowAgingApplicationClassKey, fromNet: true)
            groupCursor = 0
            checkAndLoadRiskClasses()
        }else if obj is [MetricObjModel] {
            // get metrics
            collection.updateRiskClasses(obj as! [MetricObjModel], withMetricGroup: riskClassGroup[groupCursor].key, fromNet: true)
            
            // get next risk category data
            groupCursor += 1
            if groupCursor < riskClassGroup.count {
                checkAndLoadRiskClasses()
            }else {
                checkRiskTypes()
            }
        }else if obj is [RiskTypeObjModel] {
            allRiskTypes = obj as! [RiskTypeObjModel]
            collection.updateRiskTypes(allRiskTypes, fromNet: true)
            loadRiskByRiskTypes()
        }else if obj is [RiskObjModel] {
            collection.loadRisks(obj as! [RiskObjModel], riskTypeKey: allRiskTypes[typeCursor].key, fromNet: true)
            if typeCursor == allRiskTypes.count {
                // last is loaded
                endProcessAndPush()
            }else {
                // next
                typeCursor += 1
                while collection.risksLoadedForTypeFromNet(allRiskTypes[typeCursor].key) {
                    typeCursor += 1
            
                    if typeCursor == allRiskTypes.count {
                        endProcessAndPush()
                        return
                    }
                }
                riskAccess.getRisksByRiskType(allRiskTypes[typeCursor].key)
            }
        }
    }
    
    // reload
    func failedGetAttribute(_ error: String) {
        downloading.pauseProcess()

        // TODO: --- with data
        if USERECORD {
            collection.updateRiskTypes([], fromNet: false)
            
            if let classkey = slowAgingApplicationClassKey {
                collection.loadMetricGroupsFromLocal(classkey)
                riskClassGroup = collection.getMetricGroupsForApplicationClassKey(classkey)

                for group in riskClassGroup {
                    collection.updateRiskClasses([], withMetricGroup:group.key, fromNet: false)
                }
                
                collection.loadRisks([], riskTypeKey: "", fromNet: false)
            }
            endProcessAndPush()
        }else {
            let errorAlert = UIAlertController(title: "Error!!!", message: "Net Error", preferredStyle: .alert)
            let reloadAction = UIAlertAction(title: "Reload", style: .cancel, handler: { (action) in
                self.loadGroups()
            })
            errorAlert.addAction(reloadAction)
        }
    }
}
