//
//  MatchedCardsReviewCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/19.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class MatchedCardsReviewCollectionView: WindingRoadCollectionView, UICollectionViewDataSource {
    class func createWithFrame(_ frame: CGRect) -> MatchedCardsReviewCollectionView {
        let layout = BlockFlowLayout()
        let matchedView = MatchedCardsReviewCollectionView(frame: frame, collectionViewLayout: layout)
        matchedView.backgroundColor = UIColor.clear
        matchedView.bounces = false
    
        matchedView.turningRadius = 35 * fontFactor
        matchedView.roadMainColor = UIColorFromHex(0x2D6100)
        matchedView.roadWidth = 22 * fontFactor
        // data
        matchedView.register(AssessmentDisplayCell.self, forCellWithReuseIdentifier: assessmentDisplayCellID)
        
        // delegate
        layout.dataSource = matchedView
        matchedView.dataSource = matchedView
        matchedView.delegate = matchedView
        
        // flag
        matchedView.addImages()
        
        return matchedView
    }
    
    fileprivate let endFlag = UIImageView(image: ProjectImages.sharedImage.roadFlag)
    fileprivate func addImages() {
        endFlag.frame.size = CGSize(width: 73 * standWP, height: 71 * standWP)
         typeButton.adjustRiskTypeButtonWithFrame(CGRect(center: CGPoint.zero, width: 62 * fontFactor, height: 53 * fontFactor))
        addSubview(endFlag)
        addSubview(typeButton)
    }
    
    // front
    var showRoad = true {
        didSet{
            reloadData()
            setNeedsDisplay()
            endFlag.isHidden = !showRoad
            typeButton.isHidden = (!showRoad || typeToRiskClasses)
        }
    }
    fileprivate var topicPoint = CGPoint.zero
    fileprivate var displayedGroups = [(String, [String])]()
    fileprivate var typeToRiskClasses = true
    fileprivate var typeButton = CustomButton.usedAsRiskTypeButton("")
    fileprivate var secondPoint: CGPoint!
    fileprivate var riskTypeKey: String!
    fileprivate var topicIndex: Int = 2
    func loadDataWithTopic(_ topicIndex: Int, topicPoint: CGPoint) {
        // riskType - risks
        typeToRiskClasses = (topicIndex == 2)
        self.topicPoint = topicPoint
        self.topicIndex = topicIndex
        
        firstDirection = typeToRiskClasses ? .fromTop : .fromLeft
        // data
        displayedGroups.removeAll()
        let riskClasses = LandingModel.getAllTierRiskClasses()[topicIndex] ?? []
        
        if typeToRiskClasses {
            typeButton.isHidden = true
            secondPoint = nil
            for type in collection.getAllRiskTypes() {
                if type.key == GameTintApplication.sharedTint.iCaKey || type.key == GameTintApplication.sharedTint.iPaKey {
                    continue
                }
                
                var riskClassKeys = [String]()
                for metric in riskClasses {
                    let riskKeys = collection.getRiskModelKeys(metric.key, riskType: type.key)
                    if riskKeys.count != 0 {
                        riskClassKeys.append(metric.key)
                    }
                }
                displayedGroups.append((type.key, riskClassKeys))
            }
            
        }else {
            // iCa, iPa
            riskTypeKey = (topicIndex == 0 ? GameTintApplication.sharedTint.iCaKey : GameTintApplication.sharedTint.iPaKey)
            secondPoint = CGPoint(x: topicPoint.x + 52 * standWP, y: topicPoint.y + 52 * standHP)
            typeButton.setForRiskType(riskTypeKey)
            typeButton.center = secondPoint
            
            for metric in riskClasses {
                let cards = MatchedCardsDisplayModel.getAllMatchedScoreCardsOfRiskClass(metric.key, riskTypeKey: riskTypeKey)
                var cardKeys = [String]()
                for card in cards {
                    cardKeys.append(card.key)
                }
                displayedGroups.append((metric.key, cardKeys))
            }
        }
        
        showRoad = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showRoad ? displayedGroups.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let display = displayedGroups[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: assessmentDisplayCellID, for: indexPath) as! AssessmentDisplayCell
        if typeToRiskClasses {
            cell.configureForMatchWithRiskType(display.0, riskClasses: display.1, indexPath: indexPath)
        }else {
            cell.configureForMatchWithRiskClass(display.0, cards: display.1, riskTypeKey: riskTypeKey, indexPath: indexPath)
        }
        
        cell.cardIsSelected = showReviewOfIndexPath
        
        return cell
    }
    
    override func draw(_ rect: CGRect) {
        if showRoad {
            super.draw(rect)
            
            if secondPoint != nil {
                let topLine = UIBezierPath()
                topLine.move(to: topicPoint)
                let turning = CGPoint(x: topicPoint.x, y: secondPoint.y)
                topLine.addCurve(to: secondPoint, controlPoint1: turning, controlPoint2: turning)
                UIColorFromHex(0x00C853).setStroke()
                topLine.lineWidth = 2 * fontFactor
                topLine.stroke()
            }
        }
    }
}


