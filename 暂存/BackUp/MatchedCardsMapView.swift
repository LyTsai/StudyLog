//
//  MatchedCardsMapView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/23.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class MatchedCardsMapView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        createBasicNodes()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createBasicNodes()
    }
    
    fileprivate var standP: CGFloat {
        return min(bounds.width / 375, bounds.height / 667)
    }
    
    fileprivate let avatar = UIImageView(image: ProjectImages.sharedImage.shAvatar)
    var riskTypeNodes = [ButterflyNode]()
    var riskClassNodes = [String: [ButterflyNode]]()
    fileprivate func createBasicNodes() {
        backgroundColor = UIColor.clear
        
        avatar.image = ProjectImages.sharedImage.shAvatar
        avatar.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY - standP * 6.5), width: 100 * standP, height: 114 * standP)
        addSubview(avatar)
        
        // riskTypes
        reloadData()
        let riskTypes = AIDMetricCardsCollection.standardCollection.getAllRiskTypes()
        for riskType in riskTypes {
            let node = ButterflyNode()
            node.key = riskType.key
            
            // colors are dynamic
            riskTypeNodes.append(node)
            addSubview(node)
        }
        
        overallState()
    }
    
    fileprivate func overallState() {
        ButterflyLayout.layoutEvenOvalWithRootCenter(avatar.center, children: riskTypeNodes, ovalA: bounds.midX - 80 * standP, ovalB: bounds.midY - 90 * standP, startAngle: CGFloat(Double.pi) * 3 / 2, expectedSize: CGSize(width: 75 * standP, height: 75 * standP))
        
        // title and color
        setRiskTypeNodeTitles(true)
        setRiskTypeNodeColors()
        setRiskClassNodes()
    }
    
    fileprivate func setRiskTypeNodeColors() {
        for riskType in riskTypeNodes {
            if matched[riskType.key] == nil {
                riskType.innerColor = UIColorGray(213)
                riskType.isDisabled = true
            }else {
//                 [(color: UIColorFromRGB(0, green: 176, blue: 255), name: "iRa Risk"),
//                 (color: UIColorFromRGB(238, green: 109, blue: 107), name: "iSa Symptoms"),
//                 (color: UIColorFromRGB(255, green: 196, blue: 0), name: "iIa Impact"),
//                 (color: UIColorFromRGB(100, green: 221, blue: 23), name: "iAa Actions")]
                if riskType.text != nil {
                    if riskType.text.localizedCaseInsensitiveContains("ira") {
                        riskType.circleColor = UIColorFromRGB(0, green: 176, blue: 255)
                    }else if riskType.text.localizedCaseInsensitiveContains("isa") {
                        riskType.circleColor = UIColorFromRGB(238, green: 109, blue: 107)
                    }else if riskType.text.localizedCaseInsensitiveContains("iia") {
                        riskType.circleColor = UIColorFromRGB(255, green: 196, blue: 0)
                    }else if riskType.text.localizedCaseInsensitiveContains("iaa") {
                        riskType.circleColor = UIColorFromRGB(100, green: 221, blue: 23)
                    }
                }
            }
        }
    }
    
    fileprivate func setRiskTypeNodeTitles(_ total: Bool) {
        for riskType in riskTypeNodes {
            let name = AIDMetricCardsCollection.standardCollection.getRiskTypeByKey(riskType.key)!.name ?? "iRa"
            
            let index = name.index(name.startIndex, offsetBy: 3)
            let typeName = name.substring(to: index)
            riskType.text = total ? name : typeName
            riskType.boldFont = !total
        }
    }
    
    
    fileprivate func setRiskClassNodes() {
        
    }
    

    // riskTypeKey: [riskClass: [cards]]
    fileprivate var matched = [String: [MetricObjModel: [CardInfoObjModel]]]()
    fileprivate func reloadData() {
        matched.removeAll()
        
        // data
        // riskClasses
        var riskClasses = [MetricObjModel]()
        for (_, classes) in AIDMetricCardsCollection.standardCollection.getAllGroupedRiskClasses() {
            riskClasses.append(contentsOf: classes)
        }
        
        // group
        for riskType in AIDMetricCardsCollection.standardCollection.getAllRiskTypes() {
            for riskClass in riskClasses {
                let cards = MatchedCardsDisplayModel.getAllMatchedCardsOfRiskClass(riskClass.key, riskTypeKey: riskType.key, forUser: UserCenter.sharedCenter.currentGameTargetUser.Key())
                if cards.count != 0 {
                    // riskClasses
                    if let _ = matched[riskType.key] {
                        matched[riskType.key]![riskClass] = cards
                        
                    }else {
                        matched[riskType.key] = [riskClass: cards]
                    }
            
                }
            }
        }
    }

    
    // connnect with person
    override func draw(_ rect: CGRect) {
        for riskType in riskTypeNodes {
            let path = UIBezierPath()
            path.move(to: avatar.center)
            path.addLine(to: riskType.center)
            
            riskType.circleColor.setStroke()
            riskType.lineWidth = 2 * standP
            
            path.stroke()
        }
    }
}
