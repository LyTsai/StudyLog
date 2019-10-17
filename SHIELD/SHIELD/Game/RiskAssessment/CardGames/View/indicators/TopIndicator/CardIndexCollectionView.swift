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
    var allCards = [CardInfoObjModel]() {
        didSet{
            reloadData()
        }
    }
    class func createWithFrame(_ frame: CGRect) -> CardIndexCollectionView {
        let lineSpacing: CGFloat = 5
        let vMargin: CGFloat = 3
        
        // layout
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = lineSpacing
        flowLayout.minimumInteritemSpacing = 100
        flowLayout.itemSize = CGSize(width: (frame.width - 2 * lineSpacing - 2 * vMargin) / 3, height: frame.height - vMargin)
        flowLayout.sectionInset = UIEdgeInsets(top: vMargin, left: vMargin + flowLayout.itemSize.width, bottom: 0, right: vMargin + flowLayout.itemSize.width)
        
        // create
        let collection = CardIndexCollectionView(frame: frame, collectionViewLayout: flowLayout)
        collection.backgroundColor = UIColor.clear
        collection.showsHorizontalScrollIndicator = false
        collection.setAnswers()
        
        collection.register(CardIndexCell.self, forCellWithReuseIdentifier: cardIndexCellID)
        collection.dataSource = collection
        collection.delegate = collection
        
        return collection
    }
    
    fileprivate func setAnswers() {
        for (i, card) in allCards.enumerated() {
            if let result = card.currentSelection() {
                cardAnswers[i] = result
            }
        }
    }
    
    func focusOnItem(_ item: Int)  {
        if currentItem != item {
            let currentFocusIndexPath = IndexPath(item: item, section: 0)
            let oldFocusIndexPath = IndexPath(item: currentItem, section: 0)
            
            currentItem = item
            cursorItem = 0 // reload currentIndexPath here
            
            performBatchUpdates({
                self.reloadItems(at: [oldFocusIndexPath])
                self.scrollToItem(at: currentFocusIndexPath, at: .centeredHorizontally, animated: true)
                self.assessmentViewDelegate.setupMaskPath(self.cardAnswers[item] ?? -1)
            }, completion: { (true) in
            
            })
        }
    }
    
    func setupAnswers(_ key: Int, value: Int)  {
        cardAnswers[key] = value
        
        // update current
        performBatchUpdates({
            if let cell = self.cellForItem(at: IndexPath(item: self.currentItem, section: 0)) as? CardIndexCell {
                cell.indicatorView.answerIndex = value
                cell.indicatorView.reloadData()
            }else {
                self.reloadItems(at: [IndexPath(item: self.currentItem, section: 0)])
            }
        }, completion: nil)
    }
}

