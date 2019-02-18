//
//  CategorySelectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/16.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CategorySelectionView: UIView {
    weak var hostVC: ABookRiskAssessmentViewController!
    var playState = [String: [String]]() {
        didSet{
            categoryCollection.playState = playState
            checkButton(playState)
        }
    }
    
    class func createWithFrame(_ frame: CGRect, playState: [String: [String]]) -> CategorySelectionView {
        let categoryView = CategorySelectionView(frame: frame)
        categoryView.updateUIWithPlayState(playState)
        return categoryView
    }
    
    fileprivate let titleLabel = UILabel()
    fileprivate var categoryCollection: CategoryCollectionView!
    fileprivate let selectAll = UIButton(type: .custom)
    fileprivate let finishButton = UIButton.customRectNormalButton("EXIT")
    fileprivate var totalNumber: Int {
        let riskKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey!
        let allCards = AIDMetricCardsCollection.standardCollection.getMetricCardOfRisk(riskKey)
        return allCards.count
    }
    
    func updateUIWithPlayState(_ playState: [String: [String]]) {
        if playState.count == 0 {
            // no data
            return
        }
        
        let topSpace = bounds.height * 108 / 533
        let hMargin = bounds.width * 10 / 355
        let mainWidth = bounds.width - 2 * hMargin
        
        // title image
        // "teacher_left"
        let imageFrame = CGRect(x: hMargin * 0.5, y: 1.5 * hMargin, width: topSpace * 0.7, height: topSpace - 2 * hMargin)
        let titleImageView = UIImageView(image: UIImage(named: "teacher_left"))
        titleImageView.contentMode = .scaleAspectFit
        titleImageView.frame = imageFrame
        
        titleLabel.frame = CGRect(x: imageFrame.maxX, y: hMargin * 0.5, width: mainWidth - imageFrame.width, height: topSpace - 1.5 * hMargin)
        titleLabel.numberOfLines = 0
        titleLabel.text = "Please Choose a\n Category"
        
//        "IRA: Individualized Risk Assessment -\nRisk assessment is vital to guide decision making for primary prevention."

        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: (topSpace - 1.5 * hMargin) * 0.2, weight: UIFontWeightSemibold)
        
        addSubview(titleImageView)
        addSubview(titleLabel)
        
        // collection
        let collectionFrame = CGRect(x: hMargin, y: topSpace - hMargin, width: mainWidth, height: bounds.height - 2 * topSpace + hMargin)
        categoryCollection = CategoryCollectionView.createWithFrame(collectionFrame, playState: playState)
        categoryCollection.hostView = self
        addSubview(categoryCollection)
        
        // buttons
        // all
        selectAll.frame = CGRect(x: hMargin, y: collectionFrame.maxY + hMargin * 0.4, width: mainWidth, height: topSpace * 0.34)
        selectAll.setTitle("Select All (total: \(totalNumber)) >", for: .normal)
        selectAll.backgroundColor = UIColorFromRGB(80, green: 211, blue: 135)
        selectAll.titleLabel?.font = UIFont.systemFont(ofSize: topSpace * 0.13, weight: UIFontWeightSemibold)
        selectAll.layer.borderColor = UIColorFromRGB(0, green: 142, blue: 59).cgColor
        selectAll.layer.borderWidth = 2
        selectAll.layer.cornerRadius = topSpace * 0.17
        selectAll.layer.masksToBounds = true
        addSubview(selectAll)
        // exit
        let remained = bounds.height - selectAll.frame.maxY -  2 * hMargin
        finishButton.adjustNormalButton(CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - hMargin - remained * 0.5), width: bounds.width * 0.35, height: remained * 0.9))
        finishButton.titleLabel?.font = UIFont.systemFont(ofSize: remained * 0.45, weight: UIFontWeightBold)
        addSubview(finishButton)
        checkButton(playState)
        
        // actions
        selectAll.addTarget(self, action: #selector(playAllGames), for: .touchUpInside)
        finishButton.addTarget(self, action: #selector(finishCurrentGame), for: .touchUpInside)
        
        self.playState = playState
        
        
        //TEST!!!!!!!!
        let tap = UITapGestureRecognizer(target: self, action: #selector(gotoRoad))
        titleImageView.isUserInteractionEnabled = true
    titleImageView.addGestureRecognizer(tap)
    }
    
    func gotoRoad() {
        let vc = CategoryViewController()
        hostVC.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func checkButton(_ playState: [String: [String]]) {
        var answered: Int = 0
        
        for (_, value) in playState {
            answered += value.count
        }
        finishButton.isHidden = (answered == 0)
        if answered != 0 {
            selectAll.setTitle("Select All (\(answered)/\(totalNumber)) >", for: .normal)
            titleLabel.text = "\"Some Cards are played,\n you can check cards in cart or keep playing\""
        }else {
            selectAll.setTitle("Select All (total: \(totalNumber)) >", for: .normal)
            titleLabel.text = "Please Choose a\n Category"
        }
    }
    
    func playAllGames() {
        // all cards
        let riskKey = RiskMetricCardsCursor.sharedCursor.focusingRiskKey!
        let allCards = AIDMetricCardsCollection.standardCollection.getMetricCardOfRisk(riskKey)
        VDeckOfCardsFactory.metricDeckOfCards.attachCategoryCards(allCards)
        hostVC.showCategory = false
    }
    
    func finishCurrentGame() {
        // all cards
        hostVC.showIndividualSummary()
    }
}
