//
//  ButterflyMapView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/7.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

enum ButterflyMapState {
    case overall, topicChosen,helpChosen, riskClassChosen, riskTypeChosen
}

// risks are loaded before
class ButterflyMapView: UIView {
    weak var hostVC: UIViewController!
    
    var hostSize = CGSize.zero
    func reloadView()  {
        if mapState == .riskTypeChosen{
            
        }
    }
    
    // init
    fileprivate var mainFrame = CGRect.zero
    class func createWithFrame(_ frame: CGRect, ratio: CGFloat) -> ButterflyMapView {
        var bFrame = frame
        let ratio: CGFloat = 554 / 375
        if bFrame.height / bFrame.width < ratio {
            bFrame = CGRect(center: CGPoint(x: frame.midX, y: frame.midY), width: bFrame.height / ratio, height: bFrame.height)
        }
        
        let view = ButterflyMapView(frame: frame)
        view.mainFrame = bFrame
        view.setupSeeForUI()
        
        return view
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
    
    fileprivate func setFramesData()  {
        standWP =  mainFrame.width / 375
        standHP = mainFrame.height / 554
        standP = min(standWP, standHP)
        
        viewCenter = CGPoint(x: bounds.midX, y: bounds.midY)
        radius = 268 * standP * 0.5
        topBackFrame = CGRect(x: bounds.midX - 235 * standP * 0.5, y: 65 * standHP, width: 235 * standP, height: 185 * standP)
        topicFrame = CGRect(x: bounds.midX - 75 * standP * 0.5, y: 130 * standHP, width: 75 * standP, height: 75 * standP)
        decoSize = CGSize(width: 138 * standP, height: 109 * standP)
        topRadius = 126 * standP
        topCenter = CGPoint(x: topicFrame.midX, y: topicFrame.midY)
        
        // cards
        cardsRadius = mainFrame.width * 0.5 - 30 * standP
        cardsCenter = CGPoint(x: bounds.midX, y: cardsRadius + 40 * standP)
    }
    
    // data
    var mapState = ButterflyMapState.overall

    // nodes
    fileprivate let avatar = UIImageView()            // set in init func, should change to the real avatar
    fileprivate var helps = [ButterflyNode]()         // tag: 100 + i, set in init func
    fileprivate var topics = [ButterflyNode]()        // tag: 200 + i, set in init func
    // risk classes
    fileprivate var riskClassNodes = [ButterflyNode]()  // use key, varies with chosenTopic
    fileprivate var riskTypeNodes = [ButterflyNode]()      // riskType.key, set in init func
//    var riskNodes = [ButterflyNode]()
    fileprivate var cardNodes = [(ratio: CGFloat, nodes: [ButterflyNode])]()
    
    // dynamic nodes'setup, alpha 0
    fileprivate let lowColor = UIColorFromRGB(57, green: 184, blue: 74)
    fileprivate let lowFColor = UIColorFromRGB(78, green: 208, blue: 132)
    fileprivate let mediumColor = UIColorFromRGB(253, green: 213, blue: 5)
    fileprivate let mediumFColor = UIColorFromRGB(255, green: 240, blue: 69)
    fileprivate let highColor = UIColorFromRGB(208, green: 2, blue: 27)
    fileprivate let highFColor = UIColorFromRGB(239, green: 83, blue: 80)

    fileprivate func setNode(_ node: ButterflyNode, withState state: PlayResultState) {
        switch state {
        case .none: node.isDisabled = true
        case .low: node.circleColor = lowColor
        case .high: node.circleColor = highColor
        case .medium: node.circleColor = mediumColor
        }
    }
    
