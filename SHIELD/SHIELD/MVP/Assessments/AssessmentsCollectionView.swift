//
//  AssessmentsCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/6.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class AssessmentsCollectionView: WindingRoadCollectionView, UICollectionViewDataSource {
    class func createWithFrame(_ frame: CGRect) -> AssessmentsCollectionView {
        let layout = BlockFlowLayout()
        let assessmentsView = AssessmentsCollectionView(frame: frame, collectionViewLayout: layout)
        assessmentsView.backgroundColor = UIColor.clear
        assessmentsView.bounces = false
        assessmentsView.firstDirection = .fromLeft
        assessmentsView.turningRadius = 40 * fontFactor
        assessmentsView.roadWidth = 22 * fontFactor
        // data
        assessmentsView.register(AssessmentDisplayCell.self, forCellWithReuseIdentifier: assessmentDisplayCellID)

        // delegate
        layout.dataSource = assessmentsView
        assessmentsView.dataSource = assessmentsView
        assessmentsView.delegate = assessmentsView
        
        // flag
        assessmentsView.addImages()
        
        return assessmentsView
    }
    
    fileprivate let endFlag = UIImageView(image: ProjectImages.sharedImage.roadFlag)
    fileprivate func addImages() {
        endFlag.frame.size = CGSize(width: 73 * standWP, height: 71 * standWP)
        addSubview(endFlag)
    }
    
    // front
    fileprivate var displayKeys = [String]()
    fileprivate var riskTypeKey: String!
    fileprivate var riskClassKey: String!
    func checkDataFromRiskType(_ riskTypeKey: String, riskClasses: [String]) {
        self.displayKeys = riskClasses
        self.riskTypeKey = riskTypeKey
        self.riskClassKey = nil
//         assessmentsView.setupDecoration()
    }
    
    func checkDataFromRiskClass(_ riskClassKey: String, riskTypes: [String]) {
        self.displayKeys = riskTypes
        self.riskTypeKey = nil
        self.riskClassKey = riskClassKey
//         assessmentsView.setupDecoration()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return duringPrepare ? 0 : displayKeys.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: assessmentDisplayCellID, for: indexPath) as! AssessmentDisplayCell
        var cellRiskType = riskTypeKey
        var cellRiskClass = riskClassKey
        
        if cellRiskType == nil {
            cellRiskType = displayKeys[indexPath.item]
        }
        
        if cellRiskClass == nil {
            cellRiskClass = displayKeys[indexPath.item]
        }
        
        cell.configureWithRiskType(cellRiskType!, riskClassKey: cellRiskClass!, showType: (riskTypeKey == nil), indexPath: indexPath)
        cell.cardIsSelected = showReviewAtIndexPath
        
        
        return cell
    }
    
    
    // background
    var topicPoint = CGPoint.zero
    var secondPoint = CGPoint(x: 100, y: 200)
    
    var duringPrepare = false {
        didSet{
            endFlag.isHidden = duringPrepare
            reloadData()
            setNeedsDisplay()
            
            if displayKeys.count == 1 {
               
            }
        }
    }
    
    override func draw(_ rect: CGRect) {
        if duringPrepare {
            return
        }
        
        super.draw(rect)
        
        let topLine = UIBezierPath()
        topLine.move(to: topicPoint)
        let turning = CGPoint(x: topicPoint.x, y: secondPoint.y)
        topLine.addCurve(to: secondPoint, controlPoint1: turning, controlPoint2: turning)
        UIColorFromHex(0x00C853).setStroke()
        topLine.lineWidth = 2 * fontFactor
        topLine.stroke()
    }
    
}


// data
extension AssessmentsCollectionView: BlockFlowDataSource {
    // default as 2
    func numberOfColsForLayout(_ layout: BlockFlowLayout) -> Int {
        return 1
    }
    
    func topMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0: return 53 * standHP
        case 1: return -60 * standHP
        case 2: return -16 * standHP
        default: return -15 * standHP
        }
    }
    
    func leftMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.item % 4 {
        case 0: return 246 * standWP
        case 1: return 40 * standWP
        case 2: return 252 * standWP
        case 3: return 25 * standWP
        default: return 45 * standWP
        }
    }
    
    func itemSizeAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125 * fontFactor, height: 131 * fontFactor)
    }
    
    // button and flag height
    func sectionEdgeInsetsForLayout(_ layout: BlockFlowLayout) -> UIEdgeInsets {
        let bottom = bottomLength + endFlag.frame.height + 70 * fontFactor
        return UIEdgeInsets(top: secondPoint.y, left: 0, bottom: bottom, right: 0)
    }
}

// collection view delegate
extension AssessmentsCollectionView: UICollectionViewDelegate {
    // selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       showReviewAtIndexPath(indexPath, cardIndex: 0)
    }
    
    fileprivate func showReviewAtIndexPath(_ indexPath: IndexPath, cardIndex: Int) {
        var cellRiskType = riskTypeKey
        var cellRiskClass = riskClassKey
        
        if cellRiskType == nil {
            cellRiskType = displayKeys[indexPath.item]
        }
        
        if cellRiskClass == nil {
            cellRiskClass = displayKeys[indexPath.item]
        }
        
        let played = MatchedCardsDisplayModel.getAllMatchedScoreCardsOfRiskClass(cellRiskClass!, riskTypeKey: cellRiskType!)
        var cards = [CardInfoObjModel]()
        for (_, all) in MatchedCardsDisplayModel.getHighLowClassifiedCards(played) {
            cards.append(contentsOf: all)
        }
        if cards.isEmpty {
            let alert = UIAlertController(title: "Not played", message: "You have not played", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "I see", style: .default, handler: nil)
            let playAction = UIAlertAction(title: "Go to Play", style: .default) { (action) in
                cardsCursor.selectedRiskClassKey = cellRiskClass!
                cardsCursor.riskTypeKey = cellRiskType!
                
                if cellRiskType == GameTintApplication.sharedTint.iCaKey {
                    GameTintApplication.sharedTint.focusingTierIndex = 0
                }else if cellRiskType == GameTintApplication.sharedTint.iPaKey {
                    GameTintApplication.sharedTint.focusingTierIndex = 1
                }else {
                    GameTintApplication.sharedTint.focusingTierIndex = 2
                }
                
                let tab = self.viewController.tabBarController
                tab?.selectedIndex = 0
                let navi = tab!.viewControllers![0] as! ABookNavigationController
                for vc in navi.viewControllers {
                    if vc.isKind(of: ABookLandingPageViewController.self) {
                        navi.popToViewController(vc, animated: true)
                        break
                    }
                }
                
                let intro = IntroPageViewController()
                navi.pushViewController(intro, animated: true)
            }
            alert.addAction(okAction)
            alert.addAction(playAction)
            viewController.present(alert, animated: true, completion: nil)
        }else {
            let reviewVC = PlayedCardsReviewViewController()
            reviewVC.loadWithCards(cards, index: cardIndex, withDistribution: true)
            viewController.presentOverCurrentViewController(reviewVC, completion: nil)
        }
    }
    
    // draw road after all data is set
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let endH = endFlag.frame.height * 0.6 + bottomLength
        let endPoint = CGPoint(x: 102 * standWP, y: contentSize.height - endH)
        // end
        let layout = collectionViewLayout as! BlockFlowLayout

        startPoint = secondPoint
        endFlag.center = endPoint
        
        // all read
        anchorInfo.removeAll()
        for attri in layout.attriArray {
            anchorInfo.append((CGPoint(x: attri.center.x, y: attri.center.y), false))
        }
        anchorInfo.append((endPoint, false))
    }
}

