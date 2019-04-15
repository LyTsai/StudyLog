//
//  LandingMainView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/3.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

@objc protocol LandingProtocol {
    @objc optional func landingView(_ view: LandingMainView, tierIsChosen tierIndex: Int)
    @objc optional func landingView(_ view: LandingMainView, chosen button: CustomButton)
    @objc optional func touchCenterOflandingView(_ view: LandingMainView)
    @objc optional func sliceIsChosen()
}

class LandingMainView: UIView {
    // open
    var delegate: LandingProtocol!
    
    var showAll = true // for landing: true 
    var displayedTireIndex = 0 // temp use
    
    // stored
    var tierIndex: Int {
        return GameTintApplication.sharedTint.focusingTierIndex
    }
    
    // subviews
    let titleLabel = UILabel()
    let arcButtons = ArcButtonsView()
    fileprivate let detailDraw = ArcTextDrawView()
    
    // init
    class func createWithFrame(_ frame: CGRect, plateLength: CGFloat) -> LandingMainView {
        let landing = LandingMainView(frame: frame)
        landing.addWithPlateLength(plateLength)
        return landing
    }
    
    var plateLength: CGFloat {
        return _plateLength
    }
    fileprivate var _plateLength: CGFloat = 0
    var buttonsOn = [CustomButton]()
    func addWithPlateLength(_ plateLength: CGFloat) {
        backgroundColor = UIColor.clear
        _plateLength = plateLength
        
        // data
        let landingModel = LandingModel()
        landingModel.reloadLandingData()
        
        // frames
        let gap = (frame.height - plateLength) * 0.5
        let buttonSpace = gap * 0.78
        
        // titleLabel
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: frame.width * 0.03, y: 0, width: frame.width * 0.94, height: gap)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: UIFontWeightSemibold)
        titleLabel.shadowOffset = CGSize(width: 0, height: fontFactor)
        addSubview(titleLabel)
        
        if showAll {
            // buttons
            createArcButtons(buttonSpace)
            
            // draw text
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: (gap - buttonSpace) * 0.8, weight: UIFontWeightBold), NSForegroundColorAttributeName: UIColor.white, NSStrokeColorAttributeName: UIColor.black, NSStrokeWidthAttributeName: NSNumber(value: -3), NSKernAttributeName: NSNumber(value: -2)]
            detailDraw.setTopArcWithFrame(CGRect(x: 0, y: 0 + buttonSpace, width: frame.width, height: frame.height - buttonSpace * 2), angle: CGFloat(Double.pi), minRadius: plateLength * 0.5 * 365 / 375, attributes: attributes)
            detailDraw.isUserInteractionEnabled = false
            
            addSubview(arcButtons)
            addSubview(detailDraw)
       
            // sub
            addTierThree(landingModel.tierThree)
            addTierTwo(landingModel.tierTwo)
            addTierOne(landingModel.tierOne)
            
            // state
            focusOnCurrentData()
        }else {
            // only show one tier
            switch displayedTireIndex {
            case 0: addTierOne(landingModel.tierOne)
            case 1: addTierTwo(landingModel.tierTwo)
                tierTwoPlate.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
            case 2: addTierThree(landingModel.tierThree)
            default: break
            }
            
            // center image
            let centerImage = UIImageView(image: UIImage(named: "tierOne"))
            centerImage.frame = CGRect(center: viewCenter, length: tierOneRadius * 2)
            centerImage.layer.addBlackShadow(4 * fontFactor)
            addSubview(centerImage)
            centerImage.isUserInteractionEnabled = true
            
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(touchCenter))
            centerImage.addGestureRecognizer(tapGR)
            
            setupAtrributedTitleOfTier(displayedTireIndex)
        }
    }
    
    func focusOnCurrentData() {
        // selected index
        // animation
        let selectedIndex = indexForRiskClass(cardsCursor.selectedRiskClassKey)
        focusOnTier(tierIndex, selectionIndex: selectedIndex)
    }
    
    func createArcButtons(_ buttonSpace: CGFloat)  {
        var buttons = [CustomButton]()
        for riskType in collection.getAllRiskTypes() {
            if riskType.key == iCaKey || riskType.key == iPaKey {
                continue
            }
            
            let button = CustomButton(type: .custom)
            button.key = riskType.key
            
            // break string
            let name = riskType.name ?? "iRa Risk"
            let index = name.index(name.startIndex, offsetBy: 3)
            let typeName = name.substring(to: index)
            let leftIndex = name.index(name.startIndex, offsetBy: 4)
            let leftString = name.substring(from: leftIndex)
            
            button.usedForRiskTypeButton(riskType.realColor, title: leftString, prompt: typeName)

            button.addTarget(self, action: #selector(goToGames), for: .touchUpInside)
            buttons.append(button)
        }
        
        arcButtons.setRectBackWithFrame(bounds, buttons: buttons, minRadius: frame.height * 0.5 - buttonSpace, buttonGap: 0.03, buttonScale: 0.9)
    }

    // thire three risk classes
    fileprivate var tierThreeRiskClasses = [MetricObjModel]()
    func indexForRiskClass(_ riskClassKey: String?) -> Int? {
        if riskClassKey == nil {
            return nil
        }else {
            for (i, riskClass) in tierThreeRiskClasses.enumerated() {
                if riskClassKey! == riskClass.key {
                    return i
                }
            }
            
            return nil
        }
    }
    
    // MARK: --------------- creating -----------------
    fileprivate var viewCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // information of sizes
    fileprivate var tierOneRadius: CGFloat {
        return 0.1 * plateLength
    }
    fileprivate var tierTwoRadius: CGFloat {
        return 0.26 * plateLength
    }
    fileprivate var tierThreeRadius: CGFloat {
        return 346 / 375 * 0.5 * plateLength
    }
    
    // colors
    fileprivate let maskBGColor = UIColor.black.withAlphaComponent(0.4)
    fileprivate let outerColors = [UIColorFromRGB(0, green: 229, blue: 255), UIColorFromRGB(0, green: 200, blue: 83), UIColorFromRGB(255, green: 196, blue: 0), UIColorFromRGB(238, green: 109, blue: 107)] // blue, green, orange, red
    fileprivate let innerColors = [UIColorFromRGB(2, green: 136, blue: 209), UIColorFromRGB(0, green: 146, blue: 60), UIColorFromRGB(230, green: 74, blue: 25), UIColorFromRGB(208, green: 2, blue: 27)]
   
    // each part
    // tier three, pie view
    let tierThreePlate = PieView()
    // mask
    fileprivate let tierThreeMaskView = UIView()
    fileprivate func addTierThree(_ tierThree: [(MetricGroupObjModel, [MetricObjModel])]) {
        let innerRadius = 305 * tierThreeRadius / 346
        
        // set up
        tierThreeRiskClasses.removeAll()
        var groups = [(title: String?, number: Int, outerColor: UIColor, innerColor: UIColor)]()
        for (group, metrics) in tierThree {
            // blue, green, orange, red
            var i = 2
            if group.name.localizedCaseInsensitiveContains("cancer") {
                i = 3
            }else if group.name.localizedCaseInsensitiveContains("diabetes") {
                i = 0
            }else if group.name.localizedCaseInsensitiveContains("heart") {
                i = 1
            }
            
            groups.append((group.name, metrics.count, outerColors[i], innerColors[i]))
            tierThreeRiskClasses.append(contentsOf: metrics)
        }
        
        tierThreePlate.layer.addBlackShadow(5 * fontFactor)
        tierThreePlate.layer.shadowOffset = CGSize.zero
        tierThreePlate.setupWithFrame(CGRect(center: viewCenter, length: plateLength), outerRadius: tierThreeRadius, innerRadius: innerRadius, numberOfSlices: tierThreeRiskClasses.count, enlargeAngle: CGFloat(-Double.pi / 2))
        tierThreePlate.hostLandingPage = self
        addSubview(tierThreePlate)
            
        for (index, riskClass) in tierThreeRiskClasses.enumerated() {
            let button = tierThreePlate.buttonsOnView[index]
            button.key = riskClass.key
            button.verticalWithImage(riskClass.imageUrl, title: "\(riskClass.name ?? "") Prevention", heightRatio: 0.5)
            button.addTarget(self, action: #selector(tierClicked(_:)), for: .touchUpInside)
            
            buttonsOn.append(button)
        }
        
        // colorful border
        tierThreePlate.setupWithGroups(groups)
        
        if showAll {
            // green plate, on view, not tier three
            let plate = UIImageView(image: UIImage(named: "plate"))
            plate.frame = CGRect(center: viewCenter, length: tierTwoRadius * 1.5)
            plate.layer.addBlackShadow(5 * fontFactor)
            plate.layer.shadowOffset = CGSize.zero
            addSubview(plate)
            
            // gray mask on it
            let tierThreeCenter = CGPoint(x: plateLength * 0.5, y: plateLength * 0.5)
            tierThreeMaskView.backgroundColor = maskBGColor
            tierThreeMaskView.frame = CGRect(center: tierThreeCenter, length: tierThreeRadius * 2)
            tierThreeMaskView.layer.cornerRadius = tierThreeRadius
            
            tierThreePlate.addSubview(tierThreeMaskView)
            tierThreeMaskView.isHidden = true
        }
    }
    
    // plate and two
    fileprivate let tierTwoPlate = FlowerView()
    fileprivate let tierTwoMask = UIView()
    fileprivate func addTierTwo(_ tierTwo:[MetricObjModel]) {
        // ------------ full -----------
        addSubview(tierTwoPlate)
        
        tierTwoPlate.layer.addBlackShadow(8 * fontFactor)
        
        var customButtons = [CustomButton]()
        for (i, metric) in tierTwo.enumerated() {
            let button = CustomButton(type: .custom)
            button.tag = 200 + i
            button.key = metric.key
            button.createWithImage(metric.imageUrl, text: metric.name)
           
            button.addTarget(self, action: #selector(tierClicked(_:)), for: .touchUpInside)
            tierTwoPlate.addSubview(button)
            customButtons.append(button)
            buttonsOn.append(button)
        }
        tierTwoPlate.loadWithFrame(CGRect(center: viewCenter, length: 2 * tierTwoRadius), customButtons: customButtons, lineColor: UIColor.purple, lineWidth: 3 * fontFactor)
    
        if showAll {
            // tier two mask
            tierTwoMask.backgroundColor = maskBGColor
            tierTwoMask.isHidden = true
            tierTwoMask.layer.cornerRadius = tierTwoRadius
        
            // not transform with tier two
            tierTwoMask.frame = tierTwoPlate.bounds
            tierTwoPlate.addSubview(tierTwoMask)
        }
    }
    
    // -------------- one ---------------
    fileprivate let tierOneBackView = UIView()
    fileprivate let tierOneMask = UIView()
    fileprivate let tierOneButton = CustomButton(type: .custom)
    fileprivate func addTierOne(_ tierOne: [MetricObjModel]) {
        // back and hex buttons
        tierOneBackView.backgroundColor = UIColor.clear
        tierOneBackView.frame = CGRect(center: viewCenter, length: tierThreeRadius * 2)
        addSubview(tierOneBackView)
        
        // three parts
        let radius = tierThreeRadius * 0.54
        let blueZones = addTierOneButton(UIImage(named: "tierOne_1"), angle: -Double.pi / 2, radius: radius)
        let prevention = addTierOneButton(UIImage(named: "tierOne_2"), angle: 5 * Double.pi / 6, radius: radius)
        let nineGame = addTierOneButton(UIImage(named: "tierOne_3"), angle: Double.pi / 6, radius: radius)
        buttonsOn.append(contentsOf: [blueZones, prevention, nineGame])
        
        // actions
        blueZones.tag = 101
        prevention.tag = 102
        nineGame.tag = 103
        blueZones.addTarget(self, action: #selector(tierClicked(_:)), for: .touchUpInside)
        prevention.addTarget(self, action: #selector(tierClicked(_:)), for: .touchUpInside)
        nineGame.addTarget(self, action: #selector(tierClicked(_:)), for: .touchUpInside)
        
        for metric in tierOne {
            if metric.name.localizedCaseInsensitiveContains("blue") {
                blueZones.key = metric.key
                blueZones.itemTitle = metric.name
            }else if metric.name.localizedCaseInsensitiveContains("cancer") {
                prevention.key = metric.key
                prevention.itemTitle = metric.name
            }else {
                // butterfly
                nineGame.key = metric.key
                nineGame.itemTitle = metric.name
            }
        }
        
        // center
        if showAll {
            tierOneButton.setBackgroundImage(UIImage(named: "tierOne"), for: .normal)
            tierOneButton.setBackgroundImage(UIImage(named: "tierOne_on"), for: .selected)
            tierOneButton.setBackgroundImage(UIImage(named: "tierOne_on"), for: [.highlighted ,.selected])
            
            tierOneButton.frame = CGRect(center: viewCenter, length: tierOneRadius * 2)
            tierOneButton.addTarget(self, action: #selector(remindOfTierOne), for: .touchUpInside)
            tierOneButton.layer.addBlackShadow(5 * fontFactor)
            addSubview(tierOneButton)
            
            let maskForAction = UIView(frame: tierOneButton.frame)
            maskForAction.backgroundColor = UIColor.clear
            addSubview(maskForAction)
            
            // tier one mask
            tierOneMask.backgroundColor = maskBGColor
            tierOneMask.isHidden = true
            tierOneMask.frame = tierOneButton.bounds
            tierOneMask.layer.cornerRadius = tierOneRadius
            tierOneButton.addSubview(tierOneMask)
        }
    }
    
    fileprivate func addTierOneButton(_ image: UIImage?, angle: Double, radius: CGFloat) -> CustomButton {
        let button = CustomButton(type: .custom)
        button.setBackgroundImage(image, for: .normal)
        let center = Calculation().getPositionByAngle(CGFloat(angle), radius: radius, origin: CGPoint(x: tierThreeRadius, y: tierThreeRadius))
        let length = 2 * (tierThreeRadius * 0.96 - radius)
        button.frame = CGRect(center: center, width: length, height: length * 2 / sqrt(3))
        tierOneBackView.addSubview(button)
        button.layer.addBlackShadow(3 * fontFactor)
     
        return button
    }
        
    // MARK: --------------------- animation ------------------------
    fileprivate func originalState() {
        // hide all masks
        tierThreeMaskView.isHidden = true
        tierTwoMask.isHidden = true
        tierOneMask.isHidden = true
        arcButtons.setDisplayState(true)
        
        // orginal sizes
        UIView.animate(withDuration: 0.4) {
            self.tierOneButton.isSelected = false
            self.tierOneButton.transform = CGAffineTransform.identity
            self.tierTwoPlate.transform = CGAffineTransform.identity
            self.transform = CGAffineTransform.identity
            self.tierOneBackView.transform = CGAffineTransform(scaleX: 0.22, y: 0.22)
            self.tierOneBackView.alpha = 0.6
        }
        
        // all disabled
        tierThreePlate.isUserInteractionEnabled = false
        tierOneBackView.isUserInteractionEnabled = false
        tierTwoPlate.isUserInteractionEnabled = false
        
        // timer
        if tierThreeTimer != nil {
            tierThreeTimer.invalidate()
            tierThreePlate.adjustAngle()
            tierThreeTimer = nil
        }
        tierThreePlate.selectedIndex = -1
    }
    
    var tierThreeTimer: Timer!
}

// MARK: ---------------- actions and touches ------------------------
extension LandingMainView {
    func setupAtrributedTitleOfTier(_ tierIndex: Int) {
        let topFont = UIFont.systemFont(ofSize: 15 * fontFactor, weight: UIFontWeightSemibold)
        switch tierIndex {
        case 0:             // tier one
            let topText = "Comparison with either a set of guidelines, checklist or a community"
            let topAttribute = [NSFontAttributeName: topFont, NSForegroundColorAttributeName: UIColor.white]
            let attributedTop = NSMutableAttributedString(string: topText, attributes: topAttribute)
            
            // letters
            let glyphAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18 * fontFactor, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColorFromRGB(178, green: 255, blue: 89)]
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(0, 1)) // R
            titleLabel.attributedText = attributedTop
        case 1:             // tier two
            let topText = "Individualized Prediction Assessment games based on predictive models formulated by scientific findings, studies and clinical trials"
            let topAttribute = [NSFontAttributeName: topFont, NSForegroundColorAttributeName: UIColor.white]
            let attributedTop = NSMutableAttributedString(string: topText, attributes: topAttribute)
           
            // letters
            let glyphAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18 * fontFactor, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColorFromRGB(178, green: 255, blue: 89)]
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(15, 1)) // R
            titleLabel.attributedText = attributedTop
            
        case 2:            // tier three and
            let topText = "Individualized Assessment:\n Risk, Symptoms, Knowledge, Impact, and Action"
            let topAttribute = [NSFontAttributeName: topFont, NSForegroundColorAttributeName: UIColor.white]
            let attributedTop = NSMutableAttributedString(string: topText, attributes: topAttribute)
            
            // letters
            let glyphAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18 * fontFactor, weight: UIFontWeightSemibold), NSForegroundColorAttributeName: UIColorFromRGB(178, green: 255, blue: 89)]
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(28, 1)) // R
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(34, 1)) // S
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(44, 1)) // K
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(55, 1)) // I
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(67, 1)) // A
            titleLabel.attributedText = attributedTop
          
        default:        // orginal, no choice
            titleLabel.text = "Touch One Tier To Start Choosing"
        }
    }
    
    func touchCenter() {
        if delegate != nil {
            delegate.touchCenterOflandingView?(self)
        }
    }
    
    func focusOnTier(_ tierIndex: Int, selectionIndex: Int?) {
        originalState()
   
        let duration: TimeInterval = 0.5
        GameTintApplication.sharedTint.focusingTierIndex = tierIndex
        
        // animation
        switch tierIndex {
        case 0:             // tier one
            detailDraw.text = ""
            self.tierOneBackView.alpha = 1
            UIView.animate(withDuration: duration, animations: {
                // animation
                self.tierOneButton.isSelected = true
                self.tierOneButton.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.tierTwoPlate.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                self.arcButtons.setDisplayState(true)
                self.tierOneBackView.transform = CGAffineTransform.identity
            }, completion: { (true) in
                self.tierOneBackView.isUserInteractionEnabled = true
                self.arcButtons.setDisplayState(true)
                // masks shows
                self.tierThreeMaskView.isHidden = false
                self.tierTwoMask.isHidden = false
//                self.duringAnimation = false
            })
            
        case 1:             // tier two
            detailDraw.text = ""
            tierTwoMask.isHidden = true
            
            UIView.animate(withDuration: duration, animations: {
                // animation
                self.tierTwoPlate.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
                self.tierOneButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.arcButtons.setDisplayState(true)
            }, completion: { (true) in
                self.tierTwoPlate.isUserInteractionEnabled = true
                
                // masks shows
                self.tierThreeMaskView.isHidden = false
                self.tierOneMask.isHidden = false
                self.arcButtons.setDisplayState(true)
            })
            
        case 2:            // tier three and ->
            tierThreeMaskView.isHidden = true
            // masks shows
            self.tierTwoMask.isHidden = false
            self.tierOneMask.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.tierOneButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                self.tierTwoPlate.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            }, completion: { (true) in
                self.tierThreePlate.isUserInteractionEnabled = true
            })
            
            // with target risk class
            if selectionIndex != nil {
                tierThreePlate.selectedIndex = selectionIndex!
                riskClassIsOnShow(selectionIndex!)
                tierThreePlate.scrollToAngle()
            }else {
                detailDraw.text = "Spin the game wheel or Tap on a subject to select"
        
                // animation
                let gap = self.tierThreePlate.angleGap * 0.025
                if tierThreeTimer == nil {
                    tierThreeTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (timer) in
                        self.tierThreePlate.tuneWithAngle(gap)
                    })
                }
             }
        default:        // orginal, no choice
            detailDraw.text = ""
            
            UIView.animate(withDuration: 0.3, animations: {
                self.arcButtons.setDisplayState(true)
            }, completion: { (true) in
            })
        }
        
        setupAtrributedTitleOfTier(tierIndex)
        
        // delegate
        if delegate != nil {
            delegate.landingView?(self, tierIsChosen: tierIndex)
            if selectionIndex != nil && tierIndex == 2 {
                delegate.sliceIsChosen?()
            }
        }
    }
    
  
    // shake arcButtons
    func shakeToRemind() {
        if delegate != nil {
            delegate.sliceIsChosen?()
        }
        
        let shakeAngle = CGFloat(Double.pi) / 25
        UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn , animations: {
            self.arcButtons.transform = CGAffineTransform(rotationAngle: -shakeAngle * 0.5)
        }, completion: { (true) in
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut ,animations: {
                self.arcButtons.transform = CGAffineTransform(rotationAngle: shakeAngle * 0.5)
            }, completion: { (true) in
                UIView.animate(withDuration: 0.15, delay: 0, options: .curveEaseIn ,animations: {
                    self.arcButtons.transform = CGAffineTransform.identity
                }, completion: nil)
            })
        })
    }
    
    func goToGames(_ button: CustomButton) {
        cardsCursor.riskTypeKey = button.key
        GameTintApplication.sharedTint.gameTopic = .normal // .blueZone
        CardViewImagesCenter.sharedCenter.setupImagesWithRiskType(button.key)
        
        let riskTypeKey = cardsCursor.riskTypeKey
        let keyString = "showedFor\(riskTypeKey)"
        
        // should show
        if !userDefaults.bool(forKey: keyString) {
            let riskTypeHint = RiskTypeHintViewController()
            riskTypeHint.landingView = self
            riskTypeHint.modalPresentationStyle = .overCurrentContext
            viewController.present(riskTypeHint, animated: true, completion: nil)
        }else {
            let introPageVC = IntroPageViewController()
            self.navigation.pushViewController(introPageVC, animated: true)
        }
    }
    
    // hit button
    func tierIndexForPoint(_ point: CGPoint) -> Int {
        let distenceToCenter = Calculation().distanceOfPointA(point, pointB: viewCenter)
        if  distenceToCenter <= tierOneButton.frame.width * 0.52 {
            // tier one is touched
            return 0
        }else if distenceToCenter <= tierTwoPlate.frame.width * 0.48 {
            return 1
        }else if distenceToCenter <= tierThreeRadius {
            return 2
        }
        
        // out side
        return -1
    }
    
    // MARK: ------------ actions ------------------------
    func riskClassIsOnShow(_ index: Int) {
        if index == -1 {
            return
        }

        let current = tierThreeRiskClasses[index]
        detailDraw.text = "\(current.name!) Prevention"
        cardsCursor.selectedRiskClassKey = current.key
    }
    
    // click
    // the center
    func remindOfTierOne() {
        UIView.animate(withDuration: 0.3, animations: {
            self.tierOneBackView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { (true) in
            UIView.animate(withDuration: 0.3, animations: {
                self.tierOneBackView.transform = CGAffineTransform.identity
            })
        })
    }

    
    func tierClicked(_ button: CustomButton) {
        if button.key == nil || button.key == ""{
            if self.delegate != nil {
                let alert = UIAlertController(title: "This game is for the future release only", message: nil, preferredStyle: .alert)
                let action = UIAlertAction(title: "Got It", style: .default, handler: nil)
                alert.addAction(action)
                viewController.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        if button.tag >= 300 {
            let selectedIndex = button.tag - 300
            tierThreePlate.selectedIndex = selectedIndex
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.tierThreePlate.scrollToAngle()
            })
        }
        
        if delegate != nil {
            delegate!.landingView?(self, chosen: button)
        }
    }

    
    // hitTest
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)
        
        // clear
        if Calculation().distanceOfPointA(point, pointB: viewCenter) > plateLength * 0.5 && !showAll {
            return nil
        }
        
        if tierIndex == 0 && Calculation().distanceOfPointA(point, pointB: tierOneButton.center) <= tierOneButton.frame.width * 0.5 {
            view = tierOneButton
        }else if arcButtons.transform == CGAffineTransform.identity && point.y < (bounds.height - plateLength) * 0.5 {
            for button in arcButtons.buttons {
                if button.frame.contains(point) {
                    view = button
                    break
                }
            }
        }

        return view
    }
}