    // help nodes
    fileprivate func resetHelpNodes() {
        for help in helps {
            help.removeFromSuperview()
            help.decoView.removeFromSuperview()
        }
        
        helps.removeAll()
        
        // tier 1, 2, 3
        let helpTexts = chosenTopicIndex == 0 ? ["Help You Care", "Help You Understand", "Help You Act"] : []
        for (i, text) in helpTexts.enumerated() {
            let help = ButterflyNode()
            help.text = text
            help.frame = topicFrame
            help.tag = 100 + i
            let deco = UIImageView(image: ProjectImages.sharedImage.butterfly)
            help.decoView = deco
            deco.transform = CGAffineTransform.identity
            deco.frame = CGRect(center: topCenter, width: self.decoSize.width, height: self.decoSize.height)
            
            insertSubview(help, belowSubview: topics[chosenTopicIndex])
            insertSubview(deco, belowSubview: help)
          
            helps.append(help)
        }
    }
    
    
    // risk class
    fileprivate func resetRiskClassNodes() {
        // clear all
        clearAllRiskClassNodes()
        
        // reset
        var groupedRiskClasses = [MetricGroupObjModel: [MetricObjModel]]()
        if chosenTopicIndex != nil {
            //  slowAging, pet, protect, workLogo
            switch chosenTopicIndex {
            case 0: groupedRiskClasses = AIDMetricCardsCollection.standardCollection.getAllGroupedRiskClasses()
            case 1: groupedRiskClasses = AIDMetricCardsCollection.standardCollection.getAllPetGroupedRiskClasses()
            case 2: break
            case 4: break
            default: break
            }
        }
        
        // risks
        if chosenTopicIndex != nil {
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
                        node.frame = topicFrame
                        insertSubview(node, belowSubview: topics[chosenHelpIndex])
                        
                        // set up riskclass answer state
                        let state = MatchedCardsDisplayModel.checkPlayResultStateOfRiskClass(node.key, forUser: UserCenter.sharedCenter.currentGameTargetUser.Key())
                        setNode(node, withState: state)
                    }
                }
            }
        }
    }
    
    fileprivate func resetRiskType() {
        // set topics' border
        for node in riskTypeNodes {
            let state = MatchedCardsDisplayModel.checkPlayResultStateOfRiskClass(chosenRiskClassKey,riskTypeKey: node.key, forUser: UserCenter.sharedCenter.currentGameTargetUser.Key())
            setNode(node, withState: state)
        }
    }
    
    fileprivate func setRiskTypesTitle(_ onshow: Bool) {
        for riskType in riskTypeNodes {
            let name = AIDMetricCardsCollection.standardCollection.getRiskTypeByKey(riskType.key)!.name ?? "iRa"
            
            let index = name.index(name.startIndex, offsetBy: 3)
            let typeName = name.substring(to: index)
            riskType.text = onshow ? name : typeName
            riskType.boldFont = !onshow
        }
    }
    
    // risks
    fileprivate func resetRiskNodes() {
        // only one risk type for tier one & two
        
    }
    
    // cards, 1, 0.7, 0.4
    fileprivate func resetCardNodes() {
        clearAllCardNodes()
        let cards = MatchedCardsDisplayModel.getAllMatchedCardsOfRiskClass(chosenRiskClassKey, riskTypeKey: chosenRiskTypeKey, forUser: UserCenter.sharedCenter.currentGameTargetUser.Key())
        cardNodes = [(1, []),(0.7, []),(0.4, [])]
        for card in cards {
            let node = ButterflyNode()
            node.borderColor = UIColor.clear
            node.imageUrl = MatchedCardsDisplayModel.getMatchedImageUrlForCard(card)
            node.frame = topicFrame.insetBy(dx: 30 * standP, dy: 30 * standP)
            node.alpha = 0
            let state = MatchedCardsDisplayModel.checkPlayResultStateOfCard(card)
            setNode(node, withState: state)
            
            switch state {
            case .none: break
            case .high: cardNodes[2].nodes.append(node)
            case .medium: cardNodes[1].nodes.append(node)
            case .low: cardNodes[0].nodes.append(node)
            }
            
            addSubview(node)
        }
        
        // adjust ratio
//        var noCardIndex = [Int]()
//        for (i, cardInfo) in cardNodes.enumerated() {
//            if cardInfo.nodes.count == 0 {
//                noCardIndex.append(i)
//            }
//        }
//
//        for i in noCardIndex {
//            cardNodes[i].ratio = 0
//        }
    }

    // hide
    fileprivate func hideAllHelps() {
        for help in helps {
            help.decoView.alpha = 0
            help.alpha = 0
        }
    }
    
    fileprivate func hideHelpDecos() {
        for help in helps {
            help.decoView.alpha = 0
            help.decoView.transform = CGAffineTransform.identity
        }
    }
    
    fileprivate func hideTopicDecos() {
        for topic in topics {
            topic.decoView.alpha = 0
            topic.decoView.transform = CGAffineTransform.identity
        }
    }
    
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
        for (_, nodes) in cardNodes {
            for node in nodes {
                node.removeFromSuperview()
            }
        }
        
        cardNodes.removeAll()
    }
    
    // only add some fixed data -- till topics
   fileprivate func setupSeeForUI() {
        backgroundColor = UIColor.clear
        setFramesData()
        
        // avatar : 104 * 117
        var isMale = true
        if let gender = UserCenter.sharedCenter.currentGameTargetUser.userInfo().sex {
            if gender.localizedCaseInsensitiveContains("female") {
                isMale = false
            }
        }
        
        avatar.image = isMale ? ProjectImages.sharedImage.maleAvatar : ProjectImages.sharedImage.femaleAvatar
        avatar.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY - standP * 6.5), width: 100 * standP, height: 114 * standP)
       
        // riskTypes
        let riskTypes = AIDMetricCardsCollection.standardCollection.getAllRiskTypes()
        for riskType in riskTypes {
            let node = ButterflyNode()
            node.key = riskType.key
            // colors are dynamic
            riskTypeNodes.append(node)
            addSubview(node)
        }

        // topics
        let topicImages = [ProjectImages.sharedImage.slowLogo, ProjectImages.sharedImage.workLogo, ProjectImages.sharedImage.proLogo, ProjectImages.sharedImage.petLogo]
        let topicColors = [ UIColorFromRGB(126, green: 211, blue: 33), UIColorFromRGB(204, green: 161, blue: 117), UIColorFromRGB(0, green: 176, blue: 255), UIColorFromRGB(252, green: 209, blue: 52)]
        for (i, topicImage) in topicImages.enumerated() {
            let node = ButterflyNode()
            node.hasCircle = false
            node.image = topicImage
            node.frame = CGRect(center: avatar.center, length: 75 * standP) //ghoi
            node.circleColor = topicColors[i]
            let deco = UIImageView(image: ProjectImages.sharedImage.butterfly)
            node.decoView = deco
            topics.append(node)
            
            addSubview(deco)
            addSubview(node)
            node.tag = 200 + i
        }
        
        addSubview(avatar)
        setToOverallState()
    
        // add labels
    
    }
    
    // MARK: ------------------- all kinds of state
    //  case overall, topicChosen, helpChosen,  riskClassChosen, risk, cards
    var chosenTopicIndex: Int! {
        didSet{
//            if chosenTopicIndex != oldValue {
                resetHelpNodes()
//            }
        }
    }
    var chosenHelpIndex: Int! {
        didSet{
//            if chosenHelpIndex != oldValue {
                resetRiskClassNodes()
//            }
        }
    }
    
    var chosenRiskClassKey: String! {
        didSet{
//            if chosenRiskClassKey != oldValue {
                resetRiskType()
//            }
        }
    }
    var chosenRiskClassIndex: Int!{ // for layout's benifit
        if chosenRiskClassKey != nil {
            for (i, node) in riskClassNodes.enumerated() {
                if chosenRiskClassKey == node.key {
                    return i
                }
            }
        }
        return nil
    }
    
    var chosenRiskTypeKey: String! {
        didSet{
//            if chosenRiskTypeKey != oldValue {
                resetCardNodes()
//            }
        }
    }
    var chosenRiskTypeIndex: Int! { // for layout's benifit
        if chosenRiskTypeKey != nil {
            for (i, node) in riskTypeNodes.enumerated() {
                if chosenRiskTypeKey == node.key {
                    return i
                }
            }
        }
        return nil
    }
    
    // draw rect switch
    fileprivate var drawBack = true
    fileprivate var duringTransform = false

    // MARK: --------------------- touches --------------------------------
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        
        // touch avatar
        if avatar.frame.contains(point) && avatar.alpha != 0 {
            if mapState != .overall {
                setToOverallState()
            }
            return
        }
        
        // touch butterfly
        for help in helps {
            if help.frame.contains(point) && help.alpha != 0 {
                let tagIndex = help.tag - 100
                if mapState != .helpChosen || chosenHelpIndex != tagIndex {
                    chosenHelpIndex = tagIndex
                    setToHelpChosenState()
                }

                return
            }
        }
        
        // touch topic
        for topic in topics {
            if topic.frame.contains(point) && topic.alpha != 0 {
                let tagIndex = topic.tag - 200
                if mapState != .topicChosen || chosenTopicIndex != tagIndex {
                    chosenTopicIndex = tagIndex
                    setToTopicChosenState()
                }
                return
            }
        }
        
        // touch risk class
        for riskClass in riskClassNodes {
            if riskClass.frame.contains(point) && riskClass.alpha != 0 {
                if riskClass.isDisabled {
                    showAlert()
                }else if mapState != .riskClassChosen || chosenRiskClassKey != riskClass.key {
                    chosenRiskClassKey = riskClass.key
                    
                    // tier 1 and 2
                    if chosenHelpIndex != 2 {
                        chosenRiskTypeKey = riskTypeDefaultKey
                        setToRiskTypeChosenState()
                    }else {
                        setToRiskClassChosenState()
                    }
                    
                    
                }
                return
            }
        }
        
        // risk type
        for riskType in riskTypeNodes {
            if riskType.frame.contains(point) && riskType.alpha != 0 {
                if riskType.isDisabled {
                    showAlert()
                }else if mapState != .riskTypeChosen || chosenRiskTypeKey != riskType.key {
                    chosenRiskTypeKey = riskType.key
                    setToRiskTypeChosenState()
                }
                return
            }
        }
    }
}

