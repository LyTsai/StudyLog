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
    var disabled = false {
        didSet{
            titleBackLayer.fillColor = disabled ? UIColor.lightGray.cgColor : UIColor.white.cgColor
            if disabled {
                boxImageView.image = UIImage(named: "box_disabled")
            }
            
            self.isUserInteractionEnabled = !disabled
        }
    }
    
    weak var roadView: WindingCategoryCollectionView!
    var currentIndex: Int = 0
    var categoryName = ""
    
    fileprivate let bonusTopView = UIImageView(image: UIImage(named: "category_bonus"))
    fileprivate let complementaryTopView = UIImageView(image: #imageLiteral(resourceName: "category_complementary"))
    fileprivate let boxImageView = UIImageView()
    
    fileprivate let titleBackLayer = CAShapeLayer()
    fileprivate let textView = UILabel()
//    fileprivate let textButton = UIButton()

    fileprivate var cardResultsCollectionView: CardResultsCollecionView!
    fileprivate let checkMark = UIImageView(image: ProjectImages.sharedImage.fullCheck)
    fileprivate let processView = CustomProcessView.setupWithProcessColor(UIColorFromRGB(80, green: 211, blue: 135))
    fileprivate let processLabel = UILabel()
    fileprivate var factorType: FactorType = .score
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
        titleBackLayer.fillColor = UIColor.white.cgColor
        titleBackLayer.masksToBounds = true
//        textButton.layer.masksToBounds = true
        
        // labels
        textView.backgroundColor = UIColor.clear
//        textView.bounces = false
//        textView.isSelectable = false
//        textView.isEditable = false
        textView.textAlignment = .center
//        textView.textContainerInset = UIEdgeInsets.zero
        textView.numberOfLines = 0
        
//        textButton.setTitle("⌃", for: .normal)
//        textButton.setTitle("⌄", for: .selected)
//        textButton.titleLabel?.numberOfLines = 0
//        textButton.setTitleColor(UIColor.white, for: .normal)
//        textButton.setTitleColor(UIColor.white, for: .selected)
//        textButton.addTarget(self, action: #selector(showOrHideText), for: .touchUpInside)
        
        processLabel.textAlignment = .center
        processLabel.textColor = UIColor.white
 
        // shadows
        boxImageView.layer.addBlackShadow(2)
        boxImageView.layer.shadowOpacity = 0.7

        processView.layer.addBlackShadow(1)
        processView.layer.shadowOffset = CGSize.zero
        processLabel.layer.addBlackShadow(1)
        processLabel.layer.shadowOffset = CGSize.zero
        
        // add
        contentView.addSubview(bonusTopView)
        contentView.addSubview(complementaryTopView)
        
        contentView.layer.addSublayer(titleBackLayer)
        contentView.addSubview(textView)
//        contentView.addSubview(textButton)
        contentView.addSubview(boxImageView)
        contentView.addSubview(processView)
        contentView.addSubview(processLabel)
        
        // swipe
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(checkNextCard))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(checkLastCard))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
        
        // collection
        cardResultsCollectionView = CardResultsCollecionView.createWithFrame(bounds, cards: [], mainColor: tabTintGreen)
        cardResultsCollectionView.cardIsSelected = selectCard
        contentView.addSubview(cardResultsCollectionView)
        
        // check
        contentView.addSubview(checkMark)
        checkMark.isHidden = true
    }
    
    fileprivate var closed = true {
        didSet{
            cardResultsCollectionView.isHidden = closed
            layoutSubviews()
        }
    }
    
    fileprivate var allAnswered = false {
        didSet{
            checkMark.isHidden = !allAnswered
        }
    }
    
    // 112 * 140
    fileprivate var textH: CGFloat = 0
    fileprivate var titleFrame = CGRect.zero
    fileprivate var marginX: CGFloat = 0
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let standP = min(bounds.width / 112, bounds.height / 140)
        // box image
        let boxSize = closed ? CGSize(width: 65 * standP, height: 55 * standP) : CGSize(width: 93 * standP, height: 60 * standP)
        boxImageView.frame = CGRect(x: bounds.midX - boxSize.width * 0.5, y: bounds.height - boxSize.height, width: boxSize.width, height: boxSize.height)
        // process
        processView.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - 7 * standP), width: 66 * standP, height: 9 * standP)
        processLabel.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - 15 * standP), width: 50 * standP, height: 14 * standP)
        processLabel.font = UIFont.systemFont(ofSize: 12 * standP, weight: .bold)
        
        // textView
        let topSize = CGSize(width: bounds.width - 5 * standP, height: 38 * standP)
        let titleCenterY = closed ? boxImageView.frame.minY - 16 * standP : topSize.height * 0.5
        let topFrame = CGRect(center: CGPoint(x: bounds.midX, y: titleCenterY), width: topSize.width, height: topSize.height)

        titleBackLayer.frame = topFrame
        titleBackLayer.cornerRadius = standP * 4
        titleBackLayer.borderWidth = standP
        titleBackLayer.lineWidth = 5 * standP
        
        marginX = 3 * standP
        textView.frame = topFrame.insetBy(dx: marginX, dy: marginX)
        textView.font = UIFont.systemFont(ofSize: 12 * standP, weight: .semibold)
//        calculteTitleH()
        
        titleFrame = textView.frame
        titleBackLayer.path = UIBezierPath(roundedRect: titleBackLayer.bounds, cornerRadius: standP * 2).cgPath
