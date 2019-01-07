//
//  CategoryBoxDisplayCell.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/10/20.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

let categoryBoxCellID = "category box cell identifier"
let boxColors = [UIColorFromRGB(0, green: 158, blue: 235),
                          UIColorFromRGB(54, green: 78, blue: 228),
                          UIColorFromRGB(216, green: 49, blue: 45),
                          UIColorFromRGB(185, green: 4, blue: 227),
                          UIColorFromRGB(66, green: 147, blue: 33),
                          UIColorFromRGB(255, green: 171, blue: 0)]

class CategoryBoxDisplayCell: UICollectionViewCell {
    weak var roadView: WindingCategoryCollectionView!
    var categoryName = ""
    var currentIndex: Int = 0 {
        didSet{
            indiLeftButton.isHidden = (currentIndex == 0 || closed)
            indiRightButton.isHidden = (currentIndex == playedCards.count - 1 || closed)
        }
    }
    
    fileprivate let boxImageView = UIImageView()
    fileprivate let titleBackLayer = CAGradientLayer()
    fileprivate let titleLabel = UILabel()
//    fileprivate let cardImageView = UIImageView()
    fileprivate let remainsImageView = UIImageView(image: UIImage(named: "box_remains"))
    fileprivate let indiLeftButton = UIButton(type: .custom)
    fileprivate let indiRightButton = UIButton(type: .custom)
    fileprivate var cardResultsCollectionView: CardResultsCollecionView!
    fileprivate let checkMark = UIImageView(image: ProjectImages.sharedImage.fullCheck)
    
    fileprivate let processView = CustomProcessView.setupWithProcessColor(UIColorFromRGB(80, green: 211, blue: 135))
    fileprivate let processLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupUI()
    }
    
    fileprivate func setupUI() {
        // layer setup
        titleBackLayer.colors = [UIColor.clear.cgColor, UIColorGray(204).withAlphaComponent(0.4).cgColor, UIColor.clear.cgColor]
        titleBackLayer.locations = [0.6, 0.9, 0.95]
        titleLabel.layer.borderColor = UIColor.black.cgColor
        titleLabel.layer.masksToBounds = true

        // labels
        titleLabel.backgroundColor = UIColor.white
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        processLabel.textAlignment = .center
        processLabel.textColor = UIColor.white
        
        // imageViews
//        boxImageView.contentMode = .scaleAspectFit
        
        // buttons(?)
        indiLeftButton.setBackgroundImage(UIImage(named: "leftIndi"), for: .normal)
        indiRightButton.setBackgroundImage(UIImage(named: "rightIndi"), for: .normal)
        indiRightButton.addTarget(self, action: #selector(checkNextCard), for: .touchUpInside)
        indiLeftButton.addTarget(self, action: #selector(checkLastCard), for: .touchUpInside)
        
        // shadows
        contentView.layer.addBlackShadow(2)
        contentView.layer.shadowOpacity = 0.7

        processView.layer.addBlackShadow(1)
        processView.layer.shadowOffset = CGSize.zero
        processLabel.layer.addBlackShadow(1)
        processLabel.layer.shadowOffset = CGSize.zero
        
        // add
        contentView.addSubview(boxImageView)
//        contentView.layer.addSublayer(titleBackLayer)
        contentView.addSubview(titleLabel)
        titleLabel.layer.addSublayer(titleBackLayer)
        
        contentView.addSubview(checkMark)
        contentView.addSubview(processView)
        contentView.addSubview(processLabel)
     
        
        // open
        // added on box
        contentView.addSubview(remainsImageView)
       
        checkMark.isHidden = true
//        contentView.addSubview(cardImageView)
        contentView.addSubview(indiLeftButton)
        contentView.addSubview(indiRightButton)
        
        // swipe
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(checkNextCard))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(checkLastCard))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
        
        // collection
        cardResultsCollectionView = CardResultsCollecionView.createWithFrame(bounds, cards: [], mainColor: tabTintGreen)
        cardResultsCollectionView.boxView = self
        contentView.addSubview(cardResultsCollectionView)
    }
    
    fileprivate var closed = true {
        didSet{
//            cardImageView.isHidden = closed
            indiLeftButton.isHidden = closed
            indiRightButton.isHidden = closed
            remainsImageView.isHidden = (allAnswered || closed)
            cardResultsCollectionView.isHidden = closed
            
            layoutSubviews()
        }
    }
    
    fileprivate var allAnswered = false {
        didSet{
            remainsImageView.isHidden = (allAnswered || closed)
            checkMark.isHidden = !allAnswered
        }
    }
    
    // 115 * 155
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let standP = min(bounds.width / 115, bounds.height / 155)
        
        // box image
        let boxSize = closed ? CGSize(width: 70 * standP, height: 80 * standP) : CGSize(width: 104 * standP, height: 87 * standP)
        boxImageView.frame = CGRect(x: bounds.midX - boxSize.width * 0.5, y: bounds.height - boxSize.height, width: boxSize.width, height: boxSize.height)
        // process
        processView.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - 4 * standP), width: 70 * standP, height: 7 * standP)
        processLabel.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - 9 * standP), width: 50 * standP, height: 14 * standP)
        processLabel.font = UIFont.systemFont(ofSize: 12 * standP, weight: UIFontWeightBold)
        
        // titleLabel
        let topSize = CGSize(width: bounds.width, height: 38 * standP)
        let titleCenterY = closed ? boxImageView.frame.minY - 5 * standP : topSize.height * 0.5
        let topFrame = CGRect(center: CGPoint(x: bounds.midX, y: titleCenterY), width: topSize.width, height: topSize.height)
        titleLabel.layer.borderWidth = standP
        titleLabel.layer.cornerRadius = topSize.height * 0.5
        titleLabel.frame = topFrame
        titleLabel.font = UIFont.systemFont(ofSize: 12 * standP, weight: UIFontWeightBold)
        
        titleBackLayer.borderWidth = standP * 4
        titleBackLayer.frame = titleLabel.bounds
        titleBackLayer.cornerRadius = topSize.height * 0.5
        
        // cardView
        if !closed {
            // 50 * 37
            remainsImageView.frame = CGRect(center: CGPoint(x: bounds.midX, y:  bounds.height - boxSize.height * 0.65), width: 50 * standP, height: 31 * standP)
            let resultSpace = bounds.height - boxSize.height * 0.65 - topFrame.maxY
            let cardDisplayFrame = CGRect(center: CGPoint(x: bounds.midX, y: topFrame.maxY + resultSpace * 0.5), width: resultSpace * 1.1, height: resultSpace * 0.92)
            cardResultsCollectionView.frame = cardDisplayFrame
            
            // indi, 15 * 16
            let indiSize = CGSize(width: 15 * standP, height: 16 * standP)
            indiLeftButton.frame = CGRect(center: CGPoint(x: cardDisplayFrame.minX - indiSize.width * 0.8, y: cardDisplayFrame.midY), width: indiSize.width, height: indiSize.height)
            indiRightButton.frame = CGRect(center: CGPoint(x: cardDisplayFrame.maxX + indiSize.width * 0.8, y: cardDisplayFrame.midY), width: indiSize.width, height: indiSize.height)
            checkMark.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - 30 * standP), width: 50 * standP, height: 50 * standP)
        }
    }
    
    // cards
    fileprivate var allCards = [CardInfoObjModel]()
    fileprivate var playedCards = [String]()
    
    // action for arrow-buttons
    func checkNextCard() {
        if currentIndex != playedCards.count - 1 {
            currentIndex += 1
            showCardWithAnimation()
        }
    }
    
    func checkLastCard() {
        if currentIndex != 0 {
            currentIndex -= 1
            showCardWithAnimation()
        }
    }
    
    // transform ? flip??
    fileprivate func showCardWithAnimation() {
        cardResultsCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
//        let offsetY = boxImageView.frame.midY - cardImageView.frame.midY
//        let card = AIDMetricCardsCollection.standardCollection.getCard(playedCards[currentIndex])!
//        UIView.animate(withDuration: 0.35, animations: {
//            let translate = CGAffineTransform(translationX: 0, y: offsetY)
//            let addRotation = translate.rotated(by: CGFloat(Double.pi))
//            let addScale = addRotation.scaledBy(x: 0.15, y: 0.15)
//            self.cardImageView.transform = addScale
//            self.cardImageView.alpha = 0.2
//        }) { (true) in
//            MatchedCardsDisplayModel.setupMatchedImageForCard(card, on: self.cardImageView)
//            // animation back
//            UIView.animate(withDuration: 0.3, animations: {
//                self.cardImageView.transform = CGAffineTransform.identity
//                self.cardImageView.alpha = 1
//            })
//        }
    }
}