// MARK: -------------------------- draw and set up
extension ButterflyMapView {
    // MARK: ------------------- all kinds of state
    // some fixed location
    
    //  case overall, topicChosen, helpChosen, riskClassChosen, risk, cards
    func setToOverallState() {
        mapState = .overall
        
        hideAllHelps()
        clearAllRiskClassNodes()
        hideAllRiskTypes()
        clearAllCardNodes()
        setNeedsDisplay()
        
        avatar.transform = .identity
        for topic in self.topics {
            if let deco = topic.decoView {
                deco.alpha = 1
                deco.transform = CGAffineTransform.identity
                deco.frame = CGRect(center: topic.center, width: self.decoSize.width, height: self.decoSize.height)
            }
        }
        UIView.animate(withDuration: 0.3, animations: {
            ButterflyLayout.layoutEvenCircleWithRootCenter(self.avatar.center, children: self.topics, radius: self.radius, startAngle: 270, expectedLength: 75 * self.standP)
            
            // deco
            for (i, topic) in self.topics.enumerated() {
                if let deco = topic.decoView {
                    let angle = (CGFloat(i) / 2 - 1) * CGFloat(Double.pi)
                    let r = -12 * self.standP
                    deco.center = CGPoint(x: topic.center.x - r * sin(angle), y: topic.center.y + r * cos(angle))
                    deco.transform = CGAffineTransform(rotationAngle: angle)
                }
            }
        }) { (true) in
//            UIView.animate(withDuration: 0.2, animations: {
//
//            })
        }
    }
    
