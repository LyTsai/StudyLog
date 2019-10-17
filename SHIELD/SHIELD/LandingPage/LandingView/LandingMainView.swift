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
    @objc optional func arcButtonIsChosen(_ button: CustomButton)
    @objc optional func touchCenterOfLandingView(_ view: LandingMainView)
    @objc optional func sliceIsChosen()
}

class LandingMainView: UIView, PieViewDelegate {
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
    fileprivate var centerImages = [UIImageView]()
    fileprivate let centerImage = UIImageView(image: UIImage(named: "tierOne"))
    class func createWithFrame(_ frame: CGRect, plateLength: CGFloat, plateCenter: CGPoint) -> LandingMainView {
        let landing = LandingMainView(frame: frame)
        landing.addWithPlateLength(plateLength, plateCenter: plateCenter)
        return landing
    }
    
    var plateLength: CGFloat {
        return _plateLength
    }
    fileprivate var _plateLength: CGFloat = 0
    var plateCenter: CGPoint {
        return _plateCenter
    }

    fileprivate var _plateCenter = CGPoint.zero
    var buttonsOn = [CustomButton]()
    func addWithPlateLength(_ plateLength: CGFloat, plateCenter: CGPoint) {
        backgroundColor = UIColor.clear
        _plateLength = plateLength
        _plateCenter = plateCenter
        
        // data
        let landingModel = LandingModel()
        landingModel.reloadLandingData()
        
        // frames
        let gap = plateCenter.y - plateLength * 0.5
        
        // titleLabel
        var titleH = gap
        if !showAll && displayedTireIndex == 2 {
            titleH *= 0.6
        }
        titleLabel.textColor = UIColor.white
        titleLabel.frame = CGRect(x: frame.width * 0.03, y: 0, width: frame.width * 0.94, height: titleH)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 18 * fontFactor, weight: .semibold)
        titleLabel.shadowOffset = CGSize(width: 0, height: fontFactor)
        addSubview(titleLabel)
        
        let buttonSpace = showAll ? gap * 0.78 : (gap - titleH)
        if showAll {
            // buttons
            createArcButtons(buttonSpace)
            
            // draw text
            let arcFrame = CGRect(x: 0, y: 0 + buttonSpace, width: frame.width, height: frame.height - buttonSpace * 2)
            let font = UIFont.systemFont(ofSize: (gap - buttonSpace) * 0.7, weight: .bold)
            detailDraw.setTopArcWithFrame(arcFrame, angle: CGFloat(Double.pi), minRadius: plateLength * 0.5 * 365 / 375, attributes: [.font: font, .foregroundColor: UIColor.white, .strokeColor: UIColor.black, .strokeWidth: NSNumber(value: -3), .kern: NSNumber(value: -2)])
            detailDraw.isUserInteractionEnabled = false
            
            addSubview(arcButtons)
            addSubview(detailDraw)
       
            // sub
            addTierThree(landingModel.tierThree)
            addTierTwo(landingModel.tierTwo)
            addTierOne(landingModel.tierOne)
            
            // three images
            let views = [tierOneBackView, tierTwoPlate, tierThreePlate]
            for view in views {
                let image = UIImageView(image: UIImage(named: "tierOne"))
                image.frame = CGRect(center: CGPoint(x: view.bounds.midX, y: view.bounds.midY), length: centerRadius * 2)
                centerImages.append(image)
                view.addSubview(image)
            }
            
            // state
            focusOnCurrentData()
        }else {
            // only show one tier
            switch displayedTireIndex {
            case 0: addTierOne(landingModel.tierOne)
            case 1: addTierTwo(landingModel.tierTwo)
                tierTwoPlate.transform = CGAffineTransform.identity
            case 2:
                createArcButtons(buttonSpace)
                addSubview(arcButtons)
                addTierThree(landingModel.tierThree)
            default: break
            }
            
            // center image
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(touchCenter))
            centerImage.addGestureRecognizer(tapGR)
            
