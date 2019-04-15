//
//  LandingPageTireView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class LandingPageTireView: UIView {
    // properties for push
    weak var hostVC: ABookLandingPageViewController!
    // large title for hint
    var title: String! {
        didSet{
            if hostVC != nil && title != oldValue {
                hostVC.chosenTitle = title
            }
        }
    }
    // title of risk class, arcText
    fileprivate var riskClassTitle = "" {
        didSet{
            if hostVC != nil && riskClassTitle != oldValue {
                hostVC.detailTitle = riskClassTitle
            }
        }
    }
    
    // thire three risk classes
    fileprivate var tireThreeRiskClasses = [MetricObjModel]()
    func indexForRiskClass(_ riskClassKey: String?) -> Int? {
        if riskClassKey == nil {
            return nil
        }else {
            for (i, riskClass) in tireThreeRiskClasses.enumerated() {
                if riskClassKey! == riskClass.key {
                    return i
                }
            }
            
            return nil
        }
    }
    // MARK: --------------- creating -----------------
    fileprivate var offsetY: CGFloat = 0
    fileprivate var currentTireIndex: Int = -1 // 0 for tireOne
    class func createWithFrame(_ frame: CGRect, offsetY: CGFloat) -> LandingPageTireView {
        let landing = LandingPageTireView(frame: frame)
        landing.offsetY = offsetY
        landing.reloadViews()
        
        return landing
    }
    
    fileprivate var viewCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    fileprivate var plateLength: CGFloat {
        return min(bounds.height, bounds.width)
    }
    
    // information of sizes
    fileprivate var tireOneRadius: CGFloat {
        return 0.12 * plateLength
    }
    fileprivate var tireTwoRadius: CGFloat {
        return 0.26 * plateLength
    }
    fileprivate var tireThreeRadius: CGFloat {
        return 346 / 375 * 0.5 * plateLength
    }
    
    // colors
    fileprivate let maskBGColor = UIColor.black.withAlphaComponent(0.4)
    fileprivate let colors = [UIColorFromRGB(0, green: 219, blue: 247), UIColorFromRGB(0, green: 200, blue: 83), UIColorFromRGB(249, green: 163, blue: 7), UIColorFromRGB(219, green: 61, blue: 65)] // blue, green, orange, red
    fileprivate func reloadViews() {
        // prepare, remove all
        for view in subviews {
            view.removeFromSuperview()
        }
        layer.sublayers = nil
        gestureRecognizers?.removeAll()
        
        // setup
        backgroundColor = UIColor.clear
        let landingModel = LandingModel()
        landingModel.reloadLandingData()
        
        // sub
        addTireThree(landingModel.tireThree)
        addTireTwo(landingModel.tireTwo)
        addTireOne(landingModel.tireOne)
    }

    // each part
    // tire three, pie view
    fileprivate let tireThreePlate = PieView()
    // mask
    fileprivate let tireThreeMaskView = UIView()
    fileprivate func addTireThree(_ tireThree: [(MetricGroupObjModel, [MetricObjModel])]) {
        let innerRadius = 305 * tireThreeRadius / 346
        
        // set up
        tireThreeRiskClasses.removeAll()
        var groups = [(title: String?, number: Int, color: UIColor)]()
        for (i, (group, metrics)) in tireThree.enumerated() {
            // blue, green, orange, red
            groups.append((group.name, metrics.count, group.color ?? colors[i % 4]))
            tireThreeRiskClasses.append(contentsOf: metrics)
        }
        
        tireThreePlate.layer.addBlackShadow(2)
        tireThreePlate.layer.shadowOffset = CGSize(width: 0, height: 2)
        tireThreePlate.setupWithFrame(CGRect(center: viewCenter, length: plateLength), outerRadius: tireThreeRadius, innerRadius: innerRadius, numberOfSlices: tireThreeRiskClasses.count, enlargeAngle: CGFloat(-Double.pi / 2))
        tireThreePlate.hostLandingPage = self
        addSubview(tireThreePlate)
        
        for (index, riskClass) in tireThreeRiskClasses.enumerated() {
            let button = tireThreePlate.buttonsOnView[index]
            button.key = riskClass.key
            button.verticalWithImage(riskClass.imageUrl, title: riskClass.name, heightRatio: 1)
            button.addTarget(self, action: #selector(tireClicked(_:)), for: .touchUpInside)
        }
        
        // colorful border
        tireThreePlate.setupWithGroups(groups)
        
        // green plate, on view, not tire three
        let plate = UIImageView(image: UIImage(named: "plate"))
        plate.frame = CGRect(center: viewCenter, length: tireTwoRadius * 1.5)
        plate.layer.addBlackShadow(5)
        plate.layer.shadowOffset = CGSize.zero
        addSubview(plate)
        
        // gray mask on it
        let tireThreeCenter = CGPoint(x: plateLength * 0.5, y: plateLength * 0.5)
        tireThreeMaskView.backgroundColor = maskBGColor
        tireThreeMaskView.frame = CGRect(center: tireThreeCenter, length: tireThreeRadius * 2)
        tireThreeMaskView.layer.cornerRadius = tireThreeRadius
        
        tireThreePlate.addSubview(tireThreeMaskView)
        tireThreeMaskView.isHidden = true
    }
    
    // plate and two
    fileprivate let tireTwoPlate = UIView()
    fileprivate let tireTwoMask = UIView()
    fileprivate func addTireTwo(_ tireTwo:[(imageName: String, metricKey: String)]) {
        // ------------ full -----------
        tireTwoPlate.frame = CGRect(center: viewCenter, length: 2 * tireTwoRadius)
        addSubview(tireTwoPlate)
        
        // the shadow of tireTwo's buttons
        let shadowLayer = CAShapeLayer()
        let shadowPath = UIBezierPath()
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.addBlackShadow(8)
        tireTwoPlate.layer.addSublayer(shadowLayer)
        
        // TODO: ------- for better visual now, should modify for dynamic choices -----------------
        let length = 2 *  tireTwoRadius / (1 + sqrt(2))
        let tireTwoCenter = CGPoint(x: tireTwoRadius, y: tireTwoRadius)
        for (i, info) in tireTwo.enumerated() {
            let button = CustomButton(type: .custom)
            button.tag = 200 + i
            
            // set up frame
            let angle = Calculation().getAngle(i, totalNumber: tireTwo.count, startAngle: CGFloat(Double.pi) / 4, endAngle: 9 * CGFloat(Double.pi) / 4)
            let position = Calculation().getPositionByAngle(angle, radius: sqrt(2) / 2 * length, origin: tireTwoCenter)
            button.frame = CGRect(center: position, length: length)
            shadowPath.append(UIBezierPath(ovalIn: button.frame.insetBy(dx: 1, dy: 1)))
            
            button.key = info.metricKey
            button.backImage = UIImage(named: info.imageName)
            if let metric = AIDMetricCardsCollection.standardCollection.getMetric(info.metricKey) {
                button.itemTitle = metric.name
            }else {
                button.itemTitle = info.imageName
            }

            button.addTarget(self, action: #selector(tireClicked(_:)), for: .touchUpInside)
            tireTwoPlate.addSubview(button)
        }
        
        // shdow of buttons
        shadowLayer.path = shadowPath.cgPath
        
        // tire two mask
        tireTwoMask.backgroundColor = maskBGColor
        tireTwoMask.isHidden = true
        tireTwoMask.layer.cornerRadius = tireTwoRadius
        
        // not transform with tire two
        tireTwoMask.frame = tireTwoPlate.bounds
        tireTwoPlate.addSubview(tireTwoMask)
    }

    // -------------- one ---------------
    fileprivate let tireOneBackView = UIView()
    fileprivate let tireOneMask = UIView()
    fileprivate let tireOneCenter = CustomButton(type: .custom)
    fileprivate func addTireOne(_ tireOne: [MetricObjModel]) {
        // back and hex buttons
        tireOneBackView.backgroundColor = UIColor.clear
        tireOneBackView.frame = CGRect(center: viewCenter, length: tireThreeRadius * 2)
        addSubview(tireOneBackView)
        
        // three parts
        let radius = tireThreeRadius * 0.6
        let blueZones = addTireOneButton(UIImage(named: "tireOne_1"), angle: -Double.pi / 2, radius: radius)
        let prevention = addTireOneButton(UIImage(named: "tireOne_2"), angle: 5 * Double.pi / 6, radius: radius)
        let nineGame = addTireOneButton(UIImage(named: "tireOne_3"), angle: Double.pi / 6, radius: radius)
        
        // actions
        blueZones.tag = 101
        prevention.tag = 102
        blueZones.addTarget(self, action: #selector(tireClicked(_:)), for: .touchUpInside)
        prevention.addTarget(self, action: #selector(tireClicked(_:)), for: .touchUpInside)
        nineGame.addTarget(self, action: #selector(tireOneClicked), for: .touchUpInside)
        
        for metric in tireOne {
            if metric.name.localizedCaseInsensitiveContains("blue") {
                blueZones.key = metric.key
                blueZones.itemTitle = metric.name
            }else if metric.name.localizedCaseInsensitiveContains("prevention") {
                prevention.key = metric.key
                prevention.itemTitle = metric.name
            }
        }
        
        // center
        tireOneCenter.setBackgroundImage(UIImage(named: "tireOne"), for: .normal)
        tireOneCenter.frame = CGRect(center: viewCenter, length: tireOneRadius * 2)
        tireOneCenter.layer.addBlackShadow(3)
        addSubview(tireOneCenter)
        
        let maskForAction = UIView(frame: tireOneCenter.frame)
        maskForAction.backgroundColor = UIColor.clear
        addSubview(maskForAction)
        
        // tire one mask
        tireOneMask.backgroundColor = maskBGColor
        tireOneMask.isHidden = true
        tireOneMask.frame = tireOneCenter.bounds
        tireOneMask.layer.cornerRadius = tireOneRadius
        tireOneCenter.addSubview(tireOneMask)
    }
    
    fileprivate func addTireOneButton(_ image: UIImage?, angle: Double, radius: CGFloat) -> CustomButton {
        let button = CustomButton(type: .custom)
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        let center = Calculation().getPositionByAngle(CGFloat(angle), radius: radius, origin: CGPoint(x: tireThreeRadius, y: tireThreeRadius))
        button.frame = CGRect(center: center, length: 2 * (tireThreeRadius - radius))
        tireOneBackView.addSubview(button)
        button.layer.addBlackShadow(3)
        
        return button
    }
    
    // MARK: ------------ actions ------------------------
    func riskClassIsOnShow(_ index: Int) {
        let current = tireThreeRiskClasses[index]
        riskClassTitle = current.name
        RiskMetricCardsCursor.sharedCursor.selectedRiskClassKey = current.key
    }
    
    // click
    // the center
    func tireOneClicked(_ button: CustomButton) {
        title = "9 Behavioral (Modifiable) Risk Factors Surveillance Card Game"
        hostVC.navigationController?.pushViewController(DoEasyViewController(), animated: true)
    }

    func tireClicked(_ button: CustomButton) {
        let hostNavigationDelegate = hostVC.navigationController
        if  hostNavigationDelegate == nil || button.key == "" {
            print("not added or no risk class")
            return
        }
        
        // set riskClass key
        RiskMetricCardsCursor.sharedCursor.selectedRiskClassKey = button.key!
        
        if button.tag >= 300 {
            tireThreePlate.scrollToAngle(button.tag - 300, clockwise: nil)
        }else {
            
            title = button.itemTitle
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                RiskMetricCardsCursor.sharedCursor.riskTypeKey = nil
                let introPageVC = IntroPageViewController()
                introPageVC.tire = button.tag / 100
                if button.tag == 101 {
                    GameTintApplication.sharedTint.gameTopic = .blueZone
                }else {
                    GameTintApplication.sharedTint.gameTopic = .normal
                }
            
                self.hostVC.navigationController?.pushViewController(introPageVC, animated: true)
            })
        }
    }
    
    // MARK: --------------------- animation ------------------------
    fileprivate func originalState() {
        // hide all masks
        tireThreeMaskView.isHidden = true
        tireTwoMask.isHidden = true
        tireOneMask.isHidden = true
        self.hostVC.arcButtons.setDisplayState(true)
        
        // orginal sizes
        UIView.animate(withDuration: 0.4) {
            self.tireOneCenter.transform = CGAffineTransform.identity
            self.tireTwoPlate.transform = CGAffineTransform.identity
            self.transform = CGAffineTransform.identity
            self.tireOneBackView.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }
        
        // all disabled
        tireThreePlate.isUserInteractionEnabled = false
        tireOneBackView.isUserInteractionEnabled = false
        tireTwoPlate.isUserInteractionEnabled = false
    }
    
    
    //  focus on different tires
    var duringAnimation = false
    func focusOnTire(_ tireIndex: Int, selectionIndex: Int?) {
        originalState()
        duringAnimation = true
        
        let duration: TimeInterval = 0.7
        currentTireIndex = tireIndex
        
        let tab = hostVC.tabBarController as! ABookTabBarController
        tab.tireIndex = currentTireIndex
    
        // animation
        switch tireIndex {
        case 0:             // tire one
            riskClassTitle = ""
            title = "Help You Understand"
            UIView.animate(withDuration: duration, animations: {
                // animation
                self.tireOneCenter.transform = CGAffineTransform(scaleX: 1.45, y: 1.45)
                self.tireTwoPlate.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
                self.hostVC.arcButtons.setDisplayState(true)
                self.tireOneBackView.transform = CGAffineTransform.identity
            }, completion: { (true) in
                self.title = "You can\n select from the three"
                self.tireOneBackView.isUserInteractionEnabled = true
                
                // masks shows
                self.tireThreeMaskView.isHidden = false
                self.tireTwoMask.isHidden = false
                self.duringAnimation = false
            })

        case 1:             // tire two
            riskClassTitle = ""
            title = "Help You Care"
            tireTwoMask.isHidden = true
            
            UIView.animate(withDuration: duration, animations: {
                // animation
                self.tireTwoPlate.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                self.tireOneCenter.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.hostVC.arcButtons.setDisplayState(true)
            }, completion: { (true) in
                self.title = "You can choose\n from the four \"Age\"s"
                self.tireTwoPlate.isUserInteractionEnabled = true
    
                // masks shows
                self.tireThreeMaskView.isHidden = false
                self.tireOneMask.isHidden = false
                self.duringAnimation = false
            })
            
        case 2:            // tire three and ->
            title = "Help You Act"
            riskClassTitle = "Spin the wheel or choose from icons"
            tireThreeMaskView.isHidden = true
            
            // animation
            var times: Int = 0 // repeated times
            var gap = self.tireThreePlate.angleGap * 0.1
            Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true, block: { (timer) in
                times += 1
                
                // ease
                if times > 15 && times < 45 {
                    gap = self.tireThreePlate.angleGap * 0.4
                }else {
                    gap = self.tireThreePlate.angleGap * 0.1
                }
                
                self.tireThreePlate.tuneWithAngle(gap)
                
                // stop, total: 0.02 * (times - 1)
                if times == Int(2.4 * CGFloat(Double.pi) / gap) || (selectionIndex != nil && self.tireThreePlate.selectedIndex == selectionIndex) {
                    self.title = ""
                    timer.invalidate()
                    self.tireThreePlate.adjustAngle()
                    self.tireThreePlate.setArcButtonTitle()
   
                    // masks shows
                    self.tireTwoMask.isHidden = false
                    self.tireOneMask.isHidden = false

                    // show buttons
                    UIView.animate(withDuration: 0.3, animations: {
                        self.transform = CGAffineTransform(translationX: 0, y: self.offsetY)
                        self.tireOneCenter.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                        self.tireTwoPlate.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                        self.hostVC.arcButtons.setDisplayState(false)
                    }, completion: { (true) in
                        self.tireThreePlate.isUserInteractionEnabled = true
                        self.shakeToRemind()
                        self.duringAnimation = false
                    })
                }
            })
            
        default:        // orginal, no choice
            title = "Touch One Tire To Select"
            riskClassTitle = ""
            
            UIView.animate(withDuration: 0.5, animations: {
                self.hostVC.arcButtons.setDisplayState(true)
            }, completion: { (true) in
                self.duringAnimation = false
            })
        }
    }
    
    // shake arcButtons
    func shakeToRemind() {
        let arcButtons = hostVC.arcButtons
        let shakeAngle = CGFloat(Double.pi) / 25
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn , animations: {
            arcButtons.transform = CGAffineTransform(rotationAngle: -shakeAngle * 0.5)
        }, completion: { (true) in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut ,animations: {
                arcButtons.transform = CGAffineTransform(rotationAngle: shakeAngle * 0.5)
            }, completion: { (true) in
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn ,animations: {
                    arcButtons.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        })
    }
    
    // hit button
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var hitView = super.hitTest(point, with: event)
        let mainRect = CGRect(center: viewCenter, length: tireThreeRadius * 2)
        if backgroundColor == UIColor.clear && !mainRect.contains(point) {
            hitView = nil
        }
        
        return hitView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if duringAnimation {
            return
        }
        
        let point = touches.first!.location(in: self)
        let touchedIndex = tireIndexForPoint(point)
        if touchedIndex != currentTireIndex {
            focusOnTire(touchedIndex, selectionIndex: nil)
        }
    }
    
    fileprivate func tireIndexForPoint(_ point: CGPoint) -> Int {
        let distenceToCenter = Calculation().distanceOfPointA(point, pointB: viewCenter)
        if  distenceToCenter <= tireOneCenter.frame.width * 0.5 {
            // tire one is touched
            return 0
        }else if distenceToCenter <= tireTwoPlate.frame.width * 0.48 {
            return 1
        }else if distenceToCenter <= tireThreeRadius {
            return 2
        }

        // out side
        return -1
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if hostVC.arcButtons.transform == CGAffineTransform.identity {
            shakeToRemind()
        }
    }
}