    // topic
    func setToTopicChosenState() {
        mapState = .topicChosen
        
        hideTopicDecos()
        
        clearAllRiskClassNodes()
        hideAllRiskTypes()
        clearAllCardNodes()
        
        drawBack = false
        setNeedsDisplay()
        
        let bottomY = mainFrame.height - 136 * standHP
        avatar.transform = CGAffineTransform(translationX: 0, y: bottomY - self.bounds.midY)
        let topicRootCenter = CGPoint(x: bounds.midX, y: mainFrame.height - 170 * standHP)
        
        UIView.animate(withDuration: 0.4, animations: {
            // layout topics
            ButterflyLayout.layoutOneGroupWithRootCenter(topicRootCenter, children: self.topics, childSize: CGSize(width: 55 * self.standP, height: 55 * self.standP), childAlpha: 0.6, radius: 118 * self.standP, startAngle: 0, totalAngle: 270, chosenIndex: self.chosenTopicIndex, chosenSize: self.topicFrame.size, chosenRadius: topicRootCenter.y - self.topCenter.y, chosenAngle: self.chosenAngle)
            
            // layout helps
            ButterflyLayout.layoutEvenCircleWithRootCenter(self.topCenter, children: self.helps, radius: self.topRadius - 10 * self.standP, startAngle: 30, expectedLength: 90 * self.standP)
            
            for (i, help) in self.helps.enumerated() {
                if let deco = help.decoView {
                    deco.alpha = 1
                    let angle = (CGFloat(i) * 2 - 1) / 3 * CGFloat(Double.pi)
                    let r = -15 * self.standP
                    deco.center = CGPoint(x: help.center.x - r * sin(angle), y: help.center.y + r * cos(angle))
                    deco.transform = CGAffineTransform(rotationAngle: angle)
                }
            }
            
        }) { (true) in
            self.drawBack = true
            self.setNeedsDisplay()
          
            // butterflies
//            UIView.animate(withDuration: 0.4, animations: {
//
//            })
        }
    }
    
    
    // help
    func setToHelpChosenState() {
        mapState = .helpChosen
        
        hideHelpDecos()
        
        duringTransform = true
        setNeedsDisplay()
        
        hideAllRiskTypes()
        clearAllCardNodes()
        
        let bottomY = mainFrame.height - 30 * standHP
        avatar.transform = CGAffineTransform(translationX: 0, y: bottomY - self.bounds.midY)
        avatar.transform = avatar.transform.scaledBy(x: 0.45, y: 0.45)
        
        let chosenTopic = topics[chosenTopicIndex]
        
        // animation
        UIView.animate(withDuration: 0.4, animations: {
            ButterflyLayout.layoutOneGroupWithRootCenter(CGPoint(x: self.bounds.midX, y: bottomY), children: self.topics, childSize: CGSize(width: 55 * self.standP, height: 55 * self.standP), childAlpha: 0.6, radius: 120 * self.standP, startAngle: 200, totalAngle: 160, chosenIndex: self.chosenTopicIndex, chosenSize: self.topicFrame.size, chosenRadius: self.standP * 96, chosenAngle: self.chosenAngle)
            
            ButterflyLayout.layoutOneGroupWithRootCenter(chosenTopic.center, children: self.helps, childSize: CGSize(width: 70 * self.standP, height: 70 * self.standP), childAlpha: 0.6, radius: 126 * self.standP, startAngle: 210, totalAngle: 120, chosenIndex: self.chosenHelpIndex, chosenSize: self.topicFrame.size, chosenRadius: chosenTopic.center.y - self.topCenter.y, chosenAngle: self.chosenAngle)
            
        }) { (true) in
            UIView.animate(withDuration: 0.2, animations: {
                // layout topics
                ButterflyLayout.layoutEvenCircleWithRootCenter(self.topCenter, children: self.riskClassNodes, radius: self.topRadius, startAngle: 30, expectedLength: self.topicFrame.width)
            }){ (true) in
                self.duringTransform = false
                self.setNeedsDisplay()
            }
        }
    }
    
