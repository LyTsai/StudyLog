//
//  SpinningMultipleChoicesCollectionView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/15.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

// class for spinning multople choice cards view SpinningMultipleChoiceCardsTemplateView

// ID for cell view
let cardCellID = "card Cell ID"

// collection cell view class.  each cell is a CardTemplateView (single) of the same risk factor (metric)
class CardTemplateViewCell: UICollectionViewCell {
    var showBaseline = false {
        didSet{
            singleCard.baseline.isHidden = !showBaseline
        }
    }
    var singleCard: JudgementCardTemplateView!
    var chooseButton = GradientBackStrokeButton(type: .custom)
    var leftButton = UIButton(type: .custom)
    var rightButton = UIButton(type: .custom)
    
    var onShow = false {
        didSet{
            if onShow {
                singleCard.beginToShow()
            }else {
                singleCard.endShow()
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    fileprivate func loadView() {
        // card
        singleCard = CardTemplateManager.sharedManager.createCardTemplateWithKey(JudgementCardTemplateView.styleKey(),frame:frame) as? JudgementCardTemplateView
        // buttons
        singleCard.leftButton.isHidden = true
        singleCard.rightButton.isHidden = true
        
        rightButton.setBackgroundImage(ProjectImages.sharedImage.mulitpleNext, for: .normal)
        leftButton.setBackgroundImage(ProjectImages.sharedImage.mulitpleLast, for: .normal)
        rightButton.setBackgroundImage(ProjectImages.sharedImage.mulitpleNextDisabled, for: .disabled)
        leftButton.setBackgroundImage(ProjectImages.sharedImage.mulitpleLastDisabled, for: .disabled)
        
        chooseButton.setupWithTitle("Choose")
        chooseButton.roundCorner = true
        chooseButton.isSelected = false
        
        // add
        contentView.addSubview(singleCard)
        singleCard.descriptionView.addSubview(chooseButton)
        singleCard.descriptionView.addSubview(leftButton)
        singleCard.descriptionView.addSubview(rightButton)
        
        // flip actions
        // contentView - singleCard(infoDetail - backImageView)
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(flipCard))
        singleCard.infoDetailView.addGestureRecognizer(tapGR)
        singleCard.flipButton.addTarget(self, action: #selector(flipCard), for: .touchUpInside)
    }
    
    @objc func flipCard() {
        // to show the changes, remove and modify later
        if singleCard.cardOnShow {
            UIView.transition(from: singleCard.descriptionView, to: singleCard.infoDetailView, duration: 0.5, options: .transitionFlipFromRight, completion: nil)
        }else {
            UIView.transition(from: singleCard.infoDetailView, to: singleCard.descriptionView, duration: 0.5, options: .transitionFlipFromLeft, completion: nil)
        }

        singleCard.cardOnShow = !singleCard.cardOnShow
    }
    
    // MARK: -------- layout
    override func layoutSubviews() {
        super.layoutSubviews()
        singleCard.frame = bounds
        singleCard.layoutSubviews()
        
        // buttons
        let plainView = singleCard.descriptionView
        let mainWidth = plainView.rimFrame.width - plainView.rimLineWidth
        let mainRect = CGRect(x:plainView.rimFrame.minX + plainView.rimLineWidth, y: plainView.rimFrame.maxY - plainView.bottomForMore - plainView.rimLineWidth, width: mainWidth, height: plainView.bottomForMore)
        
        let one = min(mainRect.height * 0.92 / 44, mainRect.width * 0.45 / 135)
        let chooseFrame = CGRect(center: CGPoint(x: mainRect.midX, y: mainRect.midY), width:135 * one, height: one * 44)
        chooseButton.frame = chooseFrame
        
        let arrowHeight = chooseFrame.height * 28 / 39
        let arrowWidth = arrowHeight / 37 * 51
        rightButton.frame = CGRect(center: CGPoint(x: chooseFrame.maxX + arrowWidth * 0.52, y: mainRect.midY), width: arrowWidth, height: arrowHeight)
        leftButton.frame = CGRect(center: CGPoint(x: chooseFrame.minX - arrowWidth * 0.52, y: mainRect.midY), width: arrowWidth, height: arrowHeight)
    }
    
    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        let circularlayoutAttributes = layoutAttributes as! CircularCollectionViewLayoutAttributes
        self.layer.anchorPoint = circularlayoutAttributes.anchorPoint
        self.center.y += (circularlayoutAttributes.anchorPoint.y - 0.5) * self.bounds.height
    }
}

// collection view based spinnig view for given array of cards (multiple choice cards of the same metric)
class MultipleChoiceCardsView: UICollectionView {
    var withDeco = false
    // CardTemplateView host
    weak var hostCardTemplateView: CardTemplateView!
    var chosenItem: Int = -1
    var currentItem = 0
    
    var baselineItem: Int = -1
    
    // create view
    class func createMultipleChoiceCardsView(_ frame: CGRect, hostView: CardTemplateView) -> MultipleChoiceCardsView {
        let circularLayout = CircularCollectionViewLayout()
        circularLayout.radius = 150 / CGFloat(sin(Double.pi / 12))
        circularLayout.itemSize = CGSize(width: 350, height: 350)
        circularLayout.overlap = 0.35
        
        // !!! at this point frame has value of (0, 0) and following code will not be executed. leave it here anyway.  the resize of view cell is at next fuction setFrame
        if frame.width > 0 && 0.8 * frame.width < circularLayout.itemSize.width {
            circularLayout.itemSize.width = CGFloat(Int(0.8 * frame.width)) + 1.0
        }
        if frame.height > 0 && 0.8 * frame.height < circularLayout.itemSize.height {
            circularLayout.itemSize.height = CGFloat(Int(0.8 * frame.height)) + 1.0
        }
        
        // create
        let wheelCollectionView = MultipleChoiceCardsView(frame: frame, collectionViewLayout: circularLayout)
        wheelCollectionView.hostCardTemplateView = hostView
        wheelCollectionView.setupBasic()
        
        return wheelCollectionView
    }
    
    fileprivate func setupBasic() {
        register(CardTemplateViewCell.self, forCellWithReuseIdentifier: cardCellID)
        // scroll
        isScrollEnabled = false
        
        dataSource = self
        
        backgroundColor = UIColor.clear
        indicatorStyle = .white
        
        // make for a more native feel that is closer to the UIScrollView.
        decelerationRate = UIScrollView.DecelerationRate.fast
        
        // swipe
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(cardIsSwiped(_:)))
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(cardIsSwiped(_:)))
        swipeLeft.direction = .left
        
        addGestureRecognizer(swipeRight)
        addGestureRecognizer(swipeLeft)
    }
    
    
    // resize the view
    func resetFrame(_ frame: CGRect) {
        self.frame = frame
 
        let circularLayout = self.collectionViewLayout as! CircularCollectionViewLayout
        circularLayout.itemSize = hostCardTemplateView.cardFrame.size
        self.collectionViewLayout.invalidateLayout()
    }
}

