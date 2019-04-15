//
//  MatchedCardsMapView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/23.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation
enum ButterflyMapState {
    case showHelps, showRiskTypes, showRiskClasses, showCards
}

class MatchedCardsMapView: UIView {
    weak var hostVC: UIViewController!
    
    let avatar = UIImageView(image: ProjectImages.sharedImage.tempAvatar)
    var helpNodes = [SimpleNode]()            // tag: 100 + i
    var riskTypeNodes = [ButterflyNode]()      // riskType.key
    var allRiksTypeNodes = [CustomButton]()
    var riskClassNodes = [ButterflyNode]()    // riskClass.key
    
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
        dotView.center = Calculation.getPositionByAngle(CGFloat(Double.pi) * 7 / 6, radius: radius, origin: viewCenter)
        dotView.layer.cornerRadius = standP * 4
        dotView.isHidden = true
        addSubview(dotView)
        
        // avatar
        avatar.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), width: 90 * standP, height: 90 * standP)
        avatar.contentMode = .scaleAspectFit
        avatar.image = userCenter.currentGameTargetUser.userInfo().imageObj ?? ProjectImages.sharedImage.tempAvatar
        addSubview(avatar)
        
        // helps
        // tier 1, 2, 3
        createHelpNodes(CGRect(center: viewCenter, length: helpLength))
    
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
        
        let iCaKey = GameTintApplication.sharedTint.iCaKey
        let iPaKey = GameTintApplication.sharedTint.iPaKey
        
        // tier 1, and 2
        let landing = LandingModel()
        landing.reloadLandingData()

        // tierOne
        for (_, classes) in landing.tierOne {
            for riskClass in classes {
                var allCards = [CardInfoObjModel]()
                let cards = MatchedCardsDisplayModel.getAllMatchedCardsOfRiskClass(riskClass.key, riskTypeKey: iCaKey)
                
                for card in cards {
                    if !allCards.contains(card) {
                        allCards.append(card)
                    }
                }
                
                if allCards.count != 0 {
                    matched[riskClass.key] = allCards
                }
            }
        }
        
        // tier 2
        for (_, classes) in landing.tierTwo {
            for riskClass in classes {
                var allCards = [CardInfoObjModel]()
                let cards = MatchedCardsDisplayModel.getAllMatchedCardsOfRiskClass(riskClass.key, riskTypeKey: iPaKey)
                for card in cards {
                    if !allCards.contains(card) {
                        allCards.append(card)
                    }
                }
                
                if allCards.count != 0 {
                    matched[riskClass.key] = allCards
                }
            }
        }
       
        // tier 3
        for riskType in collection.getAllRiskTypes() {
            if riskType.key == iCaKey || riskType.key == iPaKey {
                continue
            }
            let userKey = userCenter.currentGameTargetUser.Key()
            let allCards = MatchedCardsDisplayModel.getAllMatchedScoreCardsOfRiskType(riskType.key, forUser: userKey)
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
                riskType.circleColor = collection.getRiskTypeByKey(riskType.key)?.realColor ?? tabTintGreen
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
            let typeName = String(name[0..<3])
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
                self.dotView.center = Calculation.getPositionByAngle(angle, radius: self.radius, origin: self.viewCenter)
                angle += 0.018
                
                if angle > 2 * CGFloat(Double.pi) {
                    angle -= 2 * CGFloat(Double.pi)
                }
            })
        })
    }
    
    func stopDotTimer() {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
    
    func endCardDisplay() {
        if cardsDisplayView != nil {
            if cardsDisplayView.cardsCollectionView != nil {
                cardsDisplayView.cardsCollectionView.endCurrentCard()
            }
        }
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
            self.avatar.transform = CGAffineTransform(translationX: 0, y: self.bounds.height * 0.45)
            self.avatar.transform = self.avatar.transform.scaledBy(x: 0.45, y: 0.45)
            
            // risk types
            let ovalB = self.avatarCenter.y - self.cardsDisplayView.frame.maxY
            let startAngle: CGFloat = arrange.count > 4 ? 180 : 200
            ButterflyLayout.layoutOvalGroupWithRootCenter(self.avatarCenter, children: arrange, childSize: CGSize(width: 45 * self.standP, height: 45 * self.standP), childAlpha: 1, ovalA: self.bounds.midX - 65 * self.standP, ovalB: ovalB - 70 * self.standP, startAngle: startAngle, totalAngle: 3 * 180 - 2 * startAngle, chosenIndex: index, chosenSize: CGSize(width: 50 * self.standP, height: 50 * self.standP), chosenRadius: ovalB - 30 * self.standP, chosenAngle: 270)
        }) { (true) in
            self.updateCardsView()
            self.draw = true
            self.setNeedsDisplay()
        }
    }
    
    fileprivate func updateCardsView() {
        let iCaKey = GameTintApplication.sharedTint.iCaKey
        let iPaKey = GameTintApplication.sharedTint.iPaKey
        
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
                stopDotTimer()
                dotView.isHidden = true
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
                        chosenRiskTypeKey = (chosenHelpIndex == 0 ? GameTintApplication.sharedTint.iCaKey : GameTintApplication.sharedTint.iPaKey)
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
        let decoImage = UIImage(named: "butterfly_circle")
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
    
    // colors for cardNodes
    var chosenHelpIndex: Int! {
        didSet{
            if chosenHelpIndex == 0 {
                // tier 1
                chosenRiskTypeKey = GameTintApplication.sharedTint.iCaKey
            }else if chosenHelpIndex == 1 {
                // tier 2
                chosenRiskTypeKey = GameTintApplication.sharedTint.iPaKey
            }
        }
    }
    var chosenRiskClassKey: String!
    var chosenRiskClassIndex: Int! { // for layout's benifit
        if chosenRiskClassKey != nil {
            for (i, node) in riskClassNodes.enumerated() {
                if chosenRiskClassKey == node.key {
                    return i
                }
            }
        }
        return nil
    }
    
    var chosenRiskTypeKey: String!
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
        
    var chosenCardKey: String!
    
    // init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    func setupUI() {
        backgroundColor = UIColor.clear
    }
        
    // create
    // helps
    func createHelpNodes(_ nodeFrame: CGRect) {
        helpNodes.removeAll()
        
        // tier 1, 2, 3
        for i  in 0..<3 {
            let help = SimpleNode()
            help.image = UIImage(named: "act_\(i)")
            help.borderShape = .none
            help.frame = nodeFrame
            help.tag = 100 + i
            
            addSubview(help)
            helpNodes.append(help)
        }
    }
    
    // riskTypes
    func createRiskTypeNodes() {
        let riskTypes = collection.getAllRiskTypes()
        for riskType in riskTypes {
            let riskTypeType = RiskTypeType.getTypeOfRiskType(riskType.key)
            if riskTypeType == .iCa || riskTypeType == .iPa {
                continue
            }
            
            let node = ButterflyNode()
            node.key = riskType.key
                
            // colors are dynamic
            riskTypeNodes.append(node)
            addSubview(node)
        }
    }
    
    // alert
    func showAlert()  {
        let alert = UIAlertController(title: "No Record For This Node", message: "Would you like to play this deck of cards", preferredStyle: .alert)
        let playAction = UIAlertAction(title: "Play", style: .default) { (true) in
            self.goToLanding()
        }
        let action = UIAlertAction(title: "Later", style: .default, handler: nil)
        alert.addAction(playAction)
        alert.addAction(action)
        hostVC.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func goToLanding() {
        GameTintApplication.sharedTint.focusingTierIndex = chosenHelpIndex
        if self.chosenRiskClassKey != nil {
            cardsCursor.selectedRiskClassKey = chosenRiskClassKey
        }
        
        let tab = hostVC.tabBarController as! ABookTabBarController
        tab.selectedIndex = 0
        let navi = tab.viewControllers![0] as! ABookNavigationController
        for vc in navi.viewControllers {
            if vc.isKind(of: ABookLandingPageViewController.self) {
                navi.popToViewController(vc, animated: true)
                return
            }
        }
        
        let landing = ABookLandingPageViewController()
        navi.pushViewController(landing, animated: true)
    }
}
