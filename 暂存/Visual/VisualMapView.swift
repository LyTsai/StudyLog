//
//  VisualMapView.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/1/10.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
class VisualMapView: UIView, VisualNodeDelegate {
    // data
    var userKey: String {
        return UserCenter.sharedCenter.currentGameTargetUser.Key()
    }
    
    var noTypeRiskClassesNodes = [VisualNode]()
    var typeRiskClassesNodes =  [VisualNode]()
    var riskClassesNodes = [VisualNode]()
    var riskTypesNodes = [VisualNode]()
    
    // layout
//    var helpsLayout = RandomCirclesLayout()
    let riskTypesLayout = RandomCirclesLayout()
    let noTypeLayout = RandomCirclesLayout()
    let riskClassesLayout = RandomCirclesLayout()
    
    fileprivate var viewCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    fileprivate var panCenter = CGPoint.zero
    fileprivate let avatar = UIImageView(image: ProjectImages.sharedImage.maleAvatar)
    fileprivate var centerNode: VisualNode! // nil for avatar
    var leftTop = CGPoint.zero
    var rightBottom = CGPoint.zero
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNodes()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNodes()
    }
    
    fileprivate func loadNodes() {
        let allRiskClasses = AIDMetricCardsCollection.standardCollection.getRiskClasses()
        let allRiskTypes = AIDMetricCardsCollection.standardCollection.getAllRiskTypes()
        leftTop = CGPoint(x: 30 * fontFactor, y:  30 * fontFactor )
        rightBottom = CGPoint(x: bounds.width - leftTop.x, y: bounds.height - leftTop.y)
        
        // riskClasses
        for riskClass in allRiskClasses {
            let node = VisualNode()
            node.key = riskClass.key
            node.text = riskClass.name
            node.imageUrl = riskClass.imageUrl
//            node.color = riskClass.color
            // append
            node.delegate = self
            riskClassesNodes.append(node)
            addSubview(node)
            
//            if AIDMetricCardsCollection.standardCollection.getTierOfRiskClass(riskClass.key) != 3 {
//                noTypeRiskClassesNodes.append(node)
//            }else {
                typeRiskClassesNodes.append(node)
//            }
        }
        
        // riskTypes
        for riskType in allRiskTypes {
            if riskType.key == iCaKey || riskType.key == iPaKey {
                continue
            }
            
            let node = VisualNode()
            node.key = riskType.key
            node.text = riskType.name
//            node.color = riskClass.color
            
            // append
            node.delegate = self
            riskTypesNodes.append(node)
            addSubview(node)
        }
        
        // center avatar
        avatar.frame = CGRect(center: viewCenter, width: 40 * fontFactor, height: 40 * 76 / 111 * fontFactor)
        avatar.isUserInteractionEnabled = true
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(avatarIsTapped))
        avatar.addGestureRecognizer(tapGR)
        addSubview(avatar)
        
        // layout
        avatarIsTapped() // init state
    }

    // reload
    func reloadNodesInfo() {
        // reload
        let matchedInfo = MatchedCardsDisplayModel.getAllMatchedInfoOfUser(userKey)
        
        // riskClasses
        for node in riskClassesNodes {
            node.enabled = matchedInfo.keys.contains(node.key) // played or not
//            node.assessmentColor
        }
        
        var riskTypesPlayed = Set<String>()
        for (_, value) in matchedInfo {
            for (riskTypeKey, _) in value {
//                if riskTypeKey != riskTypeDefaultKey {
                    riskTypesPlayed.insert(riskTypeKey)
                    // all
                    if riskTypesPlayed.count == riskTypesNodes.count {
                        break
                    }
//                }
            }
        }
        
        for node in riskTypesNodes {
            node.enabled = riskTypesPlayed.contains(node.key) // played or not, for all now
//            node.assessmentColor
        }
    }
    
    fileprivate func layoutNodes() {
//        UIView.animate(withDuration: 0.5) {
//            self.drawNodes(self.riskTypesNodes, layout: self.riskTypesLayout)
//            self.drawNodes(self.riskClassesNodes, layout: self.riskClassesLayout)
//        }

        UIView.animate(withDuration: 0.5, animations: {
            self.drawNodes(self.riskTypesNodes, layout: self.riskTypesLayout)
            self.drawNodes(self.riskClassesNodes, layout: self.riskClassesLayout)
            if self.centerNode != nil {
                self.centerNode.center = self.leftTop
                self.avatar.center = self.rightBottom
            }
        }) { (true) in
            self.setNeedsDisplay()
        }
    }
    
    fileprivate func drawNodes(_ nodes: [VisualNode], layout: RandomCirclesLayout) {
        for (i, node) in nodes.enumerated() {
            node.frame = layout.getFrameAtIndex(i)
        }
    }
    
    // lines
    override func draw(_ rect: CGRect) {
        // draw
        if centerNode == nil {
            connectNodes(riskTypesNodes, rootNode: nil)
            connectNodes(riskClassesNodes, rootNode: nil)
        }else if riskTypesNodes.contains(centerNode) {
            connectNodes(typeRiskClassesNodes, rootNode: centerNode)
            connectNodes(riskTypesNodes, rootNode: nil)
        }else if typeRiskClassesNodes.contains(centerNode) {
            connectNodes(riskTypesNodes, rootNode: centerNode)
            connectNodes(riskClassesNodes, rootNode: nil)
        }
        
    }
    
    fileprivate func connectNodes(_ nodes: [VisualNode], rootNode: VisualNode!) {
        for node in nodes {
            var connectCenter = avatar.center
            if rootNode != nil {
                connectCenter = rootNode.center
            }
            
            // line
            let connectPath = UIBezierPath()
            connectPath.move(to: connectCenter)
            connectPath.addCurve(to: node.center, controlPoint1: connectCenter, controlPoint2: viewCenter)
//            connectPath.addLine(to: node.center)
            connectPath.lineWidth = fontFactor
            node.fillColor.setStroke()
            connectPath.stroke()
        }
    }
}