// data
extension MatchedCardsReviewCollectionView: BlockFlowDataSource {
    // default as 2
    func numberOfColsForLayout(_ layout: BlockFlowLayout) -> Int {
        return 1
    }
    
    func topMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0: return typeToRiskClasses ? topicPoint.y + 25 * standHP : 120 * standHP
        case 1: return -55 * standHP
        case 2: return -10 * standHP
        default: return -20 * standHP
        }
    }
    
    func leftMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        let index = ((typeToRiskClasses ? 1 : 0) + indexPath.item) % 4
        switch index {
        case 0: return 246 * standWP
        case 1: return 40 * standWP
        case 2: return 252 * standWP
        case 3: return 25 * standWP
        default: return 45 * standWP
        }
    }
    
    func itemSizeAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        return CGSize(width: 124 * fontFactor, height: 135 * fontFactor)
    }
    
    // button and flag height
    func sectionEdgeInsetsForLayout(_ layout: BlockFlowLayout) -> UIEdgeInsets {
        let bottom = endFlag.frame.height + 70 * fontFactor
        return UIEdgeInsets(top: topicPoint.y, left: 0, bottom: bottom, right: 0)
    }
}

// collection view delegate
extension MatchedCardsReviewCollectionView: UICollectionViewDelegate {
    // selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showReviewOfIndexPath(indexPath, cardIndex: 0)
    }

    fileprivate func showReviewOfIndexPath(_ indexPath: IndexPath, cardIndex: Int) {
        let display = displayedGroups[indexPath.item]
        if typeToRiskClasses {
            // riskType
            let cards = MatchedCardsDisplayModel.getAllMatchedScoreCardsOfRiskType(display.0, forUser: userCenter.currentGameTargetUser.Key())
            if cards.isEmpty {
                alertForNoPlay(display)
            }else {
                showCards(cards, riskTypeKey: display.0)
            }
        }else {
            // riskClass-cards
            if display.1.isEmpty {
                // alert
                alertForNoPlay(display)
            }else {
                var cards = [CardInfoObjModel]()
                for key in display.1 {
                    cards.append(collection.getCard(key)!)
                }
                showCards(cards, riskTypeKey: riskTypeKey)
            }
        }
    }
    fileprivate func showCards(_ cards: [CardInfoObjModel], riskTypeKey: String) {
        let review = MatchedCardsRisksReviewViewController()
        review.loadWithCards(cards, riskTypeKey: riskTypeKey)
        viewController.presentOverCurrentViewController(review, completion: nil)
    }
    
    fileprivate func alertForNoPlay(_ display: (String, [String])) {
        let alert = UIAlertController(title: "Not played", message: "You have not played", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "I see", style: .default, handler: nil)
        let playAction = UIAlertAction(title: "Go to Play", style: .default) { (action) in
            GameTintApplication.sharedTint.focusingTierIndex = self.topicIndex
            let tab = self.viewController.tabBarController
            tab?.selectedIndex = 0
            let navi = tab!.viewControllers![0] as! ABookNavigationController
            
            for vc in navi.viewControllers {
                if vc.isKind(of: ABookLandingPageViewController.self) {
                    navi.popToViewController(vc, animated: true)
                    if self.typeToRiskClasses {
                        return
                    }else {
                        break
                    }
                }
            }
            if self.typeToRiskClasses {
                // to landing
                cardsCursor.selectedRiskClassKey = display.0
                let landing = ABookLandingPageViewController()
                navi.pushViewController(landing, animated: true)
            }else {
                // to introduction
                cardsCursor.selectedRiskClassKey = display.0
                let intro = IntroPageViewController()
                navi.pushViewController(intro, animated: true)
            }
        }
        alert.addAction(okAction)
        alert.addAction(playAction)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    // draw road after all data is set
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let endH = endFlag.frame.height * 0.6
        let endPoint = CGPoint(x: 102 * standWP, y: contentSize.height - endH)
        // end
        let layout = collectionViewLayout as! BlockFlowLayout
        
        if secondPoint != nil {
            startPoint = secondPoint
        }else {
            startPoint = topicPoint
        }
        
        endFlag.center = endPoint
        
        // all read
        anchorInfo.removeAll()
        for attri in layout.attriArray {
            anchorInfo.append((CGPoint(x: attri.center.x, y: attri.center.y), false))
        }
        anchorInfo.append((endPoint, false))
    }
}

