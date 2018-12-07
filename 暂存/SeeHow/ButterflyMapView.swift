//
//  ButterflyMapView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/7.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

// risks are loaded before
class ButterflyMapView: VisualMapCustomView {
    // data
    var mapState = ButterflyMapState.showHelps
    var viewMode = ButterflyViewMode.fromRiskClass

    // init
    fileprivate var mainFrame = CGRect.zero
    class func createWithFrame(_ frame: CGRect, ratio: CGFloat) -> ButterflyMapView {
        let view = ButterflyMapView(frame: frame)
        if frame.height / frame.width < ratio {
            view.mainFrame = CGRect(center: CGPoint(x: frame.midX, y: frame.midY), width: frame.height / ratio, height: frame.height)
        }else {
            view.mainFrame = frame
        }
        view.setupSeeForUI()
        
        return view
    }
    
    // only add some fixed data -- till topics
    fileprivate func setupSeeForUI() {
        setFramesData()
    
        avatar.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY - standP * 6.5), width: 90 * standP, height: 90 * standP)
        
        // riskTypes
        createRiskTypeNodes()
        // helpNodes
        createHelpNodes(true, nodeFrame: topicFrame, decoSize: decoSize)
        addSubview(avatar)
        
        showHelpNodes()
        
        // mode
        modeSwitch.frame = CGRect(x: 10 * standP, y: 5 * standP, width: 70 * standP, height: 35 * standP)
        addSubview(modeSwitch)
        modeSwitch.addTarget(self, action: #selector(changeMode), for: .valueChanged)
        modeSwitch.isHidden = true
        modeSwitch.isOn = true
    }
    
    // frames
    fileprivate var chosenAngle: CGFloat = 270
    fileprivate var standWP: CGFloat = 0
    fileprivate var standHP: CGFloat = 0
    fileprivate var standP: CGFloat = 0
    fileprivate var viewCenter = CGPoint.zero
    fileprivate var radius: CGFloat = 0
    fileprivate var topBackFrame = CGRect.zero
    fileprivate var decoSize = CGSize.zero
    fileprivate var topicFrame = CGRect.zero
    fileprivate var topCenter = CGPoint.zero
    fileprivate var topRadius: CGFloat = 0
    
    // card
    fileprivate var cardsCenter = CGPoint.zero
    fileprivate var cardsRadius: CGFloat = 0
    var cardTimer: Timer!
    fileprivate var autoPlay = false
    
    fileprivate func setFramesData()  {
        standWP =  mainFrame.width / 375
        standHP = mainFrame.height / 554
        standP = min(standWP, standHP)
        
        viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        radius = 268 * standP * 0.5
        topBackFrame = CGRect(x: bounds.midX - 235 * standP * 0.5, y: 65 * standHP, width: 235 * standP, height: 185 * standP)
        topicFrame = CGRect(x: bounds.midX - 75 * standP * 0.5, y: 130 * standHP, width: 75 * standP, height: 75 * standP)
        decoSize = CGSize(width: 153 * standP, height: 121 * standP)
        topRadius = 126 * standP
        topCenter = CGPoint(x: topicFrame.midX, y: topicFrame.midY)
        
        // cards
        cardsRadius = mainFrame.width * 0.5 - 30 * standP
        cardsCenter = CGPoint(x: bounds.midX, y: cardsRadius + 60 * standP)
    }

    // nodes
    fileprivate let modeSwitch = UISwitch()
    fileprivate var cardNodes = [(ratio: CGFloat, iden: String, cards: [SimpleNode])]()
    fileprivate var allCardNodes: [SimpleNode] {
        var nodes = [SimpleNode]()
        for (_,_,cards) in cardNodes {
            nodes.append(contentsOf: cards)
        }
        
        return nodes
    }

    // MARK: ----------- nodes creation and removing -------------
    fileprivate func setNode(_ node: SimpleNode, withState idenkey: String!) {
        node.isDisabled = true

        if idenkey != nil {
            node.isDisabled = false
            node.circleColor = MatchedCardsDisplayModel.getColorOfIden(idenkey)
        }
    }

    // risk class
    fileprivate func resetRiskClassNodes() {
        if chosenHelpIndex == nil {
            return
        }
        
        // clear all
        clearAllRiskClassNodes()

        // reset
        let groupedRiskClasses = LandingModel.getAllTierRiskClasses()

        // risks
        for (tier, metrics) in groupedRiskClasses {
            // different tier, different riskClasses
            if tier == chosenHelpIndex {
                for metric in metrics {
                    let node = ButterflyNode()
                    node.key = metric.key

                    if metric.imageUrl != nil {
                        node.imageUrl = metric.imageUrl
                    }

                    node.text = metric.name

                    riskClassNodes.append(node)
                    node.alpha = 0
                    node.frame = topicFrame
                    insertSubview(node, belowSubview: helpNodes[chosenHelpIndex])

                    // set up riskclass answer state
                    var state = MatchedCardsDisplayModel.checkPlayResultStateOfRiskClass(node.key)
                    if viewMode == .fromRiskType && chosenHelpIndex == 2 {
                        state = MatchedCardsDisplayModel.checkPlayResultStateOfRiskClass(node.key, riskTypeKey: chosenRiskTypeKey)
                    }
    
                    setNode(node, withState: state)
                    
                    if !node.isDisabled {
                        node.layer.addBlackShadow(3 * fontFactor)
                    }
                }
            }
        }
    }
    
    fileprivate func resetRiskType() {
        setRiskTypesTitle(true)
        // set topics' border
        for node in riskTypeNodes {
            var state: String!
            switch viewMode {
            case .fromRiskType: state = MatchedCardsDisplayModel.checkPlayResultStateOfRiskType(node.key)
            case .fromRiskClass: state = MatchedCardsDisplayModel.checkPlayResultStateOfRiskClass(chosenRiskClassKey,riskTypeKey: node.key)
            }
            
            setNode(node, withState: state)
        }
    }
    
    fileprivate func setRiskTypesTitle(_ onshow: Bool) {
        for riskType in riskTypeNodes {

        }
    }
    
    // cards, 1, 0.7, 0.4
    fileprivate func resetCardNodes() {
        clearAllCardNodes()
        chosenCardKey = nil
        
        // reset
        let allCards = MatchedCardsDisplayModel.getAllMatchedCardsOfRiskClass(chosenRiskClassKey, riskTypeKey: chosenRiskTypeKey)
        let sorted = MatchedCardsDisplayModel.getSortedClassifiedCards(allCards)
        
        var ratio: CGFloat = 1
        for (key, cards) in sorted {
            var nodes = [SimpleNode]()
            for card in cards {
                let node = SimpleNode()
                node.key = card.key
                node.borderShape = .square
                node.borderColor = UIColor.clear
                node.imageUrl = card.currentImageUrl()
                node.frame = topicFrame.insetBy(dx: 30 * standP, dy: 30 * standP)
                node.alpha = 0
                setNode(node, withState: card.currentIdentification())
                nodes.append(node)
                addSubview(node)
            }
            
            cardNodes.append((ratio, key, nodes))
            // array
            ratio -= (0.9 / CGFloat(sorted.count))
        }
    }

    // Hide and show
    // helpNodes
    fileprivate func hideHelpDecos() {
        for help in helpNodes {
            help.decoView.alpha = 0
            help.decoView.transform = CGAffineTransform.identity
            help.layer.shadowColor = UIColor.clear.cgColor
        }
    }
    fileprivate func showHelpDecos() {
        for help in helpNodes {
            help.layer.addBlackShadow(2 * fontFactor)
            help.decoView.alpha = 1
            help.decoView.transform = CGAffineTransform.identity
        }
    }
    
    // riskClasses
    fileprivate func clearAllRiskClassNodes() {
        for node in riskClassNodes {
            node.removeFromSuperview()
        }
        riskClassNodes.removeAll()
    }
    
    fileprivate func hideAllRiskTypes() {
        for node in riskTypeNodes {
            node.alpha = 0
            node.frame = topicFrame
        }
    }
    
    fileprivate func clearAllCardNodes() {
        for (_, _, nodes) in cardNodes {
            for node in nodes {
                node.removeFromSuperview()
            }
        }
        
        cardNodes.removeAll()
    }
    
    // MARK: ------------------- all kinds of state
    //  case showhelpNodes, showRiskTypes, showRiskClasses, showCards

    // draw rect switch
    fileprivate var drawBack = true
    fileprivate var duringTransform = false

    // MARK: --------------------- touches --------------------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if cardTimer != nil {
            cardTimer.invalidate()
            cardTimer = nil
        }
        
        let point = touches.first!.location(in: self)
        
        // touch avatar, show helpNodes
        if avatar.frame.contains(point) && avatar.alpha != 0 {
            modeSwitch.isHidden = true
            if mapState != .showHelps {
                showHelpNodes()
            }
            return
        }
        
        // touch help, show riskType(fromRiskType) or riskClass(fromRiskClass)
        for help in helpNodes {
            if help.frame.contains(point) && help.alpha != 0 {
                let tagIndex = help.tag - 100
                
                if tagIndex == 2 {
                    modeSwitch.isHidden = false
                }else {
                    modeSwitch.isHidden = true
                }
                
                if viewMode == .fromRiskClass || tagIndex != 2 {
                    // show risk class
                    if mapState != .showRiskClasses || chosenHelpIndex != tagIndex {
                        chosenHelpIndex = tagIndex
                        showRiskClasses()
                    }
                }else {
                    // show risk type
                    if mapState != .showRiskTypes || chosenHelpIndex != tagIndex {
                        chosenHelpIndex = tagIndex
                        showRiskTypes()
                    }
                }
              
                return
            }
        }
   
        // touch risk class, show risktype or cards
        for riskClass in riskClassNodes {
            if riskClass.frame.contains(point) && riskClass.alpha != 0 {
                modeSwitch.isHidden = true
                chosenRiskClassKey = riskClass.key
                
                if riskClass.isDisabled {
                    showAlert()
                }else {
                    if viewMode == .fromRiskClass && chosenHelpIndex == 2 {
                        showRiskTypes()
                    }else {
                        showCards()
                    }
                }
    
                return
            }
        }
        
        
        // touch risk type, show riskClass or cards
        for riskType in riskTypeNodes {
            if riskType.frame.contains(point) && riskType.alpha != 0 {
                modeSwitch.isHidden = true
                if riskType.isDisabled {
                    showAlert()
                }else {
                    chosenRiskTypeKey = riskType.key
                    if viewMode == .fromRiskClass {
                        showCards()
                    }else {
                        showRiskClasses()
                    }
                }
                return
            }
        }
        
        // tap cards
        for (_,_,cards) in cardNodes {
            autoPlay = false
            for card in cards {
                if card.frame.contains(point) && card.alpha != 0 {
                    if chosenCardKey == card.key {
                        let cardObj = collection.getCard(card.key)!
                        let cardChange = CardAnswerChangeViewController()
                        cardChange.forChange = false
                        cardChange.modalPresentationStyle = .overCurrentContext
                        cardChange.loadWithCard(cardObj)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6, execute: {
                            self.hostVC.present(cardChange, animated: true, completion: nil)
                        })
                        
                    }else {
                        layoutCardsWithChosenKey(card.key)
                    }
        
                    return
                }
            }
        }
    }
    
    fileprivate func layoutCardsWithChosenKey(_ key: String){
        chosenCardKey = key
        
        let expectedLength = 35 * self.standP
        UIView.animate(withDuration: 0.4, animations: {
            // old
            for info in self.cardNodes {
                ButterflyLayout.layoutEvenCircleWithRootCenter(self.cardsCenter, children: info.cards, radius: self.cardsRadius * info.ratio, startAngle: 0, expectedLength: expectedLength)
                for card in info.cards {
                    card.tagged = false
                }
            }
            
            // chosen
            for info in self.cardNodes {
                for (i, card) in info.cards.enumerated() {
                    if card.key == self.chosenCardKey {
                        ButterflyLayout.layoutEvenCircleWithRootCenter(self.cardsCenter, children: info.cards, radius: self.cardsRadius * info.ratio, startAngle: 0, expectedLength: expectedLength, enlargeIndex: i)
                        self.bringSubview(toFront: card)
                        card.tagged = true
                        break
                    }
                }
            }
        })
    }
    
    // exchange
    @objc func changeMode() {
        if viewMode == .fromRiskClass {
            viewMode = .fromRiskType
            showRiskTypes()
        }else {
            viewMode = .fromRiskClass
            showRiskClasses()
        }
    }
    
}

