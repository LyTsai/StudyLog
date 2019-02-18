//
//  MatchedCardsMapView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/23.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardsMapView: VisualMapCustomView {
    // area for laying nodes
    fileprivate var mainFrame = CGRect.zero
    class func createWithFrame(_ frame: CGRect, ratio: CGFloat) -> MatchedCardsMapView {
        let view = MatchedCardsMapView(frame: frame)
        if frame.height / frame.width < ratio {
            view.mainFrame = CGRect(center: CGPoint(x: frame.midX, y: frame.midY), width: frame.height / ratio, height: frame.height)
        }else {
            view.mainFrame = frame
        }
        
        view.setFramesData()
        view.createBasicNodes()
        
        return view
    }
    
    // node
    fileprivate var cardsDisplayView: MatchedCardDisplayView!
    
    // dataSource
    // [key: [cards]]
    fileprivate var matched = [String: [CardInfoObjModel]]()
    fileprivate var cardToRisks = [String: [RiskObjModel]]()
    
    fileprivate var timer: Timer!
    fileprivate let dotView = UIView()
    
    // frames
    fileprivate var standP: CGFloat = 0
    fileprivate var viewCenter = CGPoint.zero
    fileprivate var topCenter = CGPoint.zero
    fileprivate var radius: CGFloat = 0
    fileprivate let decoImage = UIImage(named: "butterfly_circle")
    fileprivate var decoSize: CGSize {
        return CGSize(width: 2 * radius / sqrt(2), height: 2 * radius / sqrt(2))
    }
    fileprivate var helpLength: CGFloat = 0
    fileprivate var typeLength: CGFloat = 0
    fileprivate var avatarCenter: CGPoint {
        return CGPoint(x: avatar.frame.midX, y: avatar.frame.midY)
    }

    // init
    fileprivate func setFramesData() {
        standP = min(mainFrame.width / 375, mainFrame.height / 554)
        viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        topCenter = CGPoint(x: bounds.midX, y: 180 * standP)
        radius = 268 * standP * 0.5
        helpLength = 90 * standP
        typeLength = 80 * standP
    }
    
    fileprivate func createBasicNodes() {
        // dot
        dotView.backgroundColor = UIColorFromRGB(178, green: 255, blue: 89)
        dotView.frame = CGRect(center: CGPoint.zero, length: standP * 8)
        dotView.center = Calculation().getPositionByAngle(CGFloat(Double.pi) * 7 / 6, radius: radius, origin: viewCenter)
        dotView.layer.cornerRadius = standP * 4
        dotView.isHidden = true
        addSubview(dotView)
        
        // avatar
        avatar.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), width: 111 * standP, height: 76 * standP)
        addSubview(avatar)
        
        // helps
        // tier 1, 2, 3
        createHelpNodes(false, nodeFrame: CGRect(center: viewCenter, length: helpLength), decoSize: CGSize.zero)
    
        // riskTypes
        createRiskTypeNodes()
        
        // cards
        cardsDisplayView = MatchedCardDisplayView(frame:(CGRect(x: 0, y: 5 * standP, width: bounds.width, height: bounds.height * 0.72).insetBy(dx: bounds.width * 0.05, dy: 0)))
        cardsDisplayView.isHidden = true
        addSubview(cardsDisplayView)
        
        reloadMap()
    }
    
    // reload
    func reloadMap() {
        reloadData()
        setToOverallState()

    }

    fileprivate func reloadData() {
        // data part
        matched.removeAll()
        
        // tier 1, and 2
        for (group, classes) in collection.getAllGroupedRiskClasses() {
              if group.tierPosition != 3 {
                // tier 1 and 2
                for riskClass in classes {
                    var allCards = [CardInfoObjModel]()
                    let cards = MatchedCardsDisplayModel.getAllMatchedCardsOfRiskClass(riskClass.key, riskTypeKey: group.tierPosition == 2 ? iPaKey : iCaKey, forUser: userKey)

                    if cards.count != 0 {
                        for card in cards {
                            if !allCards.contains(card) {
                                allCards.append(card)
                            }
                        }
                    }
                    if allCards.count != 0 {
                        matched[riskClass.key] = allCards
                    }
                }
            }
        }
       
        // tier 3
        for riskType in collection.getAllRiskTypes() {
            if riskType.key == iCaKey || riskType.key == iPaKey {
                continue
            }
            
            let allCards = MatchedCardsDisplayModel.getAllMatchedCardsOfRiskType(riskType.key, forUser: userKey)
            if allCards.count != 0 {
                matched[riskType.key] = allCards
            }
        }
        
        // ui part
        setRiskTypeNodeTitles(true)
        for riskType in riskTypeNodes {
            riskType.center = avatarCenter
            
            if matched[riskType.key] == nil {
                riskType.innerColor = UIColorGray(213)
                riskType.isDisabled = true
            }else {
                riskType.isDisabled = false
                riskType.innerColor = UIColor.white
                
                // circle(or inner ??)
                if riskType.text != nil {
//                    riskType.circleColor = riskType
                    if riskType.text.localizedCaseInsensitiveContains("ira") {
                        riskType.circleColor = UIColorFromRGB(0, green: 176, blue: 255)
                    }else if riskType.text.localizedCaseInsensitiveContains("isa") {
                        riskType.circleColor = UIColorFromRGB(238, green: 109, blue: 107)
                    }else if riskType.text.localizedCaseInsensitiveContains("iia") {
                        riskType.circleColor = UIColorFromRGB(255, green: 196, blue: 0)
                    }else if riskType.text.localizedCaseInsensitiveContains("iaa") {
                        riskType.circleColor = UIColorFromRGB(100, green: 221, blue: 23)
                    }else {
                        riskType.circleColor = UIColorFromRGB(169, green: 83, blue: 251)
                    }
                }
            }
        }
    }
    
    // MARK: --------------- nodes -----------------------
    fileprivate func hideRiskTypes() {
        for node in riskTypeNodes {
            node.alpha = 0
            node.frame = CGRect(center: topCenter, length: typeLength)
        }
    }
    
    fileprivate func removeRiskClasses() {
        for node in riskClassNodes {
            node.removeFromSuperview()
        }
        riskClassNodes.removeAll()
    }
    
    fileprivate func setRiskTypeNodeTitles(_ total: Bool) {
        for riskType in riskTypeNodes {
            let name = collection.getRiskTypeByKey(riskType.key)!.name ?? "iRa"
            
            let index = name.index(name.startIndex, offsetBy: 3)
            let typeName = name.substring(to: index)
            riskType.text = total ? name : typeName
            
            if riskType.key == chosenRiskTypeKey {
                riskType.text = name
            }
            riskType.boldFont = !total
        }
    }
    
    fileprivate func setRiskClassNodes() {
        removeRiskClasses()
        
        // riskClasses
        let groupedRiskClasses = collection.getAllGroupedRiskClasses()
        
        // risks
        for (group, metrics) in groupedRiskClasses {
            // different tier, different riskClasses
            if group.tierPosition == chosenHelpIndex + 1 {
                for metric in metrics {
                    let node = ButterflyNode()
                    node.key = metric.key
                    
                    if metric.imageUrl != nil {
                        node.imageUrl = metric.imageUrl
                    }
                    
                    node.text = metric.name
                    
                    riskClassNodes.append(node)
                    node.alpha = 0
                    node.frame = CGRect(center: topCenter, length: typeLength)
                    insertSubview(node, belowSubview: helpNodes[chosenHelpIndex])
                    
                    // set up riskclass answer state
                    if matched[node.key] == nil {
                        node.isDisabled = true
                    }else {
                        node.layer.addBlackShadow(3 * fontFactor)
                    }
                }
            }
        }
        
    }
    
    
    // MARK: ---------------- state ---------------
    fileprivate func setToOverallState() {
        state = .showHelps
        
        // hide
        hideRiskTypes()
        removeRiskClasses()
        
        cardsDisplayView.isHidden = true
        
        setNeedsDisplay()
        
        // layout
        UIView.animate(withDuration: 0.5, animations: {
            self.avatar.transform = CGAffineTransform.identity
            ButterflyLayout.layoutEvenCircleWithRootCenter(self.viewCenter, children: self.helpNodes, radius: self.radius, startAngle: 30, expectedLength: self.helpLength)
        }, completion: { (true) in
            // timer
            var angle = CGFloat(Double.pi) * 7 / 6
            self.dotView.isHidden = false
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
                self.dotView.center = Calculation().getPositionByAngle(angle, radius: self.radius, origin: self.viewCenter)
                angle += 0.018
                
                if angle > 2 * CGFloat(Double.pi) {
                    angle -= 2 * CGFloat(Double.pi)
                }
            })
        })
    }
    
    
    fileprivate func setToHelpChosenState() {
        state = .showRiskTypes
        
        var arrange = [ButterflyNode]()
        if self.chosenHelpIndex != 2 {
            // hide riskTypes
            hideRiskTypes()
            // riskClasses
            self.setRiskClassNodes()
            arrange = riskClassNodes
        }else {
            // remove riskClasses
            removeRiskClasses()
            
            // set riskTpes
            self.setRiskTypeNodeTitles(true)
            let ira = riskTypeNodes[1]
            ira.alpha = 1
            ira.frame = CGRect(center: topCenter, length: typeLength)
            arrange = riskTypeNodes
            arrange.remove(at: 1)
        }
        
        draw = false
        setNeedsDisplay()
        
        cardsDisplayView.isHidden = true
        
        let bottomY = mainFrame.height - 36 * standHP
        var aTransform = CGAffineTransform(translationX: 0, y: bottomY - self.bounds.midY)
        aTransform = aTransform.scaledBy(x: 0.55, y: 0.55)
        UIView.animate(withDuration: 0.4, animations: {
            self.avatar.transform = aTransform
            ButterflyLayout.layoutOneGroupWithRootCenter(self.avatarCenter, children: self.helpNodes, childSize: CGSize(width: 70 * self.standP, height: 70 * self.standP), childAlpha: 0.8, radius: 120 * self.standP, startAngle: 200, totalAngle: 140, chosenIndex: self.chosenHelpIndex, chosenSize: CGSize(width: self.helpLength, height: self.helpLength), chosenRadius: 110 * self.standP, chosenAngle: 270)
            
            ButterflyLayout.layoutEvenCircleWithRootCenter(self.topCenter, children: arrange, radius: self.radius, startAngle: 45, expectedLength: self.typeLength)
            
        }) { (true) in
            self.draw = true
            self.setNeedsDisplay()
        }
    }
    
    // risk type chosen
    fileprivate func showMatchedCards() {
        state = .showCards
        
        for help in helpNodes {
            help.alpha = 0
        }
        
        setRiskTypeNodeTitles(false)
       
        draw = false
        setNeedsDisplay()
            
        // cards
        var arrange = riskTypeNodes
        var index = chosenRiskTypeIndex
        
        if chosenHelpIndex != 2 {
            arrange = riskClassNodes
            index = chosenRiskClassIndex
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            self.avatar.transform = CGAffineTransform(translationX: 0, y: self.bounds.height * 0.42)
            self.avatar.transform = self.avatar.transform.scaledBy(x: 0.5, y: 0.5)
            
            // risk types
            let ovalB = self.avatarCenter.y - self.cardsDisplayView.frame.maxY
            ButterflyLayout.layoutOvalGroupWithRootCenter(self.avatarCenter, children: arrange, childSize: CGSize(width: 45 * self.standP, height: 45 * self.standP), childAlpha: 1, ovalA: self.bounds.midX - 60 * self.standP, ovalB: ovalB - 60 * self.standP, startAngle: 175, totalAngle: 190, chosenIndex: index, chosenSize: CGSize(width: 70 * self.standP, height: 70 * self.standP), chosenRadius: ovalB - 50 * self.standP, chosenAngle: 270)
        }) { (true) in
            self.updateCardsView()
            self.draw = true
            self.setNeedsDisplay()
        }
    }
    
    fileprivate func updateCardsView() {
        if chosenHelpIndex == 2 {
            cardsDisplayView.reloadWithCards(matched[chosenRiskTypeKey] ?? [], riskTypeKey: chosenRiskTypeKey)
        }else {
            cardsDisplayView.reloadWithCards(matched[chosenRiskClassKey] ?? [], riskTypeKey: chosenHelpIndex == 0 ? iCaKey : iPaKey)
        }
        
        cardsDisplayView.isHidden = false
    }

    // chosen
    var state = ButterflyMapState.showHelps {
        didSet{
            if state != .showHelps {
                if timer != nil {
                    timer.invalidate()
                    timer = nil
                    dotView.isHidden = true
                }
            }
        }
    }
    

    // touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        
        // avatar
        if avatar.frame.contains(point) {
            if state != .showHelps {
                // overall
                setToOverallState()
            }
            return
        }
        
        for node in helpNodes {
            if node.frame.contains(point) && node.alpha != 0{
                if state != .showRiskTypes || (node.tag - 100) != chosenHelpIndex {
                    chosenHelpIndex = node.tag - 100
                    setToHelpChosenState()
                }
                return
            }
        }
        
        for node in riskTypeNodes {
            if node.frame.contains(point) && node.alpha != 0 {
                if node.isDisabled {
                    showAlert()
                }else {
                    if state != .showCards || chosenRiskTypeKey != node.key {
                        chosenRiskTypeKey = node.key
                        showMatchedCards()
                    }
                }
        
                return
            }
        }
        
        for node in riskClassNodes {
            if node.frame.contains(point) && node.alpha != 0 {
                if node.isDisabled {
                    showAlert()
                }else {
                    if state != .showRiskClasses || chosenRiskTypeKey != node.key{
                        chosenRiskTypeKey = (chosenHelpIndex == 0 ? iCaKey : iPaKey)
                        chosenRiskClassKey = node.key
                        showMatchedCards()
                    }
                }
                
                return
            }
        }
    }
    
    // connnect with person
    fileprivate var draw = true
    override func draw(_ rect: CGRect) {
        switch state {
        case .showHelps:
            // butterfly back
            decoImage?.draw(in: CGRect(center: viewCenter, length: 2 * (radius + standP)), blendMode: .color, alpha: 1)
        case .showRiskTypes, .showRiskClasses:
            // butterfly
            decoImage?.draw(in: CGRect(center: topCenter, length: 2 * (radius + standP)), blendMode: .color, alpha: 1)
            
            if draw {
                let path = UIBezierPath()
                for help in helpNodes {
                    path.move(to: avatarCenter)
                    path.addLine(to: help.center)
                }
                
                UIColorFromRGB(178, green: 255, blue: 89).setStroke()
                path.lineWidth = standP
                path.stroke()
                
                // middle line
                let mPath = UIBezierPath()
                mPath.move(to: avatarCenter)
                mPath.addLine(to: CGPoint(x: bounds.midX, y: topCenter.y + radius))
                mPath.lineWidth = standP * 2
                mPath.stroke()
            }
        case .showCards:
            if !draw {
                return
            }
            // draw
            if chosenHelpIndex == 2 {
                for riskType in riskTypeNodes {
                    let path = UIBezierPath()
                    path.move(to: avatarCenter)
                    path.addLine(to: riskType.center)
                    
                    riskType.circleColor.setStroke()
                    riskType.lineWidth = 2 * standP
                    
                    path.stroke()
                }
            }else {
                for node in riskClassNodes {
                    let path = UIBezierPath()
                    path.move(to: avatarCenter)
                    path.addLine(to: node.center)
                    
                    UIColor.white.setStroke()
                    node.lineWidth = 2 * standP
                    path.stroke()
                }
            }
          
            let path = UIBezierPath()
            path.move(to: avatarCenter)
            path.addLine(to: CGPoint(x: bounds.midX, y: cardsDisplayView.frame.maxY))
            
            UIColor.white.setStroke()
            path.lineWidth = 2 * standP
            
            path.stroke()
        }
    }
}