extension MultipleChoiceCardsView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the number of items in the given section
        if (hostCardTemplateView.vCard == nil || (hostCardTemplateView.vCard?.getDisplayOptions().isEmpty)!){
            return 3
        }
        return hostCardTemplateView.vCard!.getDisplayOptions().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardCellID, for: indexPath) as! CardTemplateViewCell
        configureCell(cell, atIndexPath: indexPath)
        cell.showBaseline = (indexPath.item == baselineItem)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: CardTemplateViewCell, atIndexPath indexPath: IndexPath) {
        if indexPath.item == 0 {
            cell.leftButton.isEnabled = false
        }else if indexPath.item == numberOfItems(inSection: indexPath.section) - 1 {
            cell.rightButton.isEnabled = false
        }
        
        cell.chooseButton.tag = indexPath.item + 100
        cell.leftButton.tag = indexPath.item + 200
        cell.rightButton.tag = indexPath.item + 300
        cell.singleCard.flipButton.tag = indexPath.item + 400
        cell.chooseButton.backgroundColor = WHATIF ? whatIfTintColor : baselineTintColor
        cell.chooseButton.addTarget(self, action: #selector(chosenAsAnswer(_:)), for: .touchUpInside)
        cell.rightButton.addTarget(self, action: #selector(goToNextOption(_:)), for: .touchUpInside)
        cell.leftButton.addTarget(self, action: #selector(goBackToLastOption(_:)), for: .touchUpInside)
        
        let options = hostCardTemplateView.vCard!.getDisplayOptions()
        cell.singleCard.withPrompt = (hostCardTemplateView.key() != SpinningMultipleChoiceCardsTemplateView.styleKey())
        cell.singleCard.setCardContent(hostCardTemplateView.vCard!, defaultSelection: options[indexPath.item])
 
        // choose state
        if indexPath.item == chosenItem {
            cell.chooseButton.isSelected = true
            cell.singleCard.descriptionView.isChosen = true
        }
        // hostView for calling back
        cell.singleCard.hostView = hostCardTemplateView.hostView
    }
}

