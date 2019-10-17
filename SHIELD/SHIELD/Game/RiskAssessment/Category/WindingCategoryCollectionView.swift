//
//  WindingCategoryCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 2017/8/25.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// first view
class WindingCategoryCollectionView: WindingRoadCollectionView {
    weak var hostVC: UIViewController!
    var categories = [CategoryDisplayModel]() {
        didSet{
            playAllButton.isHidden = (categories.isEmpty)
        }
    }
    fileprivate var phqOn = true

    class func createWithFrame(_ frame: CGRect, categories: [CategoryDisplayModel]) -> WindingCategoryCollectionView {
        let layout = BlockFlowLayout()
        let categoryView = WindingCategoryCollectionView(frame: frame, collectionViewLayout: layout)
        categoryView.backgroundColor = UIColor.clear
        categoryView.categories = categories
        categoryView.bounces = false
        categoryView.contentInsetAdjustmentBehavior = .never
        
        // backImages
        categoryView.setupBackgroundImages()
        
        // data
        categoryView.register(CategoryBoxDisplayCell.self, forCellWithReuseIdentifier: categoryBoxCellID)
        
        // delegate
        layout.dataSource = categoryView
        categoryView.dataSource = categoryView
        categoryView.delegate = categoryView
        
        return categoryView
    }
    