//        textButton.frame = CGRect(center: CGPoint(x: bounds.width - 7.5 * fontFactor, y: topFrame.maxY), length: 15 * standP)
//        textButton.titleLabel?.font = UIFont.systemFont(ofSize: 15 * standP, weight: .medium)
//        textButton.layer.cornerRadius = 7.5 * standP
        
        let bonusL = bounds.width * 0.5
        bonusTopView.frame = CGRect(x: bounds.midX - bonusL * 0.5, y: topFrame.minY, width: bonusL, height: bonusL)
        complementaryTopView.frame = CGRect(x: 0, y: topFrame.minY, width: bounds.width, height: bounds.width * 37 / 112)
        
        // cardView
        if !closed {
            // 50 * 37
            let resultSpace = bounds.height - boxSize.height * 0.65 - topFrame.maxY
            let cardDisplayFrame = CGRect(center: CGPoint(x: bounds.midX, y: topFrame.maxY + resultSpace * 0.5), width: resultSpace * 1.1, height: resultSpace * 0.92)
            cardResultsCollectionView.frame = cardDisplayFrame
            checkMark.frame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.height - 50 * standP), width: 50 * standP, height: 50 * standP)
        }
    }
    
//    fileprivate func calculteTitleH() {
//        textH = textView.layoutManager.usedRect(for: textView.textContainer).height
//        textButton.isHidden = (textH <= textView.frame.height)
//    }
    
    // cards
    fileprivate var allCards = [CardInfoObjModel]()
    fileprivate var playedCards = [CardInfoObjModel]()
    
    // action for arrow-buttons
    @objc func checkNextCard() {
        if allCards.isEmpty {
            return
        }
        
        if currentIndex != playedCards.count - 1 {
            currentIndex += 1
            showCardWithAnimation()
        }
    }
    
    @objc func checkLastCard() {
        if allCards.isEmpty {
            return
        }
        
        if currentIndex != 0 {
            currentIndex -= 1
            showCardWithAnimation()
        }
    }
    
    // transform ? flip??
    fileprivate func showCardWithAnimation() {
        cardResultsCollectionView.scrollToItem(at: IndexPath(item: currentIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    func selectCard(_ index: Int) {
        let resultVC = CategoryResultViewController()
        resultVC.setupWithCards(playedCards, categoryName: categoryName, desIndex: index)
        viewController.presentOverCurrentViewController(resultVC, completion: nil)
    }
}

// open func
extension CategoryBoxDisplayCell {
    func configureWithIndex(_ itemIndex: Int, title: String, playedCards: [CardInfoObjModel], allCards: [CardInfoObjModel], factorType: FactorType) {
        self.allCards = allCards
        self.playedCards = playedCards
        self.categoryName = title
        self.factorType = factorType
        
        let answeredNumber = playedCards.count
        let totalNumber = allCards.count
        closed = (answeredNumber == 0)
        allAnswered = (answeredNumber == totalNumber)
        
        currentIndex = 0 // first card
        
        // texts
        textView.text = title
        processLabel.text = "\(answeredNumber)/\(totalNumber)"
        processView.processVaule = CGFloat(answeredNumber) / CGFloat(totalNumber)
      
        // image of boxes
        let index = itemIndex % 6
        var color = boxColors[index]
        var boxImage = closed ? UIImage(named: "box_closed_\(index)") : UIImage(named: "box_open_\(index)")
//        textButton.backgroundColor = color
        
        switch factorType {
        case .bonus:
            color = boxColors[0]
            boxImageView.contentMode = .scaleAspectFit
            boxImage = #imageLiteral(resourceName: "box_bonus")
        case .complementary:
            color = boxColors[4]
            boxImageView.contentMode = .scaleAspectFit
            boxImage = #imageLiteral(resourceName: "box_c")
        default: break
        }
        
        bonusTopView.isHidden = (factorType != .bonus)
        complementaryTopView.isHidden = (factorType != .complementary)
        textView.isHidden = (factorType != .score)
        titleBackLayer.isHidden = (factorType != .score)
        
        boxImageView.image = boxImage
        titleBackLayer.strokeColor = color.cgColor
        
        // box is open
        if !closed {
            cardResultsCollectionView.mainColor = color
            
            var played = [CardInfoObjModel]()
            for play in playedCards {
                played.append(collection.getCard(play.key)!)
            }
            cardResultsCollectionView.reloadDataWithCards(played, factorType: factorType)
        }
        
        layoutSubviews()
    }

    // perpare for answering
    func openBox(_ itemIndex: Int) {
        if factorType == .score {
            boxImageView.image = UIImage(named: "box_half_\(itemIndex % 6)")
        }
    }
    
    @objc func showOrHideText(_ button: UIButton) {
        button.isSelected = !button.isSelected
        if button.isSelected {
            textView.frame = CGRect(x: textView.frame.minX, y: textView.frame.maxY - textH, width: textView.frame.width, height: textH)
        }else {
            textView.frame = titleFrame
        }
        
        let topFrame = textView.frame.insetBy(dx: -marginX, dy: -marginX)
        titleBackLayer.frame = topFrame
        titleBackLayer.path = UIBezierPath(roundedRect: titleBackLayer.bounds, cornerRadius: 4 * fontFactor).cgPath
    }
}
