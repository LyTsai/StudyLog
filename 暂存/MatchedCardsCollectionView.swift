//
//  MatchedCardsCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/16.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
// MARK: ------------ cell ----------------
let matchedCardsCellID = "matched cards cell identifier"
class MatchedCardsCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate let card = CardTemplateManager.sharedManager.createCardTemplateWithKey(JudgementCardTemplateView.styleKey(), frame: CGRect.zero) as! JudgementCardTemplateView
    fileprivate func updateUI() {
        card.confirmButton.isHidden = true
        card.denyButton.isHidden = true
//        card.flipButton.isHidden = true
        
        contentView.addSubview(card)
    }
    
    // configure cell
    func setupWithValue(_ valueObj: MeasurementValueObjModel!, cardStyleKey: String, withAssessment: Bool)  {
        let match = AIDMetricCardsCollection.standardCollection.getMatch(valueObj.matchKey)
        if match == nil {
            print("no match info")
            return
        }
        
        card.descriptionView.title = match!.info ?? ""
        card.descriptionView.prompt = match!.statement ?? ""
        card.descriptionView.mainImage = match!.imageObj
        card.descriptionView.side = match!.name ?? ""
        
        if cardStyleKey == JudgementCardTemplateView.styleKey() {
            card.descriptionView.title = valueObj.value == 1 ? "Yes" : "No"
        }
        
        if withAssessment {
            // TODO: --------- set with color
            let greenImage = UIImage(named: "assessment_green")
            let yellowImage = UIImage(named: "assessment_yellow")
                
            let color = match!.classification?.realColor
            
            print("assessment color is \(color)")
            
            card.backImageView.image =  arc4random() % 2 == 0 ? greenImage : yellowImage

        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        card.frame = bounds
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
    
}

// MARK: ------------ collection view -------------------
class MatchedCardsCollectionView: UICollectionView {

    fileprivate var withAssessment = false
    
    fileprivate var resultOfCards = [(match: MeasurementValueObjModel, cardStyleKey: String)]()
    
    class func createWithFrame(_ frame: CGRect, risks: [RiskObjModel], withAssessment: Bool) -> MatchedCardsCollectionView {
        // layout
        let circularLayout = CircularCollectionViewLayout()
        circularLayout.overlap = 0.35
        circularLayout.itemSize = CGSize(width: frame.width * 0.9, height: frame.height * 0.9)
        
        // create
        let collection = MatchedCardsCollectionView(frame: frame, collectionViewLayout: circularLayout)
        collection.backgroundColor = UIColor.clear
        collection.withAssessment = withAssessment
        collection.setupDataWithRisks(risks)
        
        collection.register(MatchedCardsCell.self, forCellWithReuseIdentifier: matchedCardsCellID)
        
        // delegate
        collection.dataSource = collection
        
        return collection
    }
    
    
    // create data
    fileprivate func setupDataWithRisks(_ risks: [RiskObjModel]) {
        resultOfCards.removeAll()
        
        for risk in risks {
            let values = valuesOfRisk(risk)
            for value in values {
                // arrange with color ???
                resultOfCards.append((value, cardStyleKeyOfRisk(risk)))
            }

        }
    }
    
    fileprivate func valuesOfRisk(_ risk: RiskObjModel) -> [MeasurementValueObjModel] {
        let measurement = MatchedCardsData.getMeasurementsForCurrentUserOfRisk(risk.key)
        if measurement == nil {
            return []
        }
        
        return measurement!.values
    }
    
    
    fileprivate func cardStyleKeyOfRisk(_ risk: RiskObjModel) -> String {
        let deckOfCards = AIDMetricCardsCollection.standardCollection.getMetricCardOfRisk(risk.key)
        return deckOfCards.first?.cardStyleKey ?? ""
    }
}

extension MatchedCardsCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultOfCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: matchedCardsCellID, for: indexPath) as! MatchedCardsCell
        let result = resultOfCards[indexPath.item]
        
        cell.setupWithValue(result.match, cardStyleKey: result.cardStyleKey, withAssessment: withAssessment)

        return cell
    }
}
