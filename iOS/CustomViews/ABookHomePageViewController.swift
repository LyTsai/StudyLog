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
    
    @IBOutlet weak var desDecoLabel: UILabel!
    @IBOutlet weak var desLabel: UILabel!
    
    @IBOutlet var bottomButtons: [UIButton]!
    @IBOutlet weak var bottomDetailView: UIView!
    
    @IBOutlet fileprivate weak var nextButton: UIButton!
    @IBOutlet fileprivate weak var slowAgingButton: UIButton!

    @IBOutlet fileprivate weak var slowAging: UIImageView!
    @IBOutlet fileprivate weak var webSiteLabel: UILabel!

    @IBOutlet fileprivate weak var slowAgingView: UIView!
    @IBOutlet fileprivate weak var sTopLabel: UILabel!
    @IBOutlet fileprivate weak var sBottomLabel: UILabel!
    
    @IBOutlet fileprivate weak var topTitleBackLabel: UILabel!
    @IBOutlet fileprivate weak var topTitleLabel: UILabel!
    @IBOutlet fileprivate weak var bottomTitleBackLabel: UILabel!
    @IBOutlet fileprivate weak var bottomTitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var sNextButton: UIButton!

    // data
    fileprivate var launched: Bool {
        return userDefaults.bool(forKey: "launched")
    }
    fileprivate var applicationAccess: ApplicationAccess!
    fileprivate var processBar: DownloadingBarProcess!

    // for loading riskClasses
    fileprivate var applicationClassAccess: ApplicationClassAccess!
    fileprivate var downloading: DownloadingBarProcess!
    // data
    fileprivate var riskClassGroup = [MetricGroupObjModel]()
    fileprivate var metricGroupAccess: MetricGroupAccess!
    
    fileprivate var allRiskTypes = [RiskTypeObjModel]()
    fileprivate var riskAccess: RiskAccess!
    
    // light
    @IBOutlet fileprivate weak var spinner: UIImageView!
    fileprivate var timer: Timer!
    
    // view did load
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isHidden = true
        bottomDetailView.isHidden = true
        
        // check data
        if !ApplicationDataCenter.sharedCenter.loadedFromNet {
            setAllThreeHidden(true)
            
            nextButton.isEnabled = false
            slowAgingButton.isEnabled = false
            
            // application keys
            applicationAccess = ApplicationAccess(callback: self)

            // load
            applicationAccess.getOneByKey(key: AnnieLyticxSlowAgingByDesign)
            
            processBar = DownloadingBarProcess()
            processBar.addProcessFrame(CGRect(x: 5, y: slowAgingButton.frame.maxY, width: width - 10, height: desLabel.frame.minY - slowAgingButton.frame.maxY), onView: view)
        }
     
        // fonts
        let subString = "IAaaS®: Individualized Assessment as a Service\n"
        let subFont = UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)
        let appendString = "The Gamification of Individualized Assessments"
        let subAttributedString = NSMutableAttributedString(string: subString, attributes: [ .font: subFont, .foregroundColor : UIColor.white])
        let appendAttributedString = NSMutableAttributedString(string: appendString, attributes: [ .font: UIFont.systemFont(ofSize: 12 * fontFactor), .foregroundColor : UIColorFromHex(0xD1FFA2)])
        subAttributedString.append(appendAttributedString)
        subLabel.attributedText = subAttributedString
        
        subAttributedString.addAttributes([ .strokeColor: UIColor.black,  .strokeWidth: NSNumber(value: -15)], range: NSMakeRange(0, subString.count + appendString.count))
        subDecoLabel.attributedText = subAttributedString
        
        let desString = "AnnielyticX \"IA\"\n(Individualized Assessment) mobile game app:\nAdd More Years to Your Life and\nMore Life to Your Years"
        desLabel.text = desString
        let desFont = UIFont.italicSystemFont(ofSize: 12 * fontFactor)
        desLabel.font = desFont
        desDecoLabel.attributedText = NSAttributedString(string: desString, attributes: [ .font: desFont,  .strokeColor: UIColor.black,  .strokeWidth: NSNumber(value: -15)])
        
        webSiteLabel.font = UIFont.systemFont(ofSize: 12 * fontFactor, weight: .semibold)
        
        // page2
        let labelFont = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
        sTopLabel.font = labelFont
        sBottomLabel.font = labelFont
    
        let titleFont = UIFont.systemFont(ofSize: 22 * fontFactor, weight: .heavy)
        topTitleLabel.font = titleFont
        bottomTitleLabel.font = titleFont
        
        let topAttri = [NSAttributedStringKey.font: titleFont, .strokeColor: UIColorFromRGB(0, green: 9, blue: 171), .strokeWidth: NSNumber(value: 20)]
        let bottomAttri = [NSAttributedStringKey.font: titleFont, .strokeColor: UIColorFromRGB(182, green: 0, blue: 0), .strokeWidth: NSNumber(value: 20)]
        topTitleBackLabel.attributedText = NSAttributedString(string: "The \"Blue Zones\"", attributes: topAttri)
        bottomTitleBackLabel.attributedText = NSAttributedString(string: "The \"Red Zones\"", attributes: bottomAttri)
        
        // shadows
        nextButton.layer.addBlackShadow(6 * fontFactor)
        topTitleBackLabel.layer.addBlackShadow(6 * fontFactor)
        topTitleBackLabel.layer.shadowOffset = CGSize(width: 0, height: 4 * fontFactor)
        bottomTitleBackLabel.layer.addBlackShadow(6 * fontFactor)
        bottomTitleBackLabel.layer.shadowOffset = CGSize(width: 0, height: 4 * fontFactor)
    }
    
    fileprivate var emitters = [CAEmitterLayer]()
    
    func addOnView(_ backView: UIView, pathCenter: CGPoint, pathRadius: CGFloat) -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        backView.layer.addSublayer(emitterLayer)
        
        emitterLayer.frame = backView.bounds
        emitterLayer.emitterPosition = CGPoint(x: backView.bounds.midX, y: 0)
        emitterLayer.emitterSize = CGSize(width: 10, height: 10)
        emitterLayer.renderMode = kCAEmitterLayerUnordered
        emitterLayer.emitterShape = kCAEmitterLayerPoint
        
        let emitterCell = CAEmitterCell()
        let cellImage = UIImage(named: "butterfly")!
        emitterCell.contents = cellImage.cgImage
        emitterCell.scale = 0.04 * backView.bounds.height / cellImage.size.height
        emitterCell.color = UIColor.white.cgColor
        
        emitterCell.birthRate = 3
        emitterCell.lifetime = 1.5
        emitterCell.lifetimeRange = 0.4
        
        emitterCell.velocity = 10 * fontFactor
        emitterCell.velocityRange = 15 * fontFactor
        emitterCell.alphaSpeed = -0.4
        emitterCell.emissionRange = CGFloat(Double.pi) * 2
        
        emitterLayer.emitterCells = [emitterCell]
        
        let keyAnimation = CAKeyframeAnimation()
        keyAnimation.path = UIBezierPath(arcCenter: pathCenter, radius: pathRadius, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true).cgPath
        keyAnimation.repeatCount = 2000
        keyAnimation.duration = 1.5
        keyAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        emitterLayer.add(keyAnimation, forKey: "emitterPosition")
        
        return emitterLayer
    }
    
    func setUIState(_ loading: Bool) {
        let buttonHidden = (loading || processBar != nil || !launched)
        setAllThreeHidden(buttonHidden)
        nextButton.isHidden = loading
        slowAgingButton.isHidden = loading
        webSiteLabel.isHidden = loading
        
        slowAging.isHidden = !loading
        slowAgingView.isHidden = !loading
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setUIState(false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if timer == nil {
            var angle = CGFloat(Double.pi) * 7 / 6
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { (timer) in
                self.spinner.transform = CGAffineTransform(rotationAngle: angle)
                angle += 0.018
    
                if angle > 2 * CGFloat(Double.pi) {
                    angle -= 2 * CGFloat(Double.pi)
                }
            })
        }
        
        // hint
        let pathRadius = bottomButtons.first!.bounds.width * 0.34
        emitters.removeAll()
        for button in bottomButtons {
            let emitter = addOnView(button, pathCenter: CGPoint(x: button.bounds.midX + getOffsetXOfButton(button), y: button.bounds.height * 0.57), pathRadius: pathRadius)
            emitters.append(emitter)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        // remove animations
        for emitter in emitters {
            emitter.removeFromSuperlayer()
        }
        
        emitters.removeAll()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if processBar != nil {
            processBar.resetFrame(CGRect(x: 5, y: slowAgingButton.frame.maxY, width: width - 10, height: desDecoLabel.frame.minY - slowAgingButton.frame.maxY))
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func removeProcessAndDisplay() {
        if processBar != nil {
            processBar.processIsFinished()
            DispatchQueue.main.asyncAfter(deadline: .now() + processBar.endTimeInterval) {
                self.processBar.endProcess()
                self.processBar = nil
                self.displayButtons()
            }
        }else {
            displayButtons()
        }
    }
    
    func displayButtons() {
        // first load?
        if !launched {
            userDefaults.set(true, forKey: allowVoiceKey)
            userDefaults.synchronize()
            setAllThreeHidden(true)
        }else {
            // loaded before
            setAllThreeHidden(false)
        }
        
        nextButton.isEnabled = true
        slowAgingButton.isEnabled = true
    }
    
    fileprivate func setAllThreeHidden(_ buttonHidden: Bool) {
        for button in bottomButtons {
            button.isHidden = buttonHidden
        }
    }
    
    // slow aging by design
    @IBAction func slowAgingTouched(_ sender: Any) {
        let typesVC = HomeTypesDescriptionViewController()
        typesVC.modalTransitionStyle = .flipHorizontal
        typesVC.modalPresentationStyle = .overCurrentContext
        present(typesVC, animated: true, completion: nil)
    }
    
    // button is touched
    fileprivate var displayLabel: UILabel!
    fileprivate var bottomLayer: CAShapeLayer!
    fileprivate var lineLayer: CAShapeLayer!
    fileprivate var bottomMaskLayer: CAShapeLayer!
    fileprivate var displayTimer: Timer!
    @IBAction func bottomButtonIsTouched(_ sender: UIButton) {
        var displayText = "IA by Comparison; IA by Prediction; IA by Stratification"
        if sender.tag == 101 {
            displayText = "Help You Care; Help You Understand; Help You Act"
        }else if sender.tag == 102 {
            displayText = "Play; Score; Discover"
        }
        
        // init
        let lineWidth = 6 * fontFactor
        if displayLabel == nil {
            // border
            bottomLayer = CAShapeLayer()
            bottomLayer.strokeColor = UIColorFromHex(0x7ED321).cgColor
            bottomLayer.fillColor = UIColor.clear.cgColor
            bottomLayer.lineWidth = lineWidth
            bottomDetailView.layer.addSublayer(bottomLayer)
            
            lineLayer = CAShapeLayer()
            lineLayer.strokeColor = UIColor.black.cgColor
            lineLayer.fillColor = UIColor.clear.cgColor
            lineLayer.lineWidth = 2 * fontFactor
            bottomDetailView.layer.addSublayer(lineLayer)
            
            // label
            displayLabel = UILabel()
            displayLabel.textAlignment = .center
            displayLabel.numberOfLines = 0
            bottomDetailView.addSubview(displayLabel)
            
            // mask
            bottomMaskLayer = CAShapeLayer()
            bottomDetailView.layer.mask = bottomMaskLayer
        }
        
        // frames
        let bottomH = bottomDetailView.bounds.height
        let arrowH = bottomH * 0.18
        let labelH = bottomH - arrowH - lineWidth
        let attributedString = NSAttributedString(string: displayText, attributes: [.font: UIFont.systemFont(ofSize: 12 * fontFactor, weight: .medium)])
        let gap = 12 * fontFactor
        let minWidth = attributedString.boundingRect(with: CGSize(width: bottomDetailView.bounds.width * 0.8, height: labelH), options: .usesLineFragmentOrigin, context: nil).width + 2 * gap

        let topPoint = CGPoint(x: sender.frame.midX + getOffsetXOfButton(sender), y: 0)
        let bottomX = min(max(lineWidth, topPoint.x - minWidth * 0.5),bottomDetailView.bounds.width - minWidth - lineWidth)
        let bottomFrame = CGRect(x: bottomX, y: arrowH, width: minWidth, height: labelH)
        displayLabel.frame = bottomFrame.insetBy(dx: gap, dy: lineWidth)
        
        // border
        let radius = 4 * fontFactor
        let path = UIBezierPath()
        path.move(to: topPoint)
        path.addLine(to: CGPoint(x: topPoint.x - arrowH * 0.5, y: arrowH))
        path.addLine(to: CGPoint(x: bottomX + radius, y: arrowH))
        path.addArc(withCenter: CGPoint(x: bottomX + radius, y: arrowH + radius), radius: radius, startAngle: -CGFloatPi * 0.5, endAngle: -CGFloatPi, clockwise: false)
        path.addLine(to: CGPoint(x: bottomX, y: bottomFrame.maxY - radius))
        path.addArc(withCenter: CGPoint(x: bottomX + radius, y: bottomFrame.maxY - radius), radius: radius, startAngle: CGFloatPi, endAngle: CGFloatPi * 0.5, clockwise: false)
        path.addLine(to: CGPoint(x: bottomFrame.maxX - radius, y: bottomFrame.maxY))
        path.addArc(withCenter: CGPoint(x: bottomFrame.maxX - radius, y: bottomFrame.maxY - radius), radius: radius, startAngle: CGFloatPi * 0.5, endAngle: 0, clockwise: false)
        path.addLine(to: CGPoint(x: bottomFrame.maxX, y: bottomFrame.minY + radius))
        path.addArc(withCenter: CGPoint(x: bottomFrame.maxX - radius, y: arrowH + radius), radius: radius, startAngle: 0, endAngle: -CGFloatPi * 0.5, clockwise: false)
        path.addLine(to: CGPoint(x: topPoint.x + arrowH * 0.5, y: arrowH))
        path.close()
        
        bottomMaskLayer.path = path.cgPath
        bottomLayer.path = path.cgPath
        lineLayer.path = path.cgPath
        
        // setup
        displayLabel.attributedText = attributedString
        bottomDetailView.isHidden = false
        
        // timer
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
        
        var times = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            if times == 5 {
                self.timer.invalidate()
                self.timer = nil
                self.bottomDetailView.isHidden = true
            }
            times += 1
        })
    }
    
    fileprivate func getOffsetXOfButton(_ button: UIButton) -> CGFloat {
        if button.tag == 100 {
            return -button.frame.width * 0.07
        }else if button.tag == 101 {
            return 0
        }else {
            return button.frame.width * 0.07
        }
    }
    
    @IBAction func goToNext() {
        if launched {
            loadingRiskClasses()
        }else{
            // go to splash page
            userDefaults.set(true, forKey: "launched")
            userDefaults.synchronize()
            
            let splash = SplashScreenViewController()
            splash.presenetedFromVC = self
            present(splash, animated: true, completion: nil)
        }
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
    // MARK: ---------- move on
    fileprivate func loadingRiskClasses() {
        // data loading
        if !collection.groupLoaded {
            // change UI
            setUIState(true)
            sNextButton.isHidden = true
            
            // load risk class
            if let riskCategoryKey = ApplicationDataCenter.sharedCenter.riskCategoryKey {
                applicationClassAccess = ApplicationClassAccess(callback: self)
             
                applicationClassAccess.getMetricGroupsByKey(riskCategoryKey)
                createProcessBar()
            }else {
                print("error!! risk category key is nil")
            }
        } else {
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
                
                setUIState(true)
                sNextButton.isHidden = true
                
                if downloading == nil {
                    createProcessBar()
                }
                
                break
            }
        }
        
        if typeCursor == allRiskTypes.count {
            // all loaded
            endProcessAndPush()
        }
    }
    
    fileprivate func createProcessBar() {
        if downloading != nil {
            downloading.startProcess()
        }else {
            let barFrame = CGRect(x: -10, y: height - 15 * standHP, width: width + 20, height: 15 * standHP)
            downloading = DownloadingBarProcess.createWithFrame(barFrame, onView: view, withThumb: false, slow: true)
        }
    }
    
    fileprivate func checkRiskTypes() {
        if !collection.riskTypeLoadedFromNet {
            // change UI
            setUIState(true)
            sNextButton.isHidden = true
            // get data
            if applicationClassAccess == nil {
                applicationClassAccess = ApplicationClassAccess(callback: self)
            }
            
            if let riskTypeKey = ApplicationDataCenter.sharedCenter.riskTypeKey {
                applicationClassAccess.getRiskTypesByKey(riskTypeKey)
                if downloading == nil {
                    createProcessBar()
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
            downloading.processIsFinished()
            DispatchQueue.main.asyncAfter(deadline: .now() + downloading.endTimeInterval, execute: {
                self.downloading.endProcess()
                self.downloading = nil
                self.sNextButton.isHidden = false
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
            removeProcessAndDisplay()
            
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
            self.removeProcessAndDisplay()
        }else {
            collection.getApplicationFromLocal()
            
            // no record or ask for reload
            let alert = UIAlertController(title: "NET ERROR", message: "You can check your net state and Reload or use record", preferredStyle: .alert)
            let action = UIAlertAction(title: "Reload", style: .default, handler: { (action) in
                // try to reload data
                self.applicationAccess.getOneByKey(key: AnnieLyticxSlowAgingByDesign)
                self.processBar.startProcess()
            })
            alert.addAction(action)
            
            // has record, can use record
            if ApplicationDataCenter.sharedCenter.riskCategoryKey != nil {
                let useRecord = UIAlertAction(title: "Use Record", style: .default, handler: { (action) in
                    USERECORD = true
                    self.removeProcessAndDisplay()
                })
                
                alert.addAction(useRecord)
            }
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    // riskClasses
    func didFinishGetAttribute(_ obj: [AnyObject]) {
        if obj is [MetricGroupObjModel] && !collection.groupLoaded {
            riskClassGroup = obj as! [MetricGroupObjModel]
            metricGroupAccess = MetricGroupAccess(callback: self)
            
            if !riskClassGroup.isEmpty {
                // load metrics
                groupCursor = 0
                metricGroupAccess.getMetricsByKey(riskClassGroup[groupCursor].key)
            }
        }else if obj is [MetricObjModel] {
            // get metrics
            collection.updateRiskClasses(obj as! [MetricObjModel], withMetricGroup: riskClassGroup[groupCursor], fromNet: true)
            
            // get next risk category data
            groupCursor += 1
            if groupCursor < riskClassGroup.count {
                metricGroupAccess.getMetricsByKey(riskClassGroup[groupCursor].key)
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
        
        collection.updateRiskTypes([], fromNet: false)
        collection.getMetricGroupsFromLocal()
        collection.updateRiskClasses([], withMetricGroup: MetricGroupObjModel(), fromNet: false)
        collection.loadRisks([], riskTypeKey: "", fromNet: false)
        
        // TODO: --- with data
        if USERECORD {
            endProcessAndPush()
        }else {
            let errorAlert = UIAlertController(title: "Error!!!", message: "Net Error", preferredStyle: .alert)
            let reloadAction = UIAlertAction(title: "Reload", style: .cancel, handler: { (action) in
                self.loadingRiskClasses()
            })
            errorAlert.addAction(reloadAction)
        }
    }
    
    func failedAddDataByKey(_ error: String) {
        let errorAlert = UIAlertController(title: "Error!!!", message: "Net Error", preferredStyle: .alert)
        let reloadAction = UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
            
        })
        errorAlert.addAction(reloadAction)
    }
}