// open func
extension CategoryBoxDisplayCell {
    func configureWithIndex(_ itemIndex: Int, title: String, playedCards: [String], allCards: [CardInfoObjModel]) {
        self.allCards = allCards
        self.playedCards = playedCards
        self.categoryName = title
        
        let answeredNumber = playedCards.count
        let totalNumber = allCards.count
        closed = (answeredNumber == 0)
        allAnswered = (answeredNumber == totalNumber)
        
        currentIndex = 0 // first card
        
        titleLabel.text = title
        processLabel.text = "\(answeredNumber)/\(totalNumber)"
        processView.processVaule = CGFloat(answeredNumber) / CGFloat(totalNumber)
        
        let index = itemIndex % 6
        let color = boxColors[index]
        let boxImage = closed ? UIImage(named: "box_closed_\(index)") : UIImage(named: "box_open_\(index)")
        
        boxImageView.image = boxImage
        titleBackLayer.borderColor = color.cgColor
        
        if !closed {
            cardResultsCollectionView.mainColor = color
            
            var played = [CardInfoObjModel]()
            for play in playedCards {
                played.append(AIDMetricCardsCollection.standardCollection.getCard(play)!)
            }
            cardResultsCollectionView.cards = played
            if playedCards.count == 1 {
                indiRightButton.isHidden = true
            }
    
            // card image
//            cardImageView.layer.borderColor = color.cgColor
//            let first = AIDMetricCardsCollection.standardCollection.getCard(playedCards.first!)!
//            MatchedCardsDisplayModel.setupMatchedImageForCard(first, on: cardImageView)
        }
    }

    // perpare for answering
    func openBox(_ itemIndex: Int) {
        closed = false // for layout changes
        boxImageView.image = UIImage(named: "box_open_\(itemIndex % 6)")
        cardResultsCollectionView.isHidden = true
        
//        cardImageView.isHidden = true
        indiLeftButton.isHidden = true
        indiRightButton.isHidden = true
    }
}