    fileprivate let roadStartButton = GradientBackStrokeButton(type: .custom)
    var startFrame = CGRect.zero
    fileprivate let roadEndButton = GradientBackStrokeButton(type: .custom)
    fileprivate let roadEndDeco = UIImageView()
    fileprivate let playAllButton = UIButton(type: .custom)
    func setupBackgroundImages() {
        roadWidth = 30 * fontFactor
        turningRadius = 30 * fontFactor

        // first part road
        let startHeight = 44 * fontFactor
        startFrame = CGRect(x: 9 * fontFactor, y: 9 * fontFactor, width: 99 * fontFactor, height: startHeight)
        roadStartButton.frame = startFrame
        startPoint = CGPoint(x: startFrame.midX, y: startFrame.midY)
        
        playAllButton.frame = CGRect(x: startFrame.maxX + 8 * fontFactor, y: startFrame.minY, width: 74 / 47 * startHeight, height: startHeight)
        playAllButton.setBackgroundImage(#imageLiteral(resourceName: "category_playAll"), for: .normal)
        branchPoint = playAllButton.center
        
        setupButtonWithAnswerState()
        roadEndButton.setupWithTitle("Review")
        
        roadEndDeco.image = ProjectImages.sharedImage.roadFlag
        roadStartButton.isSelected = false
        // action
        // restart
        roadStartButton.addTarget(self, action: #selector(restartGame), for: .touchUpInside)
        // all
        playAllButton.addTarget(self, action: #selector(playAllCards), for: .touchUpInside)
        // save
        roadEndButton.addTarget(self, action: #selector(saveGame), for: .touchUpInside)
    
        // add
        addSubview(roadStartButton)
        addSubview(playAllButton)
        addSubview(roadEndDeco)
        addSubview(roadEndButton)
     
        // virtual or real
        WHATIF ? setForVirtual() : setForReal()
        roadStartButton.backgroundColor = WHATIF ? whatIfTintColor : baselineTintColor
        roadEndButton.backgroundColor = WHATIF ? whatIfTintColor : baselineTintColor
    }
    
    @objc func playAllCards() {
        if hostVC.isKind(of: CategoryViewController.self) {
            let categoryVC = self.hostVC as! CategoryViewController
            categoryVC.answerAll()
        }
    }
    
    // title image and updated category
    fileprivate var remindTimer: Timer!
    func updateCategoryUI() {
        var answered = 0
        var total = 0
        for (i, category) in categories.enumerated() {
            let changed = category.updateCurrentPlayStateData()
            answered += category.cardsPlayed.count
            total += category.cards.count
            
            if changed {
                // TODO: ------ if the answer is changed, the images on top should be changed too ……
                print(i)
            }
        }
       
        setupButtonWithAnswerState()
        
        // depression
        phqOn = true
        if let first = categories.first {
            if first.key == PHQ2Key {
                if first.cardsPlayed.count != first.cards.count {
                    phqOn = false
                }else {
                    var score: Float = 0
                    for card in first.cardsPlayed {
                        // score
                        if let chosenMatch = selectionResults.getMatchChosenByUser(userCenter.currentGameTargetUser.Key(), cardKey: card.key) {
                            // judgement
                            if let cScore = chosenMatch.score {
                                score += cScore
                            }
                        }
                    }
                    
                    if score < 3 {
                        let userKey = userCenter.currentGameTargetUser.Key()
                        let record = userDefaults.bool(forKey: "\(userKey)DepressionKeepOn")
                        if !record && (answered == first.cardsPlayed.count) {
                            phqOn = false
                            showDepressionAlert()
                            return
                        }
                    }
                }
            }
        }
        
        // all is loaded here
        reloadData()
        setNeedsDisplay()
        
        // remind of finish
        if MatchedCardsDisplayModel.currentAllScoreCardsPlayed() {
           showRemindOfReview()
        }else {
            if remindTimer != nil {
                remindTimer.invalidate()
                remindTimer = nil
            }
        }
    }
    
    fileprivate func setupButtonWithAnswerState() {
        let answered = MatchedCardsDisplayModel.riskIsCurrentPlayed()
        roadStartButton.setupWithTitle(answered ? "Restart" : "Start")
        roadStartButton.isSelected = !answered
        roadEndButton.isSelected = answered
    }
    
    fileprivate func showRemindOfReview() {
        performBatchUpdates({
            self.contentOffset = CGPoint(x: 0, y: max(self.contentSize.height - self.bounds.height, 0))
        }, completion: nil)
        
        if remindTimer == nil {
            remindTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { (timer) in
                let scaleT = CGAffineTransform(scaleX: 1.25, y: 1.25)
                let scaleTransform = (self.roadEndDeco.transform == .identity) ? scaleT : .identity
                self.roadEndDeco.transform = scaleTransform
                self.roadEndButton.transform = scaleTransform
            })
        }
    }
    
    fileprivate func showDepressionAlert() {
        let userKey = userCenter.currentGameTargetUser.Key()
        let allowAlert = UIAlertController(title: nil, message: "Your depression severity score is currently low and for now, you can choose to defer completing the game. To safeguard against future risks, do play the game periodically to track any changes", preferredStyle: .alert)
        let stopAction = UIAlertAction(title: "Stop", style: .cancel) { (action) in
            // assign all to zero
            for card in self.categories[1].cards {
                card.saveResult(nil, answerIndex: 0)
            }
            let _ = self.categories[1].updateCurrentPlayStateData()
            
            self.phqOn = true
            self.reloadData()
            self.setNeedsDisplay()
            self.showRemindOfReview()
            
            userDefaults.set(true, forKey: "\(userKey)DepressionKeepOn")
            userDefaults.synchronize()
            
            // scoreCard...
            
        }
        let continueAction = UIAlertAction(title: "Continue", style: .default) { (action) in
            self.phqOn = true
            self.reloadData()
            self.setNeedsDisplay()
            
            userDefaults.set(true, forKey: "\(userKey)DepressionKeepOn")
            userDefaults.synchronize()
        }
        allowAlert.addAction(stopAction)
        allowAlert.addAction(continueAction)
        
        hostVC.present(allowAlert, animated: true, completion: nil)
    }

    // restart
    @objc func restartGame()  {
        if !MatchedCardsDisplayModel.riskIsCurrentPlayed() {
            // start is on show
            collectionView(self, didSelectItemAt: IndexPath(item: 0, section: 0))

            return
        }
        
        let alert = UIAlertController(title: nil, message: "Do You Want to Clear all Answers and Restart", preferredStyle: .alert)
        let clear = UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
        selectionResults.clearAnswerForUser(userCenter.currentGameTargetUser.Key(), riskKey: cardsCursor.focusingRiskKey!)
            if self.hostVC.isKind(of: CategoryViewController.self) {
                let categoryVC = self.hostVC as! CategoryViewController
                categoryVC.checkDataAndReload()
            }
        })
        let giveUp = UIAlertAction(title: "No", style: .cancel, handler: nil)
        
        alert.addAction(clear)
        alert.addAction(giveUp)
        
        // alert
        hostVC.present(alert, animated: true, completion: nil)
    }
    
    // save
    @objc func saveGame() {
        if remindTimer != nil {
            remindTimer.invalidate()
            remindTimer = nil
            self.roadEndDeco.transform = .identity
            self.roadEndButton.transform = .identity
        }
        
        if self.hostVC.isKind(of: CategoryViewController.self) {
            let categoryVC = self.hostVC as! CategoryViewController
        
            // none is answered
            if !MatchedCardsDisplayModel.riskIsCurrentPlayed()  {
                let alert = CatCardAlertViewController()
                alert.addTitle("You have not played", subTitle: "You can start with opening one box or the \"START\" button", buttonInfo: [("Go to Play", true, nil)])
                hostVC.presentOverCurrentViewController(alert, completion: nil)
            }else {
                // save
                let summary = SummaryViewController()
                summary.forCart = false
                categoryVC.navigationController?.pushViewController(summary, animated: true)
            }
        }
    }
}

// collection view dataSource
extension WindingCategoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryBoxCellID, for: indexPath) as! CategoryBoxDisplayCell
        let category = categories[indexPath.item]
        let riskKey = cardsCursor.focusingRiskKey!
        
        var factorType = FactorType.score
        if category.cards.first!.isBonusCardInRisk(riskKey) {
            factorType = .bonus
        }else if category.cards.first!.isComplementaryCardInRisk(riskKey) {
            factorType = .complementary
        }
       
        cell.configureWithIndex(indexPath.item, title: category.name, playedCards: category.cardsPlayed, allCards: category.cards, factorType: factorType)
        cell.roadView = self
        cell.disabled = false
        
        // DEPRESSION
        if category.key == PHQ9Key && !phqOn {
            cell.disabled = true
        }
        
        return cell
    }
}