    // risk class
    func setToRiskClassChosenState()  {
        mapState = .riskClassChosen
        
        hideAllRiskTypes()
        clearAllCardNodes()
        
        duringTransform = true
        setNeedsDisplay()
        
        let bottomY = mainFrame.height - 35 * standHP
        avatar.transform = CGAffineTransform(translationX: 0, y: bottomY - self.bounds.midY)
        avatar.transform = avatar.transform.scaledBy(x: 0.45, y: 0.45)
        
        let topic = topics[chosenTopicIndex]
        // animation
        UIView.animate(withDuration: 0.4, animations: {
            // layout topics
            ButterflyLayout.layoutOneGroupWithRootCenter(CGPoint(x: self.bounds.midX, y: bottomY), children: self.topics, childSize: CGSize(width: 55 * self.standP, height: 55 * self.standP), childAlpha: 0.6, radius: 100 * self.standP, startAngle: 200, totalAngle: 160, chosenIndex: self.chosenTopicIndex, chosenSize: self.topicFrame.size, chosenRadius: self.standP * 96, chosenAngle: self.chosenAngle)
       
            // layout helps
            ButterflyLayout.layoutOneGroupWithRootCenter(topic.center, children: self.helps, childSize: CGSize(width: 70 * self.standP, height: 70 * self.standP), childAlpha: 0.6, radius: 122 * self.standP, startAngle: 210, totalAngle: 120, chosenIndex: self.chosenHelpIndex, chosenSize: self.topicFrame.size, chosenRadius: topic.center.y - self.topCenter.y - self.topRadius * 1.1, chosenAngle: self.chosenAngle)
            
            // layout riskClasses
            for riskClass in self.riskClassNodes {
                if riskClass.key != self.chosenRiskClassKey {
                    riskClass.alpha = 0
                }else {
                    riskClass.frame = self.topicFrame
                }
            }
        }) { (true) in
            self.duringTransform = false
            self.setNeedsDisplay()
            self.setRiskTypesTitle(true)
            UIView.animate(withDuration: 0.4, animations: {
                ButterflyLayout.layoutEvenCircleWithRootCenter(self.topCenter, children: self.riskTypeNodes, radius: self.topRadius * 0.8, startAngle: 270, expectedLength: 80 * self.standP)
            })
        }
    }
    
