//
//  ButterflyMapView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/7.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation
enum ButterflyMapState {
    case overall, helpChosen, topicChosen, oneRiskClass, risk, cards
}

class ButterflyMapView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    // frames
    fileprivate var standP: CGFloat {
        return min(bounds.width, bounds.height) / 375
    }
    fileprivate var viewCenter: CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    // overall, helpChosen, topicChosen, oneRiskClass, risk, cards
    // overall
    fileprivate var radius: CGFloat{
        return 268 * standP * 0.5
    }
    
    // data
    fileprivate var mapState = ButterflyMapState.overall
    fileprivate let firstTexts = ["Help You Understand", "Help You Care", "Help You Act"]
    fileprivate let topicImages = [ProjectImages.sharedImage.slowLogo, ProjectImages.sharedImage.petLogo, ProjectImages.sharedImage.proLogo, ProjectImages.sharedImage.workLogo]
    
    // deco
    fileprivate let topEnlarge: CGFloat = 229 / 153
    fileprivate let topButterfly = UIImageView()
    // nodes
    fileprivate let avatar = UIImageView()
    fileprivate var butterFlies = [ButterflyView]() // tag: 100 + i
    fileprivate var topics = [UIImageView]() // tag: 200 + i
    
    fileprivate func setupUI() {
        backgroundColor = UIColor.clear
        
        // avatar : 104 * 117
        avatar.image = ProjectImages.sharedImage.shAvatar
        avatar.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY - standP * 6.5), width: 104 * standP, height: 117 * standP)
        addSubview(avatar)
        
        // butterflies
        let bWidth = standP * 153
        let bHeight = 121 * bWidth / 153
        let topFrame = CGRect(x: bounds.midX - topEnlarge * bWidth * 0.5, y: 40 * standP, width: bWidth * topEnlarge, height: topEnlarge * bHeight)
        topButterfly.image = ProjectImages.sharedImage.butterfly
        topButterfly.frame = topFrame
        addSubview(topButterfly)
        topButterfly.isHidden = true
       
        for (i, text) in firstTexts.enumerated() {
            let angle = CGFloat(Double.pi / 6) + CGFloat(i) * 2 * CGFloat(Double.pi) / 3
            let bCenter = Calculation().getPositionByAngle(angle, radius: radius - bHeight * 26 / 121, origin: viewCenter)
            let butterfly = ButterflyView.createWithFrame(CGRect(center: bCenter, width: bWidth, height: bHeight), angle: angle - CGFloat(Double.pi) * 0.5, text: text)
            addSubview(butterfly)
            butterFlies.append(butterfly)
            butterfly.tag = 100 + i
        }
        
        for (i, topicImage) in topicImages.enumerated() {
            let imageView = UIImageView(image: topicImage)
            imageView.frame = CGRect(center: CGPoint(x: i % 2 == 0 ? topFrame.minX : topFrame.maxX, y:  i / 2 == 0 ? topFrame.minY : topFrame.maxY), length: 75 * standP)
            imageView.layer.addBlackShadow(standP * 2)
            imageView.tag = 200 + i
            topics.append(imageView)
            addSubview(imageView)
            
            imageView.isHidden = true
        }
    }
    
    // MARK: ------------------- all kinds of state
    //  case overall, helpChosen, topicChosen, oneRiskClass, risk, cards
    fileprivate var chosenHelpIndex: Int!
    fileprivate var chosenTopic: Int!
    fileprivate var chosenRiskClassKey: String!
    fileprivate var chosenRiskType: String!
    
    var drawBack = true
}

extension ButterflyMapView {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let point = touches.first!.location(in: self)
        
        // touch avator
        if avatar.frame.contains(point) {
            if mapState != .overall {
                setToOverallState()
            }
            return
        }
        
        // touch butterfly
        for butterfly in butterFlies {
            let circleFrame = convert(butterfly.thickCircle.frame, from: butterfly)
            if circleFrame.contains(point) {
                let tagIndex = butterfly.tag - 100
                if mapState != .helpChosen {
                    chosenHelpIndex = tagIndex
                    setToHelpChosenState()
                }else if chosenHelpIndex != tagIndex {
                    chosenHelpIndex = tagIndex
                    setToHelpChosenState()
                }
                
                return
            }
        }
        