extension VisualMapView {
    func loadTest()  {
        reloadNodesInfo()
        
        layoutNodes()
        setNeedsDisplay()
    }
    
    // actions
    func avatarIsTapped() {
        centerNode = nil
        avatar.center = viewCenter
        
        // layout
        riskTypesLayout.minRadius = 20 * fontFactor
        riskTypesLayout.layoutCirclesOnMap(CGRect(center: viewCenter, length: bounds.width * 0.4), mapCenter:viewCenter, centerRadius: 20 * fontFactor, number: riskTypesNodes.count)
        
        riskClassesLayout.minRadius = 20 * fontFactor
        riskClassesLayout.layoutCirclesOnMap(bounds, mapCenter:viewCenter, centerRadius: bounds.width * 0.2, number: riskClassesNodes.count)
        
        layoutNodes()
    }
    
    func nodeIsTapped(_ node: VisualNode) {
        if node.enabled && node !== centerNode {
            centerNode = node
            
            if riskTypesNodes.contains(node) {
                let topWidth = min(bounds.width, bounds.height * 0.7)
                // riskType is chosen
                riskTypesLayout.layoutCirclesOnMap(CGRect(x: 0, y: topWidth, width: bounds.width, height: bounds.height - topWidth), mapCenter: rightBottom, centerRadius: 50 * fontFactor, number: riskTypesNodes.count)
//                noTypeLayout.layoutCirclesOnMap(<#T##mapFrame: CGRect##CGRect#>, mapCenter: <#T##CGPoint#>, centerRadius: <#T##CGFloat#>, number: <#T##Int#>)
                riskClassesLayout.layoutCirclesOnMap(CGRect(x: 0, y: 0, width: topWidth, height: topWidth), mapCenter: leftTop, centerRadius: 20 * fontFactor, number: riskClassesNodes.count)
            }else {
                // riskClasses
                let topWidth = bounds.width * 0.5
                riskClassesLayout.layoutCirclesOnMap(CGRect(x: 0, y: topWidth, width: bounds.width, height: bounds.height - topWidth), mapCenter: rightBottom, centerRadius: avatar.bounds.width * 0.5, number: riskClassesNodes.count)

                riskTypesLayout.layoutCirclesOnMap(CGRect(x: 0, y: 0, width: topWidth, height: topWidth), mapCenter: leftTop, centerRadius:  20 * fontFactor, number: riskTypesNodes.count)
            }
            
            layoutNodes()
        }else {
            print("the node is disabled or in center")
        }
    }
    
    func nodeIsPanned(_ node: VisualNode, pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            panCenter = node.center
        }
        
        let translate = pan.translation(in: self)
        node.center = CGPoint(x: panCenter.x + translate.x, y: panCenter.y + translate.y)
        setNeedsDisplay()
        
        if pan.state == .failed || pan.state == .ended || pan.state == .cancelled {
//            riskTypesLayout.changeCenterAtIndex(<#T##index: Int##Int#>, to: <#T##CGPoint#>)
        }
    }
    
}