// blockDataSource
extension WindingCategoryCollectionView: BlockFlowDataSource {
    // default as 2
    func numberOfColsForLayout(_ layout: BlockFlowLayout) -> Int {
        return 2
    }
    
    func topMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0: return startFrame.maxY + 15 * fontFactor // startHeight
        case 1: return 137 * standHP
        case 2: return 15 * standHP
        case 3: return 20 * standHP
        case 4: return 18 * standHP
        default: return 25 * standHP
        }
    }
    
    func leftMarginOfItemAt(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.item % 5 {
        case 0: return 89 * standWP
        case 1: return 30 * standWP
        case 2: return 25 * standWP
        case 3: return 60 * standWP
        case 4: return 50 * standWP
        default: return 45 * standWP
        }
    }
    
    func itemSizeAtIndexPath(_ indexPath: IndexPath) -> CGSize {
        return CGSize(width: 112 * fontFactor, height: 140 * fontFactor)
    }
    
    // button and flag height
    func sectionEdgeInsetsForLayout(_ layout: BlockFlowLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: endHeight * 1.6, right: 0)
    }
}

// collection view delegate
extension WindingCategoryCollectionView: UICollectionViewDelegate {
    // selected
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.item]
        cardsCursor.focusingCategoryKey = category.key
        let _ = category.updateCurrentPlayStateData()
        
        // answered
        let cell = collectionView.cellForItem(at: indexPath) as! CategoryBoxDisplayCell
        if hostVC.isKind(of: CategoryViewController.self) {
            let categoryVC = hostVC as! CategoryViewController
            // all played
            if category.cardsPlayed.count == category.cards.count {
                categoryVC.showCategoryResult(category.cards, title: category.name, desIndex: cell.currentIndex)
            } else {
                // sort cards
                var unanswered = [CardInfoObjModel]()
                var answered = [CardInfoObjModel]()
                for card in category.cards {
                    if card.currentSelection() == nil {
                        unanswered.append(card)
                    }else {
                        answered.append(card)
                    }
                }
                answered.append(contentsOf: unanswered)
                
                // box is closed
                if category.cardsPlayed.isEmpty {
                    //first time
                    cell.openBox(indexPath.item)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                        let riskAssess = ABookRiskAssessmentViewController()
                        riskAssess.displayCards = answered
                        categoryVC.navigationController?.pushViewController(riskAssess, animated: true)
                    })
                }else {
                    let riskAssess = ABookRiskAssessmentViewController()
                    riskAssess.displayCards = answered
                    categoryVC.navigationController?.pushViewController(riskAssess, animated: true)
                }
            }
        }
    }

    

    // draw road after all data is set
    fileprivate var endHeight: CGFloat {
        return 88 * fontFactor
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        // end
        let endWidth = startFrame.width
        let layout = collectionViewLayout as! BlockFlowLayout
        let endFlagFrame = CGRect(x: endWidth * 1.5, y: contentSize.height - endHeight * 1.2, width: 88 * fontFactor, height: 88 * fontFactor)
        roadEndDeco.frame = endFlagFrame

        roadEndButton.frame = CGRect(x: endFlagFrame.midX - endWidth * 0.5, y: endFlagFrame.maxY - endHeight * 0.5, width: endWidth, height: startFrame.height)
        let endPoint = CGPoint(x: endFlagFrame.midX, y: endFlagFrame.minY + endHeight * 0.25)

        // all read
        anchorInfo.removeAll(
        )
        let attriArray = layout.attriArray
        var finished = 0
        for (i, attri) in attriArray.enumerated() {
            let category = categories[i]
            if category.cardsPlayed.count == category.cards.count {
                finished += 1
            }
            anchorInfo.append((CGPoint(x: attri.center.x, y: attri.center.y + attri.size.height * 0.25), category.cardsPlayed.count == category.cards.count))
        }
        // last flag, if all played, true
        anchorInfo.append((endPoint, finished == categories.count))
    }

}
