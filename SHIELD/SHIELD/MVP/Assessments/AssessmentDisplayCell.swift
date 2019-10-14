//
//  AssessmentDisplayCell.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/6.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

let assessmentDisplayCellID = "Assessment Display Cell identifier"
class AssessmentDisplayCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    var cardIsSelected: ((IndexPath, Int)->Void)?
    
    fileprivate let typeButton = CustomButton.usedAsRiskTypeButton("")
    fileprivate let metricButton = CustomButton.createBlackBorderButton()
    fileprivate var bottomCollectionView: UICollectionView!
    fileprivate let playTag = TagLabel.createTag()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
    }
    
    fileprivate func setupBasic() {
        let flowLayout = ScaleLayout()
        flowLayout.focusMiddle = false
        flowLayout.minRatio = 1
        
        typeButton.isUserInteractionEnabled = false
        metricButton.isUserInteractionEnabled = false
        
        bottomCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        bottomCollectionView.backgroundColor = UIColor.clear
        bottomCollectionView.register(CardResultImageCell.self, forCellWithReuseIdentifier: cardResultImageCellID)
        bottomCollectionView.dataSource = self
        bottomCollectionView.delegate = self
        bottomCollectionView.bounces = false
        
        contentView.addSubview(typeButton)
        contentView.addSubview(metricButton)
        contentView.addSubview(bottomCollectionView)
        contentView.addSubview(playTag)
    }
    
    fileprivate var isCard = true
    fileprivate var showAssess = true
    fileprivate var bottomKeys = [String]()
    // MARK: --------- assessment
    fileprivate var indexPath: IndexPath!
    func configureWithRiskType(_ riskTypeKey: String, riskClassKey: String, showType: Bool, indexPath: IndexPath) {
        self.indexPath = indexPath
        showAssess = true
        let cards = MatchedCardsDisplayModel.getAllMatchedScoreCardsOfRiskClass(riskClassKey, riskTypeKey: riskTypeKey)
        
        bottomCollectionView.reloadData()
        
        typeButton.isHidden = !showType
        metricButton.isHidden = showType
        let most = MatchedCardsDisplayModel.getNumberSortedClassifiedCards(cards).first?.iden
        let color = MatchedCardsDisplayModel.getColorOfIden(most)
        if showType {
            typeButton.setForRiskType(riskTypeKey)
            typeButton.changeRiskTypeButtonColor(color)
        }else {
            let metric = collection.getMetric(riskClassKey)
            metricButton.setupWithText(metric?.name, imageUrl: metric?.imageUrl)
            metricButton.backgroundColor = color
        }
        
        if cards.isEmpty {
            playTag.setToNone()
        }else {
            playTag.setToCheckTag()
            
            if let focusing = cardsCursor.focusingRiskKey {
                let risks = collection.getRiskModelKeys(riskClassKey, riskType: riskTypeKey)
                if risks.contains(focusing) {
                    playTag.setToLatestTag("Assessments")
                }
            }
        }
        
        isCard = true
        bottomKeys.removeAll()
        let sorted = MatchedCardsDisplayModel.getHighLowClassifiedCards(cards)
        for (_, cards) in sorted {
            for card in cards {
                bottomKeys.append(card.key)
            }
        }
        bottomCollectionView.reloadData()
    }
    
    func configureForMatchWithRiskType(_ riskTypeKey: String, riskClasses: [String], indexPath: IndexPath) {
        self.indexPath = indexPath
        
        showAssess = false
        typeButton.isHidden = false
        metricButton.isHidden = true
        typeButton.setForRiskType(riskTypeKey)
        
        isCard = false
        bottomKeys = riskClasses
        bottomCollectionView.reloadData()

        let cards = MatchedCardsDisplayModel.getAllMatchedScoreCardsOfRiskType(riskTypeKey, forUser: userCenter.currentGameTargetUser.Key())
        if cards.isEmpty {
            typeButton.changeRiskTypeButtonColor(UIColorGray(180))
            playTag.setToNone()
        }else {
            playTag.setToCheckTag()
        
            if cardsCursor.riskTypeKey == riskTypeKey {
                if let currentPlayed = cardsCursor.selectedRiskClassKey {
                    if riskClasses.contains(currentPlayed) {
                        playTag.setToLatestTag("Matches")
                    }
                }
            }
        }
    }
    
    // MARK: ---------  usedForMatch
    func configureForMatchWithRiskClass(_ metricKey: String, cards: [String], riskTypeKey: String, indexPath: IndexPath) {
        showAssess = false
        self.indexPath = indexPath
        typeButton.isHidden = true
        metricButton.isHidden = false
        
        let color = collection.getRiskTypeByKey(riskTypeKey)?.realColor ?? tabTintGreen
        let metric = collection.getMetric(metricKey)
        metricButton.setupWithText(metric?.name, imageUrl: metric?.imageUrl)
        metricButton.backgroundColor = color
        
        isCard = true
        bottomKeys = cards
        if cards.isEmpty {
            metricButton.backgroundColor = UIColorGray(180)
            playTag.setToNone()
        }else {
            playTag.setToCheckTag()
            if cardsCursor.riskTypeKey == riskTypeKey {
                if let currentPlayed = cardsCursor.selectedRiskClassKey {
                    if currentPlayed == metricKey {
                        playTag.setToLatestTag("Matches")
                    }
                }
            }
        }
        
        bottomCollectionView.reloadData()
    }
    
    // MARK: --------- layout
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let cardL = bounds.width / 3
        bottomCollectionView.frame = CGRect(x: 0, y: bounds.height - cardL, width: bounds.width, height: cardL)
        
        // 5 * 2
        let top = bounds.height * 30 / 128
        playTag.frame =  CGRect(center: CGPoint(x: bounds.midX, y: top * 0.5), width: top * 3, height: top)

        let topL = bounds.height - top * 0.8 - cardL
        let centerY = bounds.height - cardL - topL * 0.5
        typeButton.adjustRiskTypeButtonWithFrame(CGRect(center: CGPoint(x: bounds.midX, y: centerY), width: topL, height: topL / 62 * 53))
        metricButton.frame = CGRect(center: CGPoint(x: bounds.midX, y: centerY), length: topL)
        metricButton.adjustRoundBlackBorderButton()
    }
    
    // DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bottomKeys.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardResultImageCellID, for: indexPath) as! CardResultImageCell
        let current = bottomKeys[indexPath.item]
        if isCard {
            if let card = collection.getCard(current) {
                let color = showAssess ? MatchedCardsDisplayModel.getColorOfIden(card.currentIdentification()) : UIColor.cyan
                cell.configureWithCard(card, mainColor: color, factorType: .score)
            }
        }else {
            // riskClass
            if let riskClass = collection.getMetric(current) {
                let riskType = collection.getRiskTypeByKey(typeButton.key)
                cell.configureWithRoundImage(riskClass.imageUrl, mainColor: riskType?.realColor ?? tabTintGreen)
            }
        }
        
        cell.layer.addBlackShadow(1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! ScaleLayout
        let itemH = collectionView.bounds.height
        flowLayout.minimumLineSpacing = -itemH * 0.5
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: collectionView.bounds.width - itemH)
        return CGSize(width: itemH, height: itemH)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates({
            collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        }) { (true) in
            self.cardIsSelected?(self.indexPath, indexPath.item)
        }
    }
}
