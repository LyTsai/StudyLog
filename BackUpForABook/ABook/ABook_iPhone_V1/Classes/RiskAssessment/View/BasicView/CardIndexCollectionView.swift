//
//  CardIndexCollectionView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/31.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
enum CardAnswerState {
    case answered, current, unanswered
}

// MARK: -------- overall indexes ----------------
class CardIndexCollectionView: UICollectionView {
    /** cardInex: answer */
    var cardAnswers = [Int: Int]() {
        didSet{
            // TODO: ----------- or just change collection for it
            // update current
            performBatchUpdates({ 
                self.reloadItems(at: [IndexPath(item: self.currentItem, section: 0)])
            }, completion: nil)
        }
    }
    var currentItem: Int = 0
    var cursorItem: Int = 0 {
        didSet{
            performBatchUpdates({
                self.reloadItems(at: [IndexPath(item: self.currentItem, section: 0)])
            }, completion: nil)
        }
    }
    
    weak var assessmentViewDelegate: AssessmentTopView!
    
    fileprivate let cardsFactory = VDeckOfCardsFactory.metricDeckOfCards
    class func createWithFrame(_ frame: CGRect) -> CardIndexCollectionView {
        let lineSpacing: CGFloat = 6
        let vMargin: CGFloat = 4
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.minimumInteritemSpacing = 100
        flowLayout.itemSize = CGSize(width: (frame.width - 2 * lineSpacing - 2 * vMargin) / 3, height: frame.height - 3 * vMargin)
        flowLayout.sectionInset = UIEdgeInsets(top: vMargin, left: vMargin, bottom: 2 * vMargin, right: vMargin)
        
        let collection = CardIndexCollectionView(frame: frame, collectionViewLayout: flowLayout)
        collection.backgroundColor = UIColor.clear
        
        collection.register(CardIndexCell.self, forCellWithReuseIdentifier: cardIndexCellID)
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    func focusOnItem(_ item: Int)  {
        if currentItem != item {
            let oldFocusIndexPath = IndexPath(item: currentItem, section: 0)
            currentItem = item
            cursorItem = 0 // reload currentIndexPath here
            let currentFocusIndexPath = IndexPath(item: currentItem, section: 0)

            performBatchUpdates({
                self.reloadItems(at: [oldFocusIndexPath])
                self.scrollToItem(at: currentFocusIndexPath, at: .centeredHorizontally, animated: true)
                self.assessmentViewDelegate.setupMaskPath(self.cardAnswers[item] ?? -1)
            }, completion: nil)
        }
    }
}

extension CardIndexCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsFactory.totalNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardIndexCellID, for: indexPath) as! CardIndexCell
        
        let card = cardsFactory.getVCard(indexPath.item)!
        
        var title = card.metric?.name ?? "choose between"
        if title == "Universal" {
            title = card.title!
        }
        var typeName = title
        let optionCount = (card.cardStyleKey == JudgementCardTemplateView.styleKey()) ? 2 : card.cardOptions.count
        let answerIndex = cardAnswers[indexPath.item] ?? -1
        var answerState = CardAnswerState.unanswered
        if cardAnswers.keys.contains(indexPath.item) {
            answerState = .answered
        }
        if indexPath.item == currentItem {
            answerState = .current
            typeName = (card.cardStyleKey == JudgementCardTemplateView.styleKey()) ? "Yes/No" : "Multi-Choice"
        }
        
        cell.cursorIndex = cursorItem
        cell.setupWithTypeName(typeName, answerIndex: answerIndex, optionCount: optionCount, answerState: answerState)
        
        return cell
    }
}

extension CardIndexCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // cards
        assessmentViewDelegate.goToCard(indexPath.item)
    }
}


// MARK: ----------------- cell
let cardIndexCellID = "card index cell identifier"
class CardIndexCell: UICollectionViewCell {
    var cursorIndex:Int = 0 {
        didSet{
            indicatorView.cursorIndex = cursorIndex
        }
    }
    
    func setupWithTypeName(_ typeName: String, answerIndex: Int, optionCount: Int, answerState: CardAnswerState)  {
        textLabel.text = typeName
        textLabel.textColor = (answerState == .current ? UIColor.black : UIColorGray(155))
        backLayer.isHidden = (answerState != .current)
        indicatorView.resetData(answerIndex: answerIndex, optionCount: optionCount, answerState: answerState)
    }
    
    fileprivate let textLabel = UILabel()
    fileprivate var indicatorView: CardsIndicatorView!
    fileprivate let backLayer = CAGradientLayer()
    fileprivate let shadowLayer = CAShapeLayer()
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUI()
    }
    
    fileprivate func updateUI() {
        // shadow
        shadowLayer.shadowOffset = CGSize(width: 0, height: 1)
        shadowLayer.shadowRadius = 2
        shadowLayer.shadowOpacity = 0.9
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.black.cgColor
        
        // gradient
        backLayer.colors = [UIColorFromRGB(184, green: 236, blue: 81).cgColor, UIColorFromRGB(66, green: 147, blue: 33).cgColor]
        backLayer.locations = [0.2, 0.8]
        backLayer.startPoint = CGPoint(x: 0, y: 0)
        backLayer.endPoint = CGPoint(x: 0, y: 1)
        backLayer.isHidden = true
        
        // text
        textLabel.textAlignment = .center
//        textLabel.numberOfLines = 0
        
        // dots
        indicatorView = CardsIndicatorView.createWithFrame(CGRect.zero, answerIndex: -1, optionCount: 0, answerState: .unanswered)
        
        // add
        contentView.layer.addSublayer(shadowLayer)
        contentView.layer.addSublayer(backLayer)
        contentView.addSubview(textLabel)
        contentView.addSubview(indicatorView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backLayer.frame = bounds
        backLayer.cornerRadius = 4
        
        let path = UIBezierPath(roundedRect: bounds, cornerRadius: 4).cgPath
        shadowLayer.path = path
        shadowLayer.shadowPath = path
        
        let gap = bounds.height * 0.03
        let labelHeight = bounds.height * 0.27
        
        textLabel.frame = CGRect(x: 4, y: gap, width: bounds.width - 8, height: labelHeight)
        textLabel.font = UIFont.systemFont(ofSize: labelHeight * 0.9, weight: UIFontWeightSemibold)
        indicatorView.frame = CGRect(x: 4, y: labelHeight + gap, width: bounds.width - 8, height: bounds.height - labelHeight - gap)
    }
}
