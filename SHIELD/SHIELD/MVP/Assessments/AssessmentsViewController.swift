//
//  AssessmentsViewController.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/3.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class AssessmentsViewController: UIViewController {
    enum AssessmentsDisplayState {
        case overall, onTopic, cards
    }
    
    fileprivate var displayState = AssessmentsDisplayState.overall
    var userkey: String {
        return userCenter.currentGameTargetUser.Key()
    }
    
    fileprivate var drawView: AssessmentsDrawView!
    fileprivate var avatar: PlayerButton!
    fileprivate var topics = [UIButton]()
    fileprivate var topicDecos = [UIImageView]()
   
    fileprivate var riskTypes = [CustomButton]()
    fileprivate var riskClasses = [CustomButton]()
    fileprivate let modeSwitch = UISwitch()
    
    fileprivate var assessments: AssessmentsCollectionView!
    
    fileprivate var topicPoint = CGPoint.zero
    fileprivate var secondPoint = CGPoint.zero
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My Assessments"
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: createBackButton())
        
        let fullFrame = CGRect(x: 0, y: 0, width: width, height: height)
        drawView = AssessmentsDrawView(frame: fullFrame)
        drawView.backgroundColor = UIColorFromHex(0xECFFD6)
        view.addSubview(drawView)
        
        // avatar
        let center = CGPoint(x: mainFrame.midX, y: mainFrame.midY)
        avatar = PlayerButton.createAsNormalView(CGRect(center: center, width: 75 * standWP, height: 69 * standWP))
        avatar.buttonAction = avatarIsTouched
        drawView.addSubview(avatar)

        // topicNodes
        for i  in 0..<3 {
            // deco
            let deco = UIImageView(image: UIImage(named: "butterfly"))
            deco.frame = CGRect(center: center, width: 157 * standWP, height: 124 * standWP)
            drawView.addSubview(deco)
            topicDecos.append(deco)
            
            // ia by ...
            let topic = UIButton(type: .custom)
            topic.setBackgroundImage(UIImage(named: "act_\(i)"), for: .normal)
            topic.frame = CGRect(center: center, width: 101 * standWP, height: 105 * standWP)
            topic.tag = 100 + i
            topic.addTarget(self, action: #selector(focusOnTopic), for: .touchUpInside)
            drawView.addSubview(topic)
            topics.append(topic)
        }
        
        // switch
        modeSwitch.frame = CGRect(x: 8 * fontFactor, y: 5 * fontFactor + topLength, width: 51 * fontFactor, height: 36 * fontFactor)
        drawView.addSubview(modeSwitch)
        modeSwitch.addTarget(self, action: #selector(switchMode), for: .valueChanged)
        modeSwitch.isOn = false
        
        // collection
        assessments = AssessmentsCollectionView.createWithFrame(fullFrame)
        assessments.backgroundColor = UIColorFromHex(0xECFFD6)
        
        view.addSubview(assessments)
        // points
        topicPoint = CGPoint(x: 55 * fontFactor, y: 44 * fontFactor)
        secondPoint = CGPoint(x: 111 * fontFactor, y: 96 * fontFactor)
        assessments.topicPoint = topicPoint
        assessments.secondPoint = secondPoint
        assessments.isHidden = true
    }
    
    override func backButtonClicked() {
        switch displayState {
        case .overall: navigationController?.popViewController(animated: true)
        case .onTopic: setToTopicState()
        case .cards: backToLast()
        }
    }
    
    @objc func avatarIsTouched() {
        if chosenTopicIndex == nil {
            // go to player
            let player = ABookPlayerViewController.initFromStoryBoard()
            navigationController?.pushViewController(player, animated: true)
        }else {
            setToTopicState()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !assessments.isHidden {
            assessments.reloadData()
        }else {
            setToTopicState()
        }
    }
    
    fileprivate var chosenTopicIndex: Int!
    @objc func setToTopicState() {
        assessments.isHidden = true
        displayState = .overall
        navigationItem.title = "My Assessments"
        
        clearRiskTypes()
        clearRiskClasses()
        
        let radius = 120 * standWP
        let center = CGPoint(x: mainFrame.midX, y: mainFrame.midY)
        
        drawView.drawTopicState(center, radius: radius)
        for deco in topicDecos {
            deco.isHidden = false
        }
        modeSwitch.isHidden = true
        chosenTopicIndex = nil
        
        UIView.animate(withDuration: 0.2, animations: {
            self.avatar.transform = CGAffineTransform.identity
            for (i, topic) in self.topics.enumerated() {
                let angle = CGFloat(Double.pi) * (-2 * CGFloat(i) / 3 + 1.5)
                let topicCenter = CGPoint(x: radius * cos(angle) + center.x, y: radius * sin(angle) + center.y)
                topic.center = topicCenter
                topic.transform = CGAffineTransform.identity
                self.topicDecos[i].center = topicCenter
            }
        }) { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                for (i, deco) in self.topicDecos.enumerated() {
                    let angle = CGFloat(Double.pi) * (-2 * CGFloat(i) / 3 + 1)
                    deco.transform = CGAffineTransform(rotationAngle: angle)
                }
            })
        }
    }
    
    fileprivate var topFrame = CGRect.zero
    @objc func focusOnTopic(_ button: UIButton) {
        displayState = .onTopic
        if chosenTopicIndex != nil && chosenTopicIndex == button.tag - 100 {
            return
        }
        modeSwitch.isHidden = false
        
        clearRiskTypes()
        clearRiskClasses()
        
        chosenTopicIndex = button.tag - 100
        setNaviTitleForTopicFocus()
        // layout
        let topCenter = CGPoint(x: mainFrame.midX, y: width * 0.5 + topLength)
        let radius = 273 * 0.5 * standWP
        topFrame = CGRect(center: topCenter, length: radius * 2)
        let leftH = mainFrame.height - width
        let topicL = min(leftH, 94 * standHP)
        let ratio = topicL / (105 * standWP)
        
        let bottomPoint = CGPoint(x: mainFrame.midX, y: mainFrame.maxY - 40 * standHP)
        let avatarRatio = (54 * standHP) / (69 * standWP)
        
        let leftY = max(mainFrame.height - topicL, width + topLength + topicL * 0.5)
        let leftPoint = CGPoint(x: topicL , y: leftY)
        let rightPoint = CGPoint(x: width - topicL, y: leftY)
        
        var leftButtons = [UIButton]()
        for (i, one) in topics.enumerated() {
            if i != chosenTopicIndex {
                leftButtons.append(one)
                topicDecos[i].isHidden = true
            }
        }
        let left = leftButtons.first!
        let right = leftButtons.last!
        
        UIView.animate(withDuration: 0.2, animations: {
            self.avatar.transform = CGAffineTransform(translationX: 0, y: bottomPoint.y - mainFrame.midY).scaledBy(x: avatarRatio, y: avatarRatio)
            button.center = topCenter
            button.transform = CGAffineTransform.identity
            
            left.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            right.transform = CGAffineTransform(scaleX: ratio, y: ratio)
            
            left.center = leftPoint
            right.center = rightPoint
            for (i, deco) in self.topicDecos.enumerated() {
                deco.center = self.topics[i].center
                deco.transform = CGAffineTransform.identity
            }
        }) { (true) in
            for deco in self.topicDecos {
                deco.isHidden = true
            }
            
            self.drawView.drawTopicChosen(CGRect(center: topCenter, length: radius * 2), bottomPoint: bottomPoint, left: leftPoint, right: rightPoint)
            
            if self.modeSwitch.isOn {
                self.layoutRiskTypes()
            }else {
                self.layoutRiskClasses()
            }
        }
    }

    fileprivate func setNaviTitleForTopicFocus() {
        if chosenTopicIndex == 0 {
            navigationItem.title = "IA by Comparision"
        }else if chosenTopicIndex == 1 {
            navigationItem.title = "IA by Prediction"
        }else {
            navigationItem.title = "IA by Stratification"
        }
    }
    
    @objc func switchMode() {
        if modeSwitch.isOn {
            layoutRiskTypes()
        }else {
            layoutRiskClasses()
        }
    }
    
    fileprivate func layoutRiskTypes() {
        clearRiskTypes()
        clearRiskClasses()
        
        for key in getRiskTypesOfCurrentTopic() {
            let type = CustomButton.usedAsRiskTypeButton(key)
            type.adjustRiskTypeButtonWithFrame(CGRect(center: CGPoint(x: topFrame.midX, y: topFrame.midY), width: 75 * fontFactor, height: 64 * fontFactor))
            type.addTarget(self, action: #selector(riskTypeIsChosen(_:)), for: .touchUpInside)
            riskTypes.append(type)
            drawView.addSubview(type)
            
            let result = MatchedCardsDisplayModel.getMostPlayedOfRiskType(key)
            type.changeRiskTypeButtonColor(MatchedCardsDisplayModel.getColorOfIden(result))
        }
        
        let radius = topFrame.width * 0.5
        UIView.animate(withDuration: 0.15) {
            for (i, type) in self.riskTypes.enumerated() {
                let angle = CGFloat(Double.pi) * (-2 * CGFloat(i) / CGFloat(self.riskTypes.count) + 1.5)
                type.center = CGPoint(x: radius * cos(angle) + self.topFrame.midX, y: radius * sin(angle) + self.topFrame.midY)
            }
        }
    }
    
    fileprivate func getRiskTypesOfCurrentTopic() -> [String] {
        var riskTypeKeys = [String]()
        if chosenTopicIndex == 0 {
            riskTypeKeys = [GameTintApplication.sharedTint.iCaKey]
        }else if chosenTopicIndex == 1 {
            riskTypeKeys = [GameTintApplication.sharedTint.iPaKey]
        }else {
            for type in collection.getAllRiskTypes() {
                if type.key == GameTintApplication.sharedTint.iCaKey || type.key == GameTintApplication.sharedTint.iPaKey {
                    continue
                }
                riskTypeKeys.append(type.key)
            }
        }
        return riskTypeKeys
    }

    fileprivate func layoutRiskClasses() {
        clearRiskTypes()
        clearRiskClasses()
        
        let riskClassModels = LandingModel.getAllTierRiskClasses()[chosenTopicIndex] ?? []
        let expectedLength = (topFrame.minY - topLength) * 2 * 0.8
        
        let center = CGPoint(x: topFrame.midX, y: topFrame.midY)
        for riskClass in riskClassModels {
            let button = CustomButton.createBlackBorderButton()
            button.key = riskClass.key
            button.frame = CGRect(center: center, length: expectedLength)
            button.setupWithText(riskClass.name, imageUrl: riskClass.imageUrl)
            button.adjustRoundBlackBorderButton()
            
            let result = MatchedCardsDisplayModel.getMostPlayedOfRiskClass(riskClass.key)
            button.backgroundColor = MatchedCardsDisplayModel.getColorOfIden(result)
            
            button.addTarget(self, action: #selector(riskClassIsChosen(_:)), for: .touchUpInside)
            riskClasses.append(button)
            drawView.addSubview(button)
        }
        
        UIView.animate(withDuration: 0.15, animations: {
            Calculation.layoutEvenCircleWithCenter(center, nodes: self.riskClasses, radius: self.topFrame.width * 0.5, startAngle: CGFloat(Double.pi * 1.5), expectedLength: expectedLength)
            for button in self.riskClasses {
                button.adjustRoundBlackBorderButton()
            }
        }) { (true) in

        }
    }
    
    // clear
    fileprivate func clearRiskTypes() {
        for type in riskTypes {
            type.removeFromSuperview()
        }
        riskTypes.removeAll()
    }
    
    fileprivate func clearRiskClasses() {
        for riskClass in riskClasses {
            riskClass.removeFromSuperview()
        }
        riskClasses.removeAll()
    }
    
    @objc func riskTypeIsChosen(_ button: CustomButton) {
        prepareForCollectionView()
        
        secondCenter = button.center
        secondCopy = CustomButton.usedAsRiskTypeButton(button.key)
        secondCopy.adjustRiskTypeButtonWithFrame(button.frame)
        secondCopy.changeRiskTypeButtonColor(button.riskTypeColor)
        assessments.addSubview(secondCopy)
        
        var riskClassKeys = [String]()
        let riskClassModels = LandingModel.getAllTierRiskClasses()[chosenTopicIndex] ?? []
        for riskClass in riskClassModels {
            let risks = collection.getRiskModelKeys(riskClass.key, riskType: button.key)
            if risks.count != 0 {
                riskClassKeys.append(riskClass.key)
            }
        }
        
        assessments.checkDataFromRiskType(button.key, riskClasses: riskClassKeys)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.topicCopy.frame = CGRect(center: self.topicPoint, length: 70 * fontFactor)
            self.secondCopy.center = self.secondPoint
        }) { (true) in
            self.assessments.duringPrepare = false
        }
    }
    
    @objc func riskClassIsChosen(_ button: CustomButton) {
        prepareForCollectionView()
        secondCenter = button.center
        
        let riskClass = collection.getMetric(button.key)
        secondCopy = CustomButton.createBlackBorderButton()
        secondCopy.setupWithText(riskClass?.name, imageUrl: riskClass?.imageUrl)
        secondCopy.backgroundColor = button.backgroundColor
        secondCopy.frame = button.frame
        secondCopy.adjustRoundBlackBorderButton()
        assessments.addSubview(secondCopy)
        
        var riskTypeKeys = [String]()
        for riskType in getRiskTypesOfCurrentTopic() {
            let risks = collection.getRiskModelKeys(button.key, riskType: riskType)
            if risks.count != 0 {
                riskTypeKeys.append(riskType)
            }
        }
        
        assessments.checkDataFromRiskClass(button.key, riskTypes: riskTypeKeys)
        UIView.animate(withDuration: 0.2, animations: {
            self.topicCopy.frame = CGRect(center: self.topicPoint, length: 70 * fontFactor)
            self.secondCopy.frame = CGRect(center: self.secondPoint, length: 60 * fontFactor)
        }) { (true) in
            self.secondCopy.adjustRoundBlackBorderButton()
            self.assessments.duringPrepare = false
        }

    }
    
    fileprivate var topicCopy: UIButton!
    fileprivate var secondCopy: CustomButton!
    fileprivate var secondCenter = CGPoint.zero
    fileprivate func prepareForCollectionView() {
        displayState = .cards
        assessments.duringPrepare = true
        assessments.isHidden = false
        
        if topicCopy == nil {
            topicCopy = UIButton(type: .custom)
            topicCopy.addTarget(self, action: #selector(backToLast), for: .touchUpInside)
            assessments.addSubview(topicCopy)
        }
        let topic = topics[chosenTopicIndex]
        topicCopy.setBackgroundImage(topic.currentBackgroundImage, for: .normal)
        topicCopy.frame = topic.frame
    }
    
    @objc func backToLast() {
        displayState = .onTopic
        assessments.duringPrepare = true
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topicCopy.center = CGPoint(x: self.topFrame.midX, y: self.topFrame.midY)
            self.secondCopy.center = self.secondCenter
        }) { (true) in
            self.secondCopy.removeFromSuperview()
            self.secondCopy = nil
            self.assessments.isHidden = true
        }
    }
}