// MARK: -------------------------- draw and set up
extension ButterflyMapView {
    // MARK: ------------------- all kinds of state
    // some fixed location
    
    //  case overall, helpChosen, riskClassChosen, risk, cards
    func showHelpNodes() {
        mapState = .showHelps
        
        clearAllRiskClassNodes()
        hideAllRiskTypes()
        clearAllCardNodes()
        setNeedsDisplay()
        
        showHelpDecos()
        
        // view
        UIView.animate(withDuration: 0.3, animations: {
            self.avatar.transform = .identity
            // layout helpNodes
            ButterflyLayout.layoutEvenCircleWithRootCenter(self.avatar.center, children: self.helpNodes, radius: self.radius, startAngle: 30, expectedLength: 90 * self.standP)
            
            for (i, help) in self.helpNodes.enumerated() {
                if let deco = help.decoView {
                    let angle = (CGFloat(i) * 2 - 1) / 3 * CGFloat(Double.pi)
                    let r = -20 * self.standP
                    deco.center = CGPoint(x: help.center.x - r * sin(angle), y: help.center.y + r * cos(angle))
                    deco.transform = CGAffineTransform(rotationAngle: angle)
                }
            }
        }) { (true) in
 
        }
    }
    
    // help
    func showRiskClasses() {
        mapState = .showRiskClasses
        
        duringTransform = true
        setNeedsDisplay()
        
        // others
        hideHelpDecos()
        if viewMode != .fromRiskType || chosenHelpIndex != 2 {
            hideAllRiskTypes()
        }
        
        resetRiskClassNodes()
        clearAllCardNodes()
    
        // nodes arrangement
        let bottomY = mainFrame.height - 36 * standHP
        avatar.transform = CGAffineTransform(translationX: 0, y: bottomY - self.bounds.midY)
        avatar.transform = avatar.transform.scaledBy(x: 0.55, y: 0.55)

        // animation
        UIView.animate(withDuration: 0.4, animations: {
            self.layhelpNodesAtBottom(bottomY)
            
            if self.viewMode == .fromRiskType && self.chosenHelpIndex == 2 {
                let chosenHelp = self.helpNodes[self.chosenHelpIndex]
                chosenHelp.center = CGPoint(x: self.bounds.midX, y: bottomY - 80 * self.standP)
                
                for riskType in self.riskTypeNodes {
                    if riskType.key != self.chosenRiskTypeKey {
                        riskType.alpha = 0
                    }else {
                        riskType.frame = self.topicFrame
                    }
                }
            }
            
        }) { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                self.layRiskClassesAtTop()
            }){ (true) in
                self.duringTransform = false
                self.setNeedsDisplay()
            }
        }
    }
    
    // risk class
    func showRiskTypes()  {
        mapState = .showRiskTypes
        duringTransform = true
        setNeedsDisplay()
        
        hideHelpDecos()
        setRiskTypesTitle(true)
        resetRiskType()
        
        if viewMode != .fromRiskClass {
            clearAllRiskClassNodes()
        }

        clearAllCardNodes()

        let bottomY = mainFrame.height - 36 * standHP
        avatar.transform = CGAffineTransform(translationX: 0, y: bottomY - self.bounds.midY)
        avatar.transform = avatar.transform.scaledBy(x: 0.55, y: 0.55)

        // animation
        UIView.animate(withDuration: 0.4, animations: {
            self.layhelpNodesAtBottom(bottomY)

            // layout riskClasses
            if self.viewMode == .fromRiskClass {
                let chosenHelp = self.helpNodes[self.chosenHelpIndex]
                chosenHelp.center = CGPoint(x: self.bounds.midX, y: bottomY - 80 * self.standP)
                
                for riskClass in self.riskClassNodes {
                    if riskClass.key != self.chosenRiskClassKey {
                        riskClass.alpha = 0
                    }else {
                        riskClass.frame = self.topicFrame
                    }
                }
            }
            
        }) { (true) in
            self.duringTransform = false
            self.setNeedsDisplay()

            UIView.animate(withDuration: 0.4, animations: {
                self.layRiskTypesAtTop()
            })
        }
    }

    // show all cards
    func showCards() {
        mapState = .showCards
        resetCardNodes()
        
        duringTransform = true
        setNeedsDisplay()
        self.setRiskTypesTitle(false)
        
        avatar.transform = CGAffineTransform(translationX: 0, y: self.mainFrame.height * 0.6)
        avatar.transform = avatar.transform.scaledBy(x: 0.1, y: 0.1)
        let bottomFrame = CGRect(center: CGPoint(x: bounds.midX, y: mainFrame.height - 40 * standP), length: 70 * standP)

        // animation
        UIView.animate(withDuration: 0.4, animations: {
            // layout helpNodes
            for (i, help) in self.helpNodes.enumerated() {
                if self.chosenHelpIndex != i {
                    help.alpha = 0
                }else {
                    help.frame = bottomFrame
                }
            }
            
            let riskClassFrame = CGRect(origin: CGPoint(x: bottomFrame.origin.x, y: bottomFrame.origin.y - 75 * self.standP), size: bottomFrame.size)
            
            if self.viewMode == .fromRiskClass {
                // from riskClass
                // layout riskClasses
                for riskClass in self.riskClassNodes {
                    if riskClass.key != self.chosenRiskClassKey {
                        riskClass.alpha = 0
                    }else {
                        if self.chosenHelpIndex != 2 {
                            riskClass.frame = CGRect(center: self.cardsCenter, width: 70 * self.standP, height: 70 * self.standP)
                        }else {
                            riskClass.frame = riskClassFrame
                        }
                    }
                }
                
                // riskTypes
                if self.chosenHelpIndex != 2 {
                    for riskType in self.riskTypeNodes {
                        riskType.alpha = 0
                    }
                }else {
                    ButterflyLayout.layoutOvalGroupWithRootCenter(CGPoint(x: bottomFrame.midX, y: bottomFrame.minY), children: self.riskTypeNodes, childSize: CGSize(width: 55 * self.standP, height: 55 * self.standP), childAlpha: 0.75, ovalA: 130 * self.standP, ovalB: 100 * self.standP, startAngle: 180, totalAngle: 180, chosenIndex: self.chosenRiskTypeIndex, chosenSize: CGSize(width: 51 * self.standP, height: 50 * self.standP), chosenRadius: (bottomFrame.minY - self.cardsCenter.y), chosenAngle: 270)
                }

            }else {
                // from riskType
                for riskClass in self.riskClassNodes {
                    if riskClass.key != self.chosenRiskClassKey {
                        riskClass.alpha = 0
                    }else {
                        riskClass.frame = CGRect(center: self.cardsCenter, width: 70 * self.standP, height: 70 * self.standP)
                    }
                }
                
                // riskTypes
                if self.chosenHelpIndex == 2 {
                    for riskType in self.riskTypeNodes {
                        if riskType.key != self.chosenRiskTypeKey {
                            riskType.alpha = 0
                        }else {
                            riskType.frame = riskClassFrame
                        }
                    }
                }
            }
 
            // from riskType
        }) { (true) in
            self.duringTransform = false
            self.setNeedsDisplay()

            // lay cards
            self.autoPlayCards()
        }
    }
    
    fileprivate func autoPlayCards() {
        if allCardNodes.count == 0 {
            return
        }
        
        // layout
        var cardIndex = Int(arc4random() % UInt32(allCardNodes.count))
        layoutCardsWithChosenKey(allCardNodes[cardIndex].key!)
        
        // do after timeInterval
        cardTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { (timer) in
            let cardKey = self.allCardNodes[cardIndex].key!
            
            if self.chosenCardKey != cardKey {
                self.layoutCardsWithChosenKey(cardKey)
            }else {
                cardIndex += 1
                if cardIndex >= self.allCardNodes.count {
                    cardIndex = 0
                }
                
                timer.fireDate = Date.distantFuture
                let cardObj = collection.getCard(cardKey)!
                let cardChange = CardAnswerChangeViewController()
                cardChange.forChange = false
                cardChange.modalPresentationStyle = .overCurrentContext
                cardChange.loadWithCard(cardObj)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
                    if self.hostVC != nil {
                        self.hostVC.present(cardChange, animated: true, completion: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                                cardChange.dismiss(animated: true, completion: {
                                    timer.fireDate = Date()
                                })
                            })
                        })
                    }
                })
            }
        })
    }
    
    fileprivate func layhelpNodesAtBottom(_ bottomY: CGFloat) {
        ButterflyLayout.layoutOneGroupWithRootCenter(CGPoint(x: bounds.midX, y: bottomY), children: helpNodes, childSize: topicFrame.size, childAlpha: 0.6, radius: 120 * standP, startAngle: 200, totalAngle: 140, chosenIndex: chosenHelpIndex, chosenSize: topicFrame.size, chosenRadius: (bottomY - topCenter.y), chosenAngle: chosenAngle)
    }
    
    
    fileprivate func layRiskClassesAtTop() {
        ButterflyLayout.layoutEvenCircleWithRootCenter(topCenter, children: riskClassNodes, radius: topRadius, startAngle: 30, expectedLength: topicFrame.width)
    }
    
    fileprivate func layRiskTypesAtTop() {
        ButterflyLayout.layoutEvenOvalWithRootCenter(topCenter, children: riskTypeNodes, ovalA: topRadius, ovalB: topRadius * 0.8, startAngle: CGFloat(Double.pi) * 1.5, expectedSize: CGSize(width: 80 * standP,height: 80 * standP))
    }
    
    
    // draw lines and background images
    override func draw(_ rect: CGRect) {
        // do not draw
        if !drawBack {
            return
        }

        let lightGreen = UIColorFromRGB(193, green: 231, blue: 149)
        let middLineColor = UIColorFromRGB(0, green: 200, blue: 83)
        
        switch mapState {
        case .showHelps:
            let path = UIBezierPath(arcCenter: viewCenter, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            path.lineWidth = standP
            UIColor.white.setFill()
            lightGreen.setStroke()
            path.fill()
            path.stroke()
        case .showRiskTypes, .showRiskClasses:
            if !duringTransform {
                addConnection(centerOfView(avatar), nodes: helpNodes, alpha: 0.6)
            }
        case .showCards:
            if !duringTransform {
                addConnection(centerOfView(riskClassNodes[chosenRiskClassIndex]), nodes: riskTypeNodes, alpha: 0.6)
            }

            // line
            let path = UIBezierPath()
            path.move(to: centerOfView(helpNodes[chosenHelpIndex]))
            path.addLine(to: cardsCenter)
            path.lineWidth = 2 * standP
            middLineColor.setStroke()
            path.stroke()
            
            drawCardsPlate()
        }
        
        // back butterfly
        if mapState == .showRiskTypes || mapState == .showRiskClasses {
            let path = UIBezierPath()
            path.move(to: centerOfView(avatar))
            path.addLine(to: topCenter)
            path.lineWidth = 2 * standP
            middLineColor.setStroke()
            path.stroke()
            
            // butterfly
            let butterfly = ProjectImages.sharedImage.butterfly
            butterfly?.draw(in: topBackFrame)
        }
        
    }

    fileprivate func drawCardsPlate() {
        // plate, fill with shadow
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.saveGState()
        ctx?.setShadow(offset: CGSize.zero, blur: 15 * standP, color: UIColor.black.cgColor)
        
        for cardInfo in cardNodes {
            let path = UIBezierPath(arcCenter: cardsCenter, radius: cardsRadius * cardInfo.ratio, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            cardInfo.cards.first?.circleColor.setFill()
            path.fill()
        }
        
        // shadow of center
        if chosenHelpIndex == 2 && !duringTransform {
            let centerPath = UIBezierPath(arcCenter: cardsCenter, radius: 25 * standP, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            centerPath.fill()
        }

        ctx?.restoreGState()

        // rects
        let widthSpace = bounds.width / CGFloat(cardNodes.count)
        let labelAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 10 * standP, weight: UIFont.Weight.medium)]
        let numberAttributes = [NSAttributedStringKey.foregroundColor: UIColor.black, NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14 * standP, weight: UIFont.Weight.medium)]

//        var labelSize = CGSize(width: 60 * standP, height: 35 * standP)
        let maxSize = CGSize(width: widthSpace * 0.7, height: 35 * standP)
        var labelSize = CGSize(width: 45 * standP, height: 26 * standP)
        for detail in cardNodes {
            let text = MatchedCardsDisplayModel.getNameOfIden(detail.iden)
            let dString = NSAttributedString(string: text, attributes: labelAttributes)
            let expectedSize = dString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil)
            if expectedSize.width > labelSize.width {
                labelSize = CGSize(width: expectedSize.width, height: labelSize.width)
            }
            if expectedSize.height > labelSize.height {
                labelSize = CGSize(width: labelSize.width, height: expectedSize.height)
            }
        }
        
        
        for (i, detail) in cardNodes.enumerated() {
            let labelFrame = CGRect(x: 10 * standP + CGFloat(i) * widthSpace, y: 5 * standP , width: labelSize.width, height: labelSize.height)

            let labelPath = UIBezierPath(roundedRect: labelFrame, cornerRadius: 4 * standP)
            labelPath.lineWidth = 2 * standP
            detail.cards.first?.circleColor.setFill()
            labelPath.fill()
           
            let text = MatchedCardsDisplayModel.getNameOfIden(detail.iden)
            let dString = NSAttributedString(string: text, attributes: labelAttributes)
            drawString(dString, inRect: labelFrame)

            let nString = NSAttributedString(string: "\(detail.cards.count)", attributes: numberAttributes)
            drawString(nString, inRect: CGRect(x: labelFrame.maxX + 4 * standP, y: labelFrame.minY, width: 20 * standP, height: labelFrame.height), alignment: .left)
        }
        
    }

    fileprivate func centerOfView(_ view: UIView) -> CGPoint {
        return CGPoint(x: view.frame.midX, y: view.frame.midY)
    }

    fileprivate func drawButterfly() {
        let butterfly =  ProjectImages.sharedImage.butterfly
        butterfly?.draw(in: topBackFrame)
    }

    fileprivate func addConnection(_ center: CGPoint, nodes: [SimpleNode], alpha: CGFloat) {
        let path = UIBezierPath()
        for node in nodes {
            path.move(to: center)
            if node.alpha != 0 {
                path.addLine(to: centerOfView(node))
                path.lineWidth = node.lineWidth
                node.circleColor.withAlphaComponent(alpha).setStroke()
                path.stroke()
            }
        }
    }
}