    // show all cards
    func setToRiskTypeChosenState() {
        mapState = .riskTypeChosen
     
        duringTransform = true
        setNeedsDisplay()
        self.setRiskTypesTitle(false)
        
        avatar.transform = CGAffineTransform(translationX: 0, y: self.mainFrame.height * 0.6)
        avatar.transform = avatar.transform.scaledBy(x: 0.1, y: 0.1)
        let bottomFrame = CGRect(center: CGPoint(x: bounds.midX, y: mainFrame.height - 40 * standP), length: 70 * standP)
        
        // animation
        UIView.animate(withDuration: 0.4, animations: {
            // hide all topics
            for topic in self.topics {
                topic.alpha = 0
                topic.frame = self.avatar.frame
            }
            
            // layout helps
            for (i, help) in self.helps.enumerated() {
                if self.chosenHelpIndex != i {
                    help.alpha = 0
                }else {
                    help.frame = bottomFrame
                }
            }
    
            // layout riskClasses
            let riskClassFrame = CGRect(origin: CGPoint(x: bottomFrame.origin.x, y: bottomFrame.origin.y - 75 * self.standP), size: bottomFrame.size)
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
                ButterflyLayout.layoutOvalGroupWithRootCenter(CGPoint(x: bottomFrame.midX, y: bottomFrame.minY), children: self.riskTypeNodes, childSize: CGSize(width: 55 * self.standP, height: 55 * self.standP), childAlpha: 0.75, ovalA: 130 * self.standP, ovalB: 100 * self.standP, startAngle: 180, totalAngle: 180, chosenIndex: self.chosenRiskTypeIndex, chosenSize: CGSize(width: 51 * self.standP, height: 51 * self.standP), chosenRadius: (bottomFrame.minY - self.cardsCenter.y), chosenAngle: 270)
            }
     
        }) { (true) in
            self.duringTransform = false
            self.setNeedsDisplay()
  
            // lay cards
            UIView.animate(withDuration: 0.4, animations: {
                for (ratio, nodes) in self.cardNodes {
                    ButterflyLayout.layoutCircleWithRootCenter(self.cardsCenter, children: nodes, radius: self.cardsRadius * ratio, startAngle: 0, expectedLength: 35 * self.standP)
                }
            })
        }
        
    }

    func showAlert()  {
        let alert = UIAlertController(title: "No Record For This Node", message: "you can go to play related cards or check other nodes", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        hostVC.present(alert, animated: true, completion: nil)
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
        case .overall:
            let path = UIBezierPath(arcCenter: viewCenter, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            path.lineWidth = standP
            UIColor.white.setFill()
            lightGreen.setStroke()
            path.fill()
            path.stroke()
        case .topicChosen:
            addConnection(centerOfView(avatar), nodes: topics, alpha: 0.6)
        case .helpChosen, .riskClassChosen:
            if !duringTransform {
                addConnection(centerOfView(avatar), nodes: topics, alpha: 0.6)
                addConnection(centerOfView(topics[chosenTopicIndex]), nodes: helps, alpha: 0.6)
            }
        case .riskTypeChosen:
            if !duringTransform {
                addConnection(centerOfView(riskClassNodes[chosenRiskClassIndex]), nodes: riskTypeNodes, alpha: 0.6)
            }

            // line
            let path = UIBezierPath()
            path.move(to: centerOfView(helps[chosenHelpIndex]))
            path.addLine(to: cardsCenter)
            path.lineWidth = 2 * standP
            middLineColor.setStroke()
            path.stroke()
            
            // three layers
            // green
            let lowPath = UIBezierPath(arcCenter: cardsCenter, radius: cardsRadius * cardNodes[0].ratio, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            lowPath.lineWidth = 3 * standP
            
            // medium & high
            let mediumPath = UIBezierPath(arcCenter: cardsCenter, radius: cardsRadius * cardNodes[1].ratio, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            mediumPath.lineWidth = 3 * standP
            let highPath = UIBezierPath(arcCenter: cardsCenter, radius: cardsRadius * cardNodes[2].ratio, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            highPath.lineWidth = 3 * standP
            
            // fill with shadow
            let ctx = UIGraphicsGetCurrentContext()
            ctx?.saveGState()
            ctx?.setShadow(offset: CGSize.zero, blur: 15 * standP, color: UIColor.black.cgColor)
            
            // center shadow
            lowFColor.setFill()
            lowPath.fill()
            
            mediumFColor.setFill()
            mediumPath.fill()
            
            highFColor.setFill()
            highPath.fill()
            // shadow of center
            if chosenHelpIndex == 2 && !duringTransform {
                let centerPath = UIBezierPath(arcCenter: cardsCenter, radius: 25 * standP, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
                centerPath.fill()
            }
            
            ctx?.restoreGState()
            
            // stroke
            mediumColor.setStroke()
            mediumPath.stroke()
            highColor.setStroke()
            highPath.stroke()
            lowColor.setStroke()
            lowPath.stroke()
            
            // rects
            let labelTexts = ["High", "Medium", "Low"]
            let fillColors = [UIColorFromRGB(255, green: 27, blue: 67), mediumFColor, lowFColor]
            let strokeColors = [highColor, mediumColor, lowColor]
        
            let labelSize = CGSize(width: 50 * standP, height: 20 * standP)
            let labelAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 10 * standP, weight: UIFontWeightMedium)]
            let numberAttributes = [NSForegroundColorAttributeName: UIColor.black, NSFontAttributeName: UIFont.systemFont(ofSize: 16 * standP, weight: UIFontWeightMedium)]
        
            for (i, text) in labelTexts.enumerated() {
                let labelFrame = CGRect(x: 10 * standP, y: 5 * standP + CGFloat(i) * (labelSize.height + 5 * standP), width: labelSize.width, height: labelSize.height)
                
                let labelPath = UIBezierPath(roundedRect: labelFrame, cornerRadius: 4 * standP)
                labelPath.lineWidth = 2 * standP
                fillColors[i].setFill()
                strokeColors[i].setStroke()
                labelPath.fill()
                labelPath.stroke()
                
                let dString = NSAttributedString(string: text, attributes: labelAttributes)
                drawString(dString, inRect: labelFrame)
                
                let nString = NSAttributedString(string: "\(cardNodes[2 - i].nodes.count)", attributes: numberAttributes)
                drawString(nString, inRect: CGRect(x: labelFrame.maxX + 4 * standP, y: labelFrame.minY, width: 20 * standP, height: labelFrame.height))
            }

        }
        
        // back butterfly
        if mapState != .overall && mapState != .riskTypeChosen {
            let path = UIBezierPath()
            path.move(to: centerOfView(avatar))
            path.addLine(to: topCenter)
            path.lineWidth = 2 * standP
            middLineColor.setStroke()
            path.stroke()
            
            if mapState != .topicChosen && mapState != .riskTypeChosen {
                // butterfly
                let butterfly = ProjectImages.sharedImage.butterfly
                butterfly?.draw(in: topBackFrame)
            }
           
        }
    }

    fileprivate func centerOfView(_ view: UIView) -> CGPoint {
        return CGPoint(x: view.frame.midX, y: view.frame.midY)
    }

    fileprivate func drawButterfly() {
        let butterfly =  ProjectImages.sharedImage.butterfly
        butterfly?.draw(in: topBackFrame)
    }

    fileprivate func addConnection(_ center: CGPoint, nodes: [ButterflyNode], alpha: CGFloat) {
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

extension UIView {
    func drawString(_ aString: NSAttributedString, inRect rect: CGRect) {
        let sSize = aString.boundingRect(with: rect.size, options: .usesLineFragmentOrigin, context: nil)
        let cRect = CGRect(center: CGPoint(x: rect.midX, y: rect.midY), width: sSize.width, height: sSize.height)
        aString.draw(in: cRect)
    }
}