extension CardIndexCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allCards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardIndexCellID, for: indexPath) as! CardIndexCell
    
        let card = allCards[indexPath.item]
        
        let textOnShow = card.title ?? "choose between"
        let optionCount = card.isJudgementCard() ? 1 : card.getDisplayOptions().count
        let answerIndex = cardAnswers[indexPath.item] ?? -1
        var answerState = CardAnswerState.unanswered
        if cardAnswers.keys.contains(indexPath.item) {
            answerState = .answered
        }
        if indexPath.item == currentItem {
            answerState = .current
        }
        
        cell.cursorIndex = cursorItem
        cell.setupWithTypeName(textOnShow, answerIndex: answerIndex, optionCount: optionCount, answerState: answerState)
        
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
    fileprivate var optionCount: Int = 3

    func setupWithTypeName(_ typeName: String, answerIndex: Int, optionCount: Int, answerState: CardAnswerState)  {
        self.answerState = answerState
        titleTextView.text = typeName
        titleTextView.textColor = (answerState == .current ? UIColor.black : UIColorGray(155))
        chosenLayer.isHidden = (answerState != .current)
        borderLayer.isHidden = (answerState != .current)
        shadowLayer.isHidden = (answerState == .current)
        indicatorView.resetData(answerIndex: answerIndex, optionCount: optionCount, answerState: answerState)
        self.optionCount = optionCount
        
        // hide
        indicatorView.isHidden = (answerState != .current)
        checkImageView.isHidden = (answerState != .answered)
        setNeedsLayout()
        
       
        if titleTextView.needScroll {
            if answerState == .current {
                titleTextView.startTimer()
            }else {
                titleTextView.stopScroll()
            }
        }
    }
    
    fileprivate let titleTextView = AutoScrollTextView()
    var indicatorView: CardsIndicatorView!
    fileprivate let chosenLayer = CAGradientLayer() // for chosen item
    fileprivate let maskLayer = CAShapeLayer() // mask of chosen cell
    fileprivate let borderLayer = CAShapeLayer()
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
        chosenLayer.colors = [UIColorFromRGB(189, green: 143, blue: 48).cgColor, UIColorFromRGB(242, green: 234, blue: 181).cgColor, UIColorFromRGB(189, green: 143, blue: 49).cgColor]
        chosenLayer.locations = [0.05, 0.2, 0.6]
        chosenLayer.startPoint = CGPoint(x: 0, y: 0)
        chosenLayer.endPoint = CGPoint(x: 0, y: 1)
        chosenLayer.isHidden = true
        chosenLayer.mask = maskLayer
        
        // border for chosen
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = UIColorFromRGB(108, green: 81, blue: 27).cgColor
        borderLayer.lineWidth = 2.5 * fontFactor
        
        // dots
        indicatorView = CardsIndicatorView.createWithFrame(CGRect.zero, answerIndex: -1, optionCount: 0, answerState: .unanswered)
        
        // add
        contentView.layer.addSublayer(shadowLayer)
        contentView.layer.addSublayer(chosenLayer)
        contentView.layer.addSublayer(borderLayer)
        
        contentView.addSubview(titleTextView)
        contentView.addSubview(indicatorView)
        contentView.addSubview(checkImageView)
    }
    
    // layout, 0.6
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let margin = 2 * bounds.width / 115
        let checkLength = 10 * bounds.width / 115
        let mainFrame = (answerState == .current) ? bounds : CGRect(x: 0, y: margin, width: bounds.width, height: bounds.height * 0.51)

        // check
        checkImageView.frame = CGRect(x: bounds.width - 1.2 * checkLength, y:  0.2 * checkLength, width: checkLength, height: checkLength)
        // shadow
        let path = UIBezierPath(roundedRect: mainFrame, cornerRadius: 2 * margin).cgPath
        shadowLayer.path = path
        shadowLayer.shadowPath = path

        // text and indicator
        let textHeight = (answerState == .current) ? bounds.height * 0.4 : mainFrame.height
        let bottomHeight = mainFrame.height * 0.18
        let titleFrame = CGRect(x: checkLength, y: mainFrame.minY, width: bounds.width - 2 * checkLength, height: textHeight)
        titleTextView.setupWithBounding(titleFrame, shrink: false)
        titleTextView.font = UIFont.systemFont(ofSize: max(textHeight * 0.35, 9 * fontFactor), weight: .semibold)
        indicatorView.frame = CGRect(x: 0, y: titleTextView.frame.maxY, width: bounds.width, height: bounds.height - titleTextView.frame.maxY - bottomHeight)
        
        // set mask
        chosenLayer.frame = mainFrame
        
        let xOffset = bottomHeight * 0.8
        let bottomY = mainFrame.height - bottomHeight
        var baseX: CGFloat = 0
        if optionCount == 2 {
            baseX = bounds.midX
        }else {
            let itemWidth = bounds.width / CGFloat(optionCount)
            baseX = itemWidth * 0.5 + itemWidth * CGFloat(cursorIndex)
        }
        
        // path
        let radius = 2 * margin
        let maskPath = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: -CGFloat(Double.pi / 2), endAngle: CGFloat(Double.pi), clockwise: false)
        maskPath.addLine(to: CGPoint(x: 0, y: bottomY - radius))
        maskPath.addArc(withCenter: CGPoint(x: radius, y: bottomY - radius), radius: radius, startAngle: CGFloat(Double.pi), endAngle: CGFloat(Double.pi / 2), clockwise: false)
        maskPath.addLine(to: CGPoint(x: baseX - xOffset, y: bottomY))
        maskPath.addLine(to: CGPoint(x: baseX, y: mainFrame.maxY))
        maskPath.addLine(to: CGPoint(x: baseX + xOffset, y: bottomY))
        maskPath.addLine(to: CGPoint(x: mainFrame.maxX - radius, y: bottomY))
        maskPath.addArc(withCenter: CGPoint(x: mainFrame.maxX - radius, y: bottomY - radius), radius: radius, startAngle: CGFloat(Double.pi) / 2, endAngle: 0, clockwise: false)
        maskPath.addLine(to: CGPoint(x: mainFrame.maxX, y: radius))
        maskPath.addArc(withCenter: CGPoint(x: mainFrame.maxX - radius, y: radius), radius: radius, startAngle: 0, endAngle: -CGFloat(Double.pi) / 2, clockwise: false)
        
        maskPath.close()
        
        maskLayer.path = maskPath.cgPath
        borderLayer.path = maskPath.cgPath
    }
}