            setupAtrributedTitleOfTier(displayedTireIndex)
        }
        
        centerImage.isUserInteractionEnabled = true
        centerImage.frame = CGRect(center: plateCenter, length: centerRadius * 2)
        centerImage.layer.addBlackShadow(4 * fontFactor)
        
        addSubview(centerImage)
    }
    
    func focusOnCurrentData() {
        // selected index
        // animation
        var selectedIndex: Int?
        if let riskClassKey = cardsCursor.selectedRiskClassKey {
            if tierIndex == 2 {
                for (i, metric) in tierThreeRiskClasses.enumerated() {
                    if metric.key == riskClassKey {
                        selectedIndex = i
                        break
                    }
                }
            }else if tierIndex == 1 {
                for (i, button) in tierTwoPlate.buttonsOnView.enumerated() {
                    if button.key == riskClassKey {
                        selectedIndex = i
                        break
                    }
                }
            }else {
                // tier one or none
            }
        }
        
        if tierIndex == -1 {
            setTiltState()
        }else {
            focusOnTier(tierIndex, selectionIndex: selectedIndex)
        }
    }
    
    func createArcButtons(_ buttonSpace: CGFloat)  {
        arcButtons.hideLine = !showAll
        
        var buttons = [CustomButton]()
        for riskType in collection.getAllRiskTypes() {
            let riskTypeType = RiskTypeType.getTypeOfRiskType(riskType.key)
            if riskTypeType == .iCa || riskTypeType == .iPa {
                continue
            }
            
            let button = CustomButton.usedAsRiskTypeButton(riskType.key)
            button.addTarget(self, action: #selector(goToGames), for: .touchUpInside)
            buttons.append(button)
        }
        
        let arcH = showAll ? 2 * (plateCenter.y - titleLabel.frame.maxY + (bounds.height - plateLength) * 0.5)
            : 2 * (plateCenter.y - titleLabel.frame.maxY)
        let arcFrame = CGRect(x: 0, y: plateCenter.y - arcH * 0.5, width: bounds.width, height: arcH)
        arcButtons.setRectBackWithFrame(arcFrame, buttons: buttons, minRadius: arcFrame.height * 0.5 - buttonSpace)
        arcButtons.setButtonsHidden(true)
    }


    // MARK: --------------- creating -----------------
    // information of sizes
    fileprivate var centerRadius: CGFloat {
        return 0.08 * plateLength
    }
    fileprivate var tierTwoRadius: CGFloat {
        return 0.43 * plateLength
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
    fileprivate var tierThreeButtons = [CustomButton]()
    fileprivate var tierThreeRiskClasses = [MetricObjModel]()
    fileprivate func addTierThree(_ tierThree:[(MetricGroupObjModel, [MetricObjModel])]) {
        tierThreeButtons.removeAll()
        let innerRadius = 305 * tierThreeRadius / 346
        tierThreePlate.pieDelegate = self
        tierThreePlate.tag = 3000
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
        tierThreePlate.setupWithFrame(CGRect(center: plateCenter, length: plateLength), outerRadius: tierThreeRadius, innerRadius: innerRadius, numberOfSlices: tierThreeRiskClasses.count, enlargeAngle: CGFloat(-Double.pi / 2))
        addSubview(tierThreePlate)
            
        for (index, riskClass) in tierThreeRiskClasses.enumerated() {
            let button = tierThreePlate.buttonsOnView[index]
            button.key = riskClass.key
            button.setupWithText("\(riskClass.name ?? "") Prevention", imageUrl: riskClass.imageUrl)
            button.addTarget(self, action: #selector(tierClicked(_:)), for: .touchUpInside)
        
            tierThreeButtons.append(button)
            buttonsOn.append(button)
        }
        
        // colorful border
        tierThreePlate.setupWithGroups(groups)
        
        if showAll {
            // gray mask on it
            let tierThreeCenter = CGPoint(x: plateLength * 0.5, y: plateLength * 0.5)
            tierThreeMaskView.backgroundColor = maskBGColor
            tierThreeMaskView.isUserInteractionEnabled = false
            tierThreeMaskView.frame = CGRect(center: tierThreeCenter, length: tierThreeRadius * 2)
            tierThreeMaskView.layer.cornerRadius = tierThreeRadius
            
            tierThreePlate.addSubview(tierThreeMaskView)
            tierThreeMaskView.isHidden = true
        }
    }
    
    // plate and two
    fileprivate let tierTwoPlate = AssortedRotateView()
    fileprivate let tierTwoMask = UIView()
    fileprivate func addTierTwo(_ tierTwo:[(MetricGroupObjModel, [MetricObjModel])]) {
        // ------------ full -----------
        addSubview(tierTwoPlate)
        
        tierTwoPlate.layer.addBlackShadow(8 * fontFactor)
        tierTwoPlate.setupWithFrame(CGRect(center: plateCenter, length: 2 * tierTwoRadius), innerRadius: centerRadius, dataSource: tierTwo)
        tierTwoPlate.pieDelegate = self
        tierTwoPlate.tag = 2000
        for button in tierTwoPlate.buttonsOnView {
            button.addTarget(self, action: #selector(tierClicked(_:)), for: .touchUpInside)
            buttonsOn.append(button)
        }

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
    fileprivate func addTierOne(_ tierOneGroup: [(MetricGroupObjModel, [MetricObjModel])]) {
        var tierOne = [MetricObjModel]()
        for (_, metrics) in tierOneGroup {
            tierOne.append(contentsOf: metrics)
        }
        
        // back and hex buttons
        tierOneBackView.backgroundColor = UIColor.clear
        tierOneBackView.frame = CGRect(center: plateCenter, length: tierThreeRadius * 2)
        addSubview(tierOneBackView)
        tierOneBackView.layer.addBlackShadow(4 * fontFactor)
        
        // three parts
        let radius = tierThreeRadius * 0.52
        for (i, metric) in tierOne.enumerated() {
            let hex = HexView()
            let angle = CGFloat(-Double.pi / 2) + CGFloat(i) * CGFloat(Double.pi) / 3 * 2
            let center = Calculation.getPositionByAngle(angle, radius: radius, origin: CGPoint(x: tierThreeRadius, y: tierThreeRadius))
            let length = 2 * (tierThreeRadius * 0.96 - radius)
            let tFrame = CGRect(center: center, width: length, height: length * 2 / sqrt(3))
            
            hex.setupWithFrame(tFrame, metric: metric)
            
            let button = hex.button
            button.key = metric.key
            button.tag = 100 + i
            button.addTarget(self, action: #selector(tierClicked(_:)), for: .touchUpInside)
            buttonsOn.append(button)
            tierOneBackView.addSubview(hex)
        }
    }
    
    // MARK: --------------------- animation ------------------------
    var tilted = false
    func setTiltState() {
        centerImages[1].isHidden = false
        resetAll()

        // orginal sizes
        let transformCenter = CGPoint.zero
        let transToCenter = CATransform3DMakeTranslation(-transformCenter.x, -transformCenter.y, 0)
        let transBack = CATransform3DMakeTranslation(transformCenter.x, transformCenter.y, 0)
        var scale = CATransform3DIdentity
        scale.m34 = -1.0 / (8 * plateLength)
        let concat = CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack)
        let rotate = CATransform3DMakeRotation(CGFloat(Double.pi * 0.39), 1, 0, 0)

        UIView.animate(withDuration: 0.15, animations: {
            self.centerImage.isHidden = true
            self.transform = CGAffineTransform.identity
            self.tierOneBackView.transform = CGAffineTransform.identity
            self.tierTwoPlate.transform = CGAffineTransform.identity
            self.tierThreePlate.transform =  CGAffineTransform.identity
        }) { (true) in
            UIView.animate(withDuration: 0.15, animations: {
                self.layer.transform = CATransform3DConcat(rotate, concat)
            }, completion: { (true) in
                self.tierOneBackView.transform = CGAffineTransform(translationX: 0, y: -self.plateLength * 1.05)
                self.tierTwoPlate.transform = CGAffineTransform(translationX: 0, y: -self.plateLength * 0.21)
                self.tierThreePlate.transform = CGAffineTransform(translationX: 0, y: self.plateLength * 0.7).scaledBy(x: 0.82, y: 0.82)
                self.arcButtons.setButtonsHidden(true)
            })
        }
        
        tilted = true
        GameTintApplication.sharedTint.focusingTierIndex = -1
        if delegate != nil {
            delegate.landingView?(self, tierIsChosen: -1)
        }
    }
    
    fileprivate func prespectiveView(_ view: UIView, angle: Double, transformCenter: CGPoint, zDistance: CGFloat) {
        let transToCenter = CATransform3DMakeTranslation(-transformCenter.x, -transformCenter.y, 0)
        let transBack = CATransform3DMakeTranslation(transformCenter.x, transformCenter.y, 0)
        var scale = CATransform3DIdentity
        scale.m34 = -1.0 / zDistance
        let concat = CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack)
        let rotate = CATransform3DMakeRotation(CGFloat(angle), 1, 0, 0)
        view.layer.transform = CATransform3DConcat(rotate, concat)
    }
    
    fileprivate var tierThreeTimer: Timer!
    fileprivate var tierTwoTimer: Timer!
    func stopTierTwoTimer() {
        if tierTwoTimer != nil {
            tierTwoTimer.invalidate()
            tierTwoPlate.adjustAngle()
            tierTwoTimer = nil
        }
    }
    
    func stopTierThreeTimer() {
        if tierThreeTimer != nil {
            tierThreeTimer.invalidate()
            tierThreePlate.adjustAngle()
            tierThreeTimer = nil
        }
    }
    
    func setUserInteractionEnabled(_ enable: Bool)  {
        isUserInteractionEnabled = enable
        arcButtons.isUserInteractionEnabled = enable
    }
    
}

// MARK: ---------------- actions and touches ------------------------
extension LandingMainView {
    func setupAtrributedTitleOfTier(_ tierIndex: Int) {
        let topFont = UIFont.systemFont(ofSize: 14 * fontFactor, weight: .medium)
        let topAttribute = [NSAttributedString.Key.font: topFont, .foregroundColor: UIColor.white]
        let decoGreen = UIColorFromRGB(178, green: 255, blue: 89)
        var attributedTop: NSMutableAttributedString!
        switch tierIndex {
        case 0:             // tier one
            let topText = "Comparison with either a set of guidelines, checklist or a community"
            attributedTop = NSMutableAttributedString(string: topText, attributes: topAttribute)

            // letters
            attributedTop.addAttributes([.font: UIFont.systemFont(ofSize: 18 * fontFactor, weight: .semibold), .foregroundColor: decoGreen], range: NSMakeRange(0, 1)) // R
            
        case 1:             // tier two
            let topText = "Individualized Prediction Assessment games based on predictive models formulated by scientific findings, studies and clinical trials"
            attributedTop = NSMutableAttributedString(string: topText, attributes: topAttribute)
           
            // letters
            attributedTop.addAttributes([.font: UIFont.systemFont(ofSize: 18 * fontFactor, weight: .semibold),  .foregroundColor: decoGreen], range: NSMakeRange(15, 1)) // R
            titleLabel.attributedText = attributedTop
            
        case 2:            // tier three and
            let topText = "Individualized Assessment:\n Risk, Symptoms, Knowledge, Impact, and Action"
            attributedTop = NSMutableAttributedString(string: topText, attributes: topAttribute)
            
            // letters
            let glyphAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18 * fontFactor, weight: .semibold),  .foregroundColor: decoGreen]
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(28, 1)) // R
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(34, 1)) // S
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(44, 1)) // K
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(55, 1)) // I
            attributedTop.addAttributes(glyphAttributes, range: NSMakeRange(67, 1)) // A
            titleLabel.attributedText = attributedTop
          
        default:        // orginal, no choice
            let topText = "Gamification of Individualized Assessment\n"
            attributedTop = NSMutableAttributedString(string: topText, attributes: topAttribute)
            attributedTop.append(NSAttributedString(string: "G.I.A.™", attributes: [.font: UIFont.systemFont(ofSize: 24 * fontFactor, weight: .bold)]))
        }
        
        titleLabel.attributedText = attributedTop
    }
    
    @objc func touchCenter() {
        if delegate != nil {
            delegate.touchCenterOfLandingView?(self)
        }
    }
    
    fileprivate func resetAll() {
        detailDraw.text = ""
        titleLabel.text = ""
        
        arcButtons.setButtonsHidden(true)
        tierThreePlate.selectedIndex = -1
        
        // hide all masks
        tierThreeMaskView.isHidden = true
        tierTwoMask.isHidden = true
  
        tierOneBackView.alpha = 1
       
        // all disabled
        tierThreePlate.isUserInteractionEnabled = false
        tierOneBackView.isUserInteractionEnabled = false
        tierTwoPlate.isUserInteractionEnabled = false
        
        // timer
        stopTierTwoTimer()
        stopTierThreeTimer()
    }
    
    func focusOnTier(_ tierIndex: Int, selectionIndex: Int?) {
        centerImage.isHidden = false
        tilted = false
        resetAll()
        
        GameTintApplication.sharedTint.focusingTierIndex = tierIndex
        layer.transform = CATransform3DIdentity
        tierThreePlate.transform = .identity
        
        // animation
        let duration: TimeInterval = 0.5
        switch tierIndex {
        case 0:             // tier one
            centerImage.isHidden = true
            UIView.animate(withDuration: duration, animations: {
                // animation
                self.tierTwoPlate.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
                self.tierOneBackView.transform = CGAffineTransform.identity
            }, completion: { (true) in
                self.tierOneBackView.isUserInteractionEnabled = true
                self.arcButtons.setButtonsHidden(true)
                // masks shows
                self.tierThreeMaskView.isHidden = false
                self.tierTwoMask.isHidden = false
            })
            
        case 1:             // tier two
            tierTwoMask.isHidden = true
            centerImages[1].isHidden = true
            tierOneBackView.alpha = 0.6
            if selectionIndex != nil {
                self.tierTwoPlate.topIndex = selectionIndex!
            }
            
            UIView.animate(withDuration: duration, animations: {
                // animation
                self.centerImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.tierTwoPlate.transform = CGAffineTransform(rotationAngle: self.tierTwoPlate.rotationAngle)
                self.tierOneBackView.transform = CGAffineTransform(scaleX: 0.22, y: 0.22)
            }, completion: { (true) in
                self.tierTwoPlate.isUserInteractionEnabled = true

                // masks shows
                self.tierThreeMaskView.isHidden = false

                let gap = self.tierTwoPlate.angleGap * 0.025
                if self.tierTwoTimer == nil {
                    self.tierTwoTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (timer) in
                        self.tierTwoPlate.tuneWithAngle(gap)
                    })
                }
            })
            
        case 2:            // tier three and ->
            tierThreeMaskView.isHidden = true
            // masks shows
            tierTwoMask.isHidden = false
            tierOneBackView.alpha = 0.6
            
            UIView.animate(withDuration: 0.3, animations: {
                self.centerImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.tierOneBackView.transform = CGAffineTransform(scaleX: 0.22, y: 0.22)
                self.tierTwoPlate.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
            }, completion: { (true) in
                self.tierThreePlate.isUserInteractionEnabled = true

                // with target risk class
                if selectionIndex != nil {
                    self.tierThreePlate.selectedIndex = selectionIndex!
                    self.riskClassIsOnShow(selectionIndex!)
                    self.tierThreePlate.scrollToAngle()
                }else {
                    self.detailDraw.text = "Spin the game wheel or Tap on a subject to select"

                    // animation
                    let gap = self.tierThreePlate.angleGap * 0.025
                    if self.tierThreeTimer == nil {
                        self.tierThreeTimer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true, block: { (timer) in
                            self.tierThreePlate.tuneWithAngle(gap)
                        })
                    }
                }
            })

        default:        // orginal, no choice
            UIView.animate(withDuration: 0.2) {
                self.centerImage.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
                self.tierOneBackView.transform = CGAffineTransform(scaleX: 0.35, y: 0.35)
                self.tierTwoPlate.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            }
        }
        
        setupAtrributedTitleOfTier(tierIndex)
        
        // delegate
        if delegate != nil {
            delegate.landingView?(self, tierIsChosen: tierIndex)
            if selectionIndex != nil && tierIndex == 2 {
                delegate.sliceIsChosen?()
            }
        }
        
        if selectionIndex == nil {
            let hintKey = "plate detail hint shown before key"
            if !userDefaults.bool(forKey: hintKey) {
                let hintVC = AbookHintViewController()
                hintVC.focusOnFrame(convert(tierThreePlate.frame, to: viewController.view), hintText: "There are Card-Matching game subjects on the wheel table, you can tap on one or choose other wheel tables.")
                hintVC.hintKey = hintKey
                viewController.overCurrentPresentController?.present(hintVC, animated: true, completion: nil)
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
                }, completion:{ (true) in
                    self.checkArcHint()
                })
            })
        })
    }
    
    fileprivate func checkArcHint() {
        if !showAll {
            return
        }
        
        let hintKey = "plate arc buttons hint shown before key"
        if !userDefaults.bool(forKey: hintKey) {
            let hintVC = AbookHintViewController()
            hintVC.blankAreaIsTouched = goToIRAGame
            // larger
            let iraButtonFrame = arcButtons.buttons[1].frame.insetBy(dx: -5 * fontFactor, dy: -5 * fontFactor)
            let frameInLanding = convert(iraButtonFrame, from: arcButtons)
            hintVC.focusOnFrame(convert(frameInLanding, to: viewController.view), hintText: "There are 6 game types in this layer, and you can choose one of them.")
            hintVC.hintKey = hintKey
            viewController.overCurrentPresentController?.present(hintVC, animated: true, completion: nil)
        }
    }
    
    func goToIRAGame()  {
        goToGames(arcButtons.buttons[1])
    }
    
    @objc func goToGames(_ button: CustomButton) {
        if delegate != nil {
            delegate.arcButtonIsChosen?(button)
        }
    }
    
    // hit button
    func tierIndexForPoint(_ point: CGPoint) -> Int {
        if tilted {
            if tierOneBackView.frame.contains(point) {
                return 0
            }else if tierTwoPlate.frame.contains(point) {
                return 1
            }else if tierThreePlate.frame.contains(point) {
                return 2
            }
            
            return -1
        }
        
        let current = GameTintApplication.sharedTint.focusingTierIndex
        let distenceToCenter = Calculation.distanceOfPointA(point, pointB: plateCenter)
        if  distenceToCenter <= centerRadius * 1.2 {
            // tier one is touched
            return 0
        }
        
        // during transform
        if distenceToCenter <= tierTwoPlate.frame.width * 0.5 {
            if current == 1 {
                var inTwo = false
                for path in tierTwoPlate.pathes {
                    if path.contains(convert(point, to: tierTwoPlate)) {
                        inTwo = true
                        break
                    }
                }
                return inTwo ? 1 : 2
            }else {
                return 1
            }
        }
        
        if distenceToCenter <= tierThreeRadius {
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
    @objc func remindOfTierOne() {
        UIView.animate(withDuration: 0.2, animations: {
            self.tierOneBackView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }, completion: { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                self.tierOneBackView.transform = CGAffineTransform.identity
            })
        })
    }

    @objc func tierClicked(_ button: CustomButton) {
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
        }else if button.tag >= 200 {
            tierTwoPlate.topIndex = button.tag - 200
            tierTwoPlate.scrollToAngle()
        }else {
            if delegate != nil {
                delegate!.landingView?(self, chosen: button)
            }
        }
    }

    
    // hitTest
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        var view = super.hitTest(point, with: event)

        if arcButtons.transform == CGAffineTransform.identity {
            let bPoint = convert(point, to: arcButtons)
            for button in arcButtons.buttons {
                if button.frame.contains(bPoint) && !button.isHidden {
                    view = button
                    break
                }
            }
        }

        return view
    }
    
    func pieView(_ pie: UIView, didMoveTo index: Int) {
        if pie.tag == 3000 {
            if showAll {
                stopTierThreeTimer()
                
                riskClassIsOnShow(index)
                shakeToRemind()
            }else {
                if delegate != nil {
                    delegate.landingView?(self, chosen: tierThreeButtons[index])
                }
            }
        }else {
            if tierTwoTimer != nil {
                stopTierThreeTimer()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    if self.delegate != nil {
                        self.delegate!.landingView?(self, chosen: self.tierTwoPlate.buttonsOnView[self.tierTwoPlate.topIndex])
                    }
                }
            }else {
                if self.delegate != nil {
                    delegate!.landingView?(self, chosen: tierTwoPlate.buttonsOnView[tierTwoPlate.topIndex])
                }
            }
        }
    }
    
    func pieView(_ pie: UIView, isRotatingTo index: Int) {
        if pie.tag == 3000 {
             if showAll {
                stopTierThreeTimer()
                riskClassIsOnShow(index)
             }else {
                if delegate != nil {
                    delegate.landingView?(self, chosen: tierThreeButtons[index])
                }
            }
        }else {
            stopTierTwoTimer()
        }
    }
}
