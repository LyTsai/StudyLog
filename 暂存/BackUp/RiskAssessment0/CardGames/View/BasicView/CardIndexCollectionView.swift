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
    fileprivate var cardAnswers = [Int: Int]()
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
    fileprivate var bottomSpace: CGFloat = 0
    class func createWithFrame(_ frame: CGRect, bottomSpace: CGFloat) -> CardIndexCollectionView {
        let lineSpacing: CGFloat = 5
        let vMargin: CGFloat = 3
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.minimumInteritemSpacing = 100
        flowLayout.itemSize = CGSize(width: (frame.width - 2 * lineSpacing - 2 * vMargin) / 3, height: frame.height - vMargin)
        flowLayout.sectionInset = UIEdgeInsets(top: vMargin, left: vMargin, bottom: 0, right: vMargin)
        
        // create
        let collection = CardIndexCollectionView(frame: frame, collectionViewLayout: flowLayout)
        collection.backgroundColor = UIColor.clear
        collection.bottomSpace = bottomSpace
        collection.setAnswers()
        
        collection.register(CardIndexCell.self, forCellWithReuseIdentifier: cardIndexCellID)
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    fileprivate func setAnswers() {
        for i in 0..<cardsFactory.totalNumberOfItems() {
            let card = cardsFactory.getVCard(i)!
            let result = CardSelectionResults.cachedCardProcessingResults.getCurrentSelectionForCard(card.key)
            if result != nil {
                cardAnswers[i] = result!
            }
        }
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
            }, completion: { (true) in
//                let card = self.cardsFactory.getVCard(item)!
//                self.assessmentViewDelegate.controllerDelegate.titleForNavi = card.metric?.name ?? "Disease"
            })
        }
    }
    
    func setupAnswers(_ key: Int, value: Int)  {
        cardAnswers[key] = value
        
        // update current
        performBatchUpdates({
            self.reloadItems(at: [IndexPath(item: self.currentItem, section: 0)])
        }, completion: nil)
    }


}

extension CardIndexCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardsFactory.totalNumberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardIndexCellID, for: indexPath) as! CardIndexCell
        
        let card = cardsFactory.getVCard(indexPath.item)!
        
        let typeName = card.metric?.name ?? "choose between"
        let optionCount = (card.cardStyleKey == JudgementCardTemplateView.styleKey()) ? 1 : card.cardOptions.count
        let answerIndex = cardAnswers[indexPath.item] ?? -1
        var answerState = CardAnswerState.unanswered
        if cardAnswers.keys.contains(indexPath.item) {
            answerState = .answered
        }
        if indexPath.item == currentItem {
            answerState = .current
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
    fileprivate var answerState = CardAnswerState.unanswered
    func setupWithTypeName(_ typeName: String, answerIndex: Int, optionCount: Int, answerState: CardAnswerState)  {
        self.answerState = answerState
        textLabel.text = typeName
        textLabel.textColor = (answerState == .current ? UIColor.black : UIColorGray(155))
        backLayer.isHidden = (answerState != .current)
        indicatorView.resetData(answerIndex: answerIndex, optionCount: optionCount, answerState: answerState)
        
        // hide
//        textLabel.isHidden = (answerState == .current)
        indicatorView.isHidden = (answerState != .current)
        checkImageView.isHidden = (answerState != .answered)
        setNeedsLayout()
    }
    
    fileprivate let textLabel = UILabel()
    fileprivate var indicatorView: CardsIndicatorView!
    fileprivate let backLayer = CAGradientLayer()
    fileprivate let shadowLayer = CAShapeLayer()
    fileprivate let checkImageView = UIImageView(image: ProjectImages.sharedImage.roundCheck)
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
        shadowLayer.shadowColor = UIColorGray(178).cgColor
        
        // gradient
        backLayer.colors = [UIColorFromRGB(189, green: 143, blue: 48).cgColor, UIColorFromRGB(242, green: 234, blue: 181).cgColor, UIColorFromRGB(189, green: 143, blue: 49).cgColor]
        backLayer.locations = [0.05, 0.2, 0.8]
        backLayer.startPoint = CGPoint(x: 0, y: 0)
        backLayer.endPoint = CGPoint(x: 0, y: 1)
        backLayer.isHidden = true
        backLayer.borderColor = UIColorFromRGB(108, green: 81, blue: 27).cgColor
        
        // text
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 0
        textLabel.textColor = UIColor.black
        
        // dots
        indicatorView = CardsIndicatorView.createWithFrame(CGRect.zero, answerIndex: -1, optionCount: 0, answerState: .unanswered)
        
        // add
        contentView.layer.addSublayer(shadowLayer)
        contentView.layer.addSublayer(backLayer)
        contentView.addSubview(textLabel)
        contentView.addSubview(indicatorView)
        contentView.addSubview(checkImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = 2 * bounds.width / 115
        let checkLength = 10 * bounds.width / 115
        
        let mainFrame = (answerState == .current) ? bounds : CGRect(x: 0, y: margin, width: bounds.width, height: bounds.height * 0.78)
        backLayer.frame = mainFrame
        backLayer.borderWidth = (answerState == .current) ? margin : 0
        backLayer.cornerRadius = 2 * margin

        // check
        checkImageView.frame = CGRect(x: bounds.width - 1.2 * checkLength, y:  0.2 * checkLength, width: checkLength, height: checkLength)
        // shadow
        let path = UIBezierPath(roundedRect: mainFrame, cornerRadius: 2 * margin).cgPath
        shadowLayer.path = path
        shadowLayer.shadowPath = path

        // text and indicator
        let textHeight = (answerState == .current) ? bounds.height * 0.4 : mainFrame.height
        textLabel.frame =  CGRect(x: checkLength, y: mainFrame.minY, width: bounds.width - 2 * checkLength, height: textHeight)
        textLabel.font = UIFont.systemFont(ofSize: max(textHeight * 0.32, 8), weight: UIFontWeightSemibold)
        indicatorView.frame = CGRect(x: 0, y: textLabel.frame.maxY, width: bounds.width, height: bounds.height - textLabel.frame.maxY)
    }
}