        // touch topic
        for topic in topics {
            if topic.frame.contains(point) {
                let tagIndex = topic.tag - 200
                if mapState != .helpChosen {
                    chosenTopic = tagIndex
                    setToTopicChosenState()
                }else if chosenHelpIndex != tagIndex {
                    chosenTopic = tagIndex
                    setToTopicChosenState()
                }
                return
            }
        }
    }
    
    
    // MARK: ------------------- all kinds of state
    //  case overall, helpChosen, topicChosen, oneRiskClass, risk, cards
    func setToOverallState() {
        mapState = .overall
        
        topButterfly.isHidden = true
        for topic in topics {
            topic.isHidden = true
        }
        
        setNeedsDisplay()
        
        UIView.animate(withDuration: 0.4, animations: {
            self.avatar.transform = .identity
            for (i, butterfly) in self.butterFlies.enumerated() {
                butterfly.resetViewToAngle(CGFloat(Double.pi / 6) - CGFloat(Double.pi) * 0.5 + CGFloat(i) * 2 * CGFloat(Double.pi) / 3)
                butterfly.alpha = 1
                butterfly.butterflyImageView.isHidden = false
            }
        }) { (true) in
            
        }
    }
    
    func setToHelpChosenState() {
        drawBack = false
        setNeedsDisplay()
        mapState = .helpChosen
        
        topButterfly.isHidden = true
        for topic in self.topics {
            topic.isHidden = true
        }
        
        let chosen = butterFlies[chosenHelpIndex]
        chosen.alpha = 1
        
        let topFrame = topButterfly.frame
        let bottomY = bounds.height - 107 * standP
        
        var remained = [ButterflyView]()
        for butterfly in butterFlies {
            butterfly.butterflyImageView.isHidden = false
            if butterfly !== chosen {
                remained.append(butterfly)
            }
        }
    
        UIView.animate(withDuration: 0.6, animations: {
            chosen.resetViewToAngle(0)
            chosen.transform = chosen.transform.translatedBy(x: topFrame.midX - chosen.frame.midX, y: topFrame.midY - chosen.frame.midY)
            chosen.transform = chosen.transform.scaledBy(x: self.topEnlarge, y: self.topEnlarge)
            chosen.label.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
            chosen.thickCircle.transform = chosen.label.transform

            self.avatar.transform = CGAffineTransform(translationX: 0, y: bottomY - self.bounds.midY)
            
            // remained
            for (i, butterfly) in remained.enumerated() {
                // 0, as right
               butterfly.resetViewToAngle(0)
               let angle = CGFloat(Double.pi / 6) + CGFloat(i) * 2 * CGFloat(Double.pi) / 3
                let bCenter = Calculation().getPositionByAngle(angle, radius: self.radius * 0.8, origin: CGPoint(x: self.bounds.midX, y: bottomY))
               
                butterfly.transform = butterfly.transform.translatedBy(x: bCenter.x - butterfly.frame.midX, y: bCenter.y - butterfly.frame.midY)
                butterfly.addToRotation(angle - CGFloat(Double.pi) * 0.5)
                butterfly.transform = butterfly.transform.scaledBy(x: 0.65, y: 0.65)
                butterfly.alpha = 0.7
            }

        }) { (true) in
            self.drawBack = true
            self.setNeedsDisplay()

            for topic in self.topics {
                topic.isHidden = false
                topic.transform = CGAffineTransform.identity
            }
        }
        
    }
    
    func setToTopicChosenState() {
        mapState = .topicChosen
        
        let chosen = topics[chosenTopic]
        let chosenHelp = butterFlies[chosenHelpIndex]
        topButterfly.isHidden = false
        for butterfly in butterFlies {
            butterfly.butterflyImageView.isHidden = true
        }
        
        UIView.animate(withDuration: 0.5, animations: {
            chosen.transform = CGAffineTransform(translationX:self.bounds.midX - chosen.frame.midX, y: self.topButterfly.frame.midY - chosen.frame.midY)
            
            self.avatar.transform = self.avatar.transform.scaledBy(x: 0.5, y: 0.5)
//            chosenHelp.frame = CGRect(x: 10, y: 100, widh)
        }) { (true) in
            
        }
       
    }
    
    func setToOneRiskClassState()  {
        
    }
    func setToRiakState() {
        
    }
    
    func setToCardsState()  {
        
    }
    
    
    override func draw(_ rect: CGRect) {
        if !drawBack {
            return
        }
        
        let lightGreen = UIColorFromRGB(193, green: 231, blue: 149)
        let darkGreen = UIColorFromRGB(0, green: 200, blue: 83)
        switch mapState {
        case .overall:
            let path = UIBezierPath(arcCenter: viewCenter, radius: radius, startAngle: 0, endAngle: 2 * CGFloat(Double.pi), clockwise: true)
            path.lineWidth = standP
            UIColor.white.setFill()
            lightGreen.setStroke()
            path.fill()
            path.stroke()
        case .helpChosen:
            let path = UIBezierPath()
            path.move(to: centerOfView(avatar))
            path.addLine(to: centerOfView(topButterfly))
            path.lineWidth = 2 * standP
            darkGreen.setStroke()
            path.stroke()
        case .topicChosen:
            break
        default:
            return
        }
    }
    
    fileprivate func centerOfView(_ view: UIView) -> CGPoint {
        return CGPoint(x: view.frame.midX, y: view.frame.midY)
    }
}
