//
//  VisualMapConnectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/4/8.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class VisualMapConnectionView: UIView {
    // data for display
    var basicType = VisualMapType.riskClass
    var connectionType = VisualMapType.riskFactors
    
    // total
    var metricNodes: [VisualMapNode] {
        return VisualMapData.createAllMetricNodes()
    }
    var iRaCategoryNodes: [VisualMapNode] {
        return VisualMapData.createAllIRANodes()
    }
    var iSaCategoryNodes: [VisualMapNode] {
        return VisualMapData.createAllISaNodes()
    }
    
    // nodes on view
    var basicNodes = [VisualMapNode]()
    var firstNode: VisualMapNode!
    fileprivate var secondaryNodes = [VisualMapNode]()
    fileprivate var secondNode: VisualMapNode!
    fileprivate var onShow = [VisualMapNode]()
    var cardsDistributionNodes = [CardsDistributionNode]()
    
    var cardView: VisualMapCardsDisplayView!
    // UI information
    var viewCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    var maxRadius: CGFloat {
        return min(bounds.midX, bounds.midY)
    }

    let centerImageView = UIImageView(image: ProjectImages.sharedImage.maleAvatar)
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
       
        // center
        centerImageView.isUserInteractionEnabled = true
        centerImageView.contentMode = .scaleAspectFit
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(goBackToOriginalState))
        centerImageView.addGestureRecognizer(tapGR)
        
        // add
        addSubview(centerImageView)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // load nodes
    func loadBasicNodes() {
        // nodes
        switch basicType {
        case .riskClass:
            basicNodes = metricNodes
        case .riskFactors:
            basicNodes = iRaCategoryNodes
        case .symptoms:
            basicNodes = iSaCategoryNodes
        }
        
        switch connectionType {
        case .riskClass:
            secondaryNodes = metricNodes
        case .riskFactors:
            secondaryNodes = iRaCategoryNodes
        case .symptoms:
            secondaryNodes = iSaCategoryNodes
        }
       
        // add
        // basic
        for node in basicNodes {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(nodeIsTapped(_:)))
            node.addGestureRecognizer(tapGR)
            addSubview(node)
        }
        
        // secondary
        for node in secondaryNodes {
            // add target
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(showCards))
            node.addGestureRecognizer(tapGR)
            
            addSubview(node)
        }
        
        let cardFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - self.maxRadius)
        cardView = VisualMapCardsDisplayView.createWithFrame(cardFrame, cardKeys: [])
        addSubview(cardView)
        
        originalState()
    }

    
    // MAKR: ---------- tap gestureRecognizer
    func goBackToOriginalState() {
        moving = true
        UIView.animate(withDuration: 0.5, animations: {
            self.originalState()
        }, completion: { (true) in
            self.moving = false
        })
    }
    
    func nodeIsTapped(_ tapGR: UITapGestureRecognizer) {
        cardView.isHidden = true
        let node = tapGR.view as! VisualMapNode
        
        if firstNode != nil && node.key == firstNode.key && secondNode == nil || node.disabled {
            // is current
            return
        }
        
        moving = true
        firstNode = node
        secondNode = nil
        
        let keys = connectedKeysOfBasicNode(node.key)
        onShow = setupSecondaryNodes(keys)
        
        let offset = maxRadius * 0.22
        let cornerCenter = CGPoint(x: offset, y: bounds.height - offset)
        UIView.animate(withDuration: 0.5, animations: {
            // left down
            self.centerImageView.frame = CGRect(center: cornerCenter, length: self.maxRadius * 0.2)
            ButterflyLayout.layoutEvenCircleWithRootCenter(cornerCenter, children: self.basicNodes, radius: self.maxRadius * 0.15, startAngle: 90, expectedLength: self.maxRadius * 0.14)
            
            // middle
            ButterflyLayout.layoutEvenCircleWithRootCenter(self.viewCenter, children: self.onShow, radius: self.maxRadius * 0.4, startAngle: 90, expectedLength: self.maxRadius * 0.2)
            node.frame = CGRect(center: self.viewCenter, length: self.maxRadius * 0.16)
        }, completion: { (true) in
            self.moving = false
            self.createCardsNode()
          
            // cards
            UIView.animate(withDuration: 0.3, animations: {
                if self.basicType == .riskClass {
                    ButterflyLayout.layoutEvenCircleWithRootCenter(self.viewCenter, children: self.cardsDistributionNodes, radius: self.maxRadius * 0.7, startAngle: 90, expectedLength: self.maxRadius * 0.6)
                }else {
                    self.cardsDistributionNodes.first!.frame = CGRect(center: self.viewCenter, length: 2 * self.maxRadius)
                    self.cardsDistributionNodes.first!.innerRadius = self.maxRadius * 0.5
                }
            })
        })
    }
    
    fileprivate func createCardsNode() {
        clearCurrentCardsNode()
        if basicType != .riskClass {
            let cardsNode = CardsDistributionNode()
            cardsNode.cardKeys = collection.getAllCardsOfCategory(firstNode.key)
            cardsDistributionNodes.append(cardsNode)
        }else {
            for node in onShow {
                let cards = cardKeysOfBasicNodeKey(firstNode.key, secondNodeKey: node.key)
                let cardsNode = CardsDistributionNode()
                cardsNode.cardKeys = cards
                cardsNode.connectedNode = node
                cardsDistributionNodes.append(cardsNode)
            }
        }
      
        for cardsNode in cardsDistributionNodes {
            cardsNode.center = viewCenter
            
            // tap
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(showCards(_:)))
            cardsNode.addGestureRecognizer(tapGR)
            insertSubview(cardsNode, at: 0)
        }
    }
    
    fileprivate func clearCurrentCardsNode() {
        for node in cardsDistributionNodes {
            node.removeFromSuperview()
        }
        
        cardsDistributionNodes.removeAll()
    }
    
    // layout
    func originalState() {
        clearCurrentCardsNode()
        cardView.isHidden = true
        
        // no chosen
        firstNode = nil
        secondNode = nil
        
        // showAll
        for node in secondaryNodes {
            node.isHidden = false
        }
        
        // layout
        centerImageView.frame = CGRect(center: viewCenter, length: 0.35 * maxRadius)
        ButterflyLayout.layoutEvenCircleWithRootCenter(viewCenter, children: secondaryNodes, radius: maxRadius * 0.45, startAngle: 90, expectedLength: maxRadius * 0.2)
        ButterflyLayout.layoutEvenCircleWithRootCenter(viewCenter, children: basicNodes, radius: maxRadius * 0.9, startAngle: 90, expectedLength: maxRadius * 0.2)
       
        if basicType == .symptoms {
            ButterflyLayout.layoutEvenCircleWithRootCenter(viewCenter, children: secondaryNodes, radius: maxRadius * 0.3, startAngle: 90, expectedLength: maxRadius * 0.2)
            
            var radii = [CGFloat]()
            for i in 0..<basicNodes.count {
                if i == 0 || i == 4 {
                    radii.append(maxRadius * 0.2)
                }else if i == 1 || i == 2  {
                    radii.append(maxRadius * 0.15)
                } else {
                    radii.append(maxRadius * 0.04)
                }
                
            }
            
            let frames = layoutPans(radii, inContainer: bounds, centerRadius: maxRadius * 0.4)
            for (i, node) in basicNodes.enumerated() {
                node.frame = frames[i]
            }
        }
        
        if connectionType == .symptoms {
            var radii = [CGFloat]()
            for i in 0..<secondaryNodes.count {
                if i == 0 || i == 4 {
                    radii.append(maxRadius * 0.2)
                }else if i == 1  || i == 2 {
                    radii.append(maxRadius * 0.15)
                } else {
                    radii.append(maxRadius * 0.04)
                }
                
            }
            
            let frames = layoutPans(radii, inContainer: bounds.insetBy(dx: maxRadius * 0.2, dy: maxRadius * 0.2), centerRadius: maxRadius * 0.2)
            for (i, node) in secondaryNodes.enumerated() {
                node.frame = frames[i]
            }
        }
    }
    
    func setupSecondaryNodes(_ keys: [String]) -> [VisualMapNode] {
        var onShow = [VisualMapNode]()
        for node in secondaryNodes {
            if keys.contains(node.key) {
                node.frame = CGRect(center:viewCenter, length: maxRadius * 0.2)
//                node.showText = true
                node.isHidden = false
                onShow.append(node)
            }else {
                node.isHidden = true
            }
        }
        
        return onShow
    }
    
    func showCards(_ tapGR: UITapGestureRecognizer) {
        if firstNode == nil {
            return
        }
        
        var node: VisualMapNode!
        if tapGR.view is VisualMapNode {
           node = tapGR.view as! VisualMapNode
        }else {
            // card node is tapped
            node = (tapGR.view as! CardsDistributionNode).connectedNode
        }
        
        if (secondNode != nil && node.key == secondNode.key) {
            return
        }

        secondNode = node
        
        var cardKeys = [String]()
        if connectionType == .riskClass {
            cardKeys = collection.getAllCardsOfCategory(firstNode.key)
        }else {
            cardKeys = cardKeysOfBasicNodeKey(firstNode.key, secondNodeKey: secondNode.key)
        }
        
        var cards = [CardInfoObjModel]()
        for key in cardKeys {
            cards.append(collection.getCard(key)!)
        }
        
        // cards
        let cornerCenter = CGPoint(x: bounds.midX, y: centerImageView.frame.midY)
        clearCurrentCardsNode()
        moving = true
        UIView.animate(withDuration: 0.5, animations: {
            self.firstNode.frame = CGRect(center: cornerCenter, length: self.maxRadius * 0.15)
            
            ButterflyLayout.layoutEvenCircleWithRootCenter(cornerCenter, children: self.onShow, radius: self.maxRadius * 0.15, startAngle: 0, expectedLength: self.maxRadius * 0.14, except: self.secondNode)
            self.secondNode.frame = CGRect(center: CGPoint(x: self.bounds.midX, y: self.centerImageView.frame.midY - self.maxRadius * 0.35), length: self.maxRadius * 0.24)
        }, completion: { (true) in
            self.cardView.isHidden = false
            self.moving = false
            self.cardView.cards = cardKeys
        })
    }

    
    func alert() {
        let alertController = UIAlertController(title: "The cards are not load", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Check Others", style: .default) { (true) in
            
        }
        alertController.addAction(action)
        var nextView = self.superview
        while nextView != nil {
            if let responder = nextView!.next {
                if responder.isKind(of: UIViewController.self) {
                    (responder as! UIViewController).present(alertController, animated: true, completion: nil)
                    break
                }
                nextView = nextView!.superview
            }
        }
    }
    
    fileprivate func connectedKeysOfBasicNode(_ key: String) -> [String] {
        if basicType == .riskClass {
            return collection.getCategoriesOfRiskType(connectionType == .riskFactors ? iRaKey : iSaKey, riskClassKey: key)
        }else {
            return collection.getRiskClassesWithCategory(key)
        }
    }
    
    fileprivate func cardKeysOfBasicNodeKey(_ basicNodeKey: String, secondNodeKey: String) -> [String] {
        if basicType == .riskClass {
            return collection.getCardsOfCategory(secondNodeKey, inRiskClass: basicNodeKey)
        }else {
            return collection.getCardsOfCategory(basicNodeKey, inRiskClass: secondNodeKey)
        }
    }
    
    fileprivate var moving = false {
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if moving {
            return
        }
        
        if firstNode == nil {
            // original
            for basicNode in basicNodes {
                let keys = connectedKeysOfBasicNode(basicNode.key)
                for secondaryNode in secondaryNodes {
                    if keys.contains(secondaryNode.key) {
                        addConnection(basicNode.center, nodes: [secondaryNode])
                    }
                }
            }
        }else if secondNode == nil {
            addConnection(firstNode.center, nodes: onShow)
        }else {
            addConnection(centerImageView.center, nodes: [firstNode])
            addConnection(firstNode.center, nodes: onShow)
            
            // with card
            
        }
    }
    
    fileprivate func addConnection(_ center: CGPoint, nodes: [VisualMapNode]) {
        let path = UIBezierPath()
        for node in nodes {
            path.move(to: center)
            if node.alpha != 0 {
                path.addLine(to: node.center)
                path.lineWidth = fontFactor * 0.8
                UIColorFromRGB(141, green: 141, blue: 161).setStroke()
                path.stroke()
            }
        }
    }
}


