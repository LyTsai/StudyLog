//
//  SpinningCardTemplateView.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 12/5/16.
//  Copyright © 2016 LyTsai. All rights reserved.
//

import Foundation

// class for spinning multople choice cards view SpinningMultipleChoiceCardsTemplateView

// ID for cell view
let cardCellID = "card Cell ID"

// collection cell view class.  each cell is a CardTemplateView (single) of the same risk factor (metric)
class CardTemplateViewCell: UICollectionViewCell {
    var singleCard = UIView()

    fileprivate var styleKey = CardTemplateManager.defaultCardStyleKey
    func setupCard(_ styleKey: String) {
        backgroundColor = UIColor.clear

        if styleKey == self.styleKey {
            return
        }
        singleCard.removeFromSuperview()
        
        if styleKey == SelectCardTemplateView.styleKey() {
            // no buttons
            singleCard = PlainCardView.createWithText("no", prompt: "", side: "", image: nil)
        }else if (styleKey == SpinningMultipleChoiceCardsTemplateView.styleKey()) {
            // judgement card with two buttons for selection
            singleCard = CardTemplateManager.sharedManager.createCardTemplateWithKey(JudgementCardTemplateView.styleKey(),frame:frame) as! JudgementCardTemplateView
        }else {
            print("no such card")
        }

        contentView.addSubview(singleCard)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        singleCard.frame = bounds
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
    
    // CardTemplateView host
    weak var hostCardTemplateView: CardTemplateView!
    var chosenItem: Int = -1 {
        didSet {
            if chosenItem != oldValue {
                UIView.performWithoutAnimation {
                    // TODO: -------------------- a bad way...
                    if oldValue != -1 {
                        let oldIndexPath = IndexPath(item: oldValue, section: 0)
                        let oldCell = cellForItem(at: oldIndexPath) as! CardTemplateViewCell

                        // button state
                        if oldCell.singleCard.isKind(of: JudgementCardTemplateView.self) {
                            let judgement = oldCell.singleCard as! JudgementCardTemplateView
                            judgement.confirmButton.isSelected = false
                            judgement.backImageView.image = judgement.backImages.normal
                        }
                    }
                }
            }
        }
    }
    
    // create view
    class func createMultipleChoiceCardsView(_ frame: CGRect, hostView: CardTemplateView) -> MultipleChoiceCardsView {
        let circularLayout = CircularCollectionViewLayout()
        circularLayout.radius = 150 / CGFloat(sin(M_PI / 12))
        circularLayout.itemSize = CGSize(width: 350, height: 350)
        circularLayout.overlap = 0.35
        
        // !!! at this point frame has value of (0, 0) and following code will not be executed. leave it here anyway.  the resize of view cell is at next fuction setFrame
        if frame.width > 0 && 0.8 * frame.width < circularLayout.itemSize.width {
            circularLayout.itemSize.width = CGFloat(Int(0.8 * frame.width)) + 1.0
        }
        if frame.height > 0 && 0.8 * frame.height < circularLayout.itemSize.height {
            circularLayout.itemSize.height = CGFloat(Int(0.8 * frame.height)) + 1.0
        }

        let wheelCollectionView = MultipleChoiceCardsView(frame: frame, collectionViewLayout: circularLayout)
        wheelCollectionView.register(CardTemplateViewCell.self, forCellWithReuseIdentifier: cardCellID)
        
        wheelCollectionView.dataSource = wheelCollectionView
        wheelCollectionView.delegate = wheelCollectionView
        
        wheelCollectionView.backgroundColor = UIColor.clear
        wheelCollectionView.indicatorStyle = .white
        
        wheelCollectionView.hostCardTemplateView = hostView
        
        // make for a more native feel that is closer to the UIScrollView.
        wheelCollectionView.decelerationRate = UIScrollViewDecelerationRateFast
        
        return wheelCollectionView
    }
    
    // resize the view
    override var frame: CGRect {
        didSet {
            if self.collectionViewLayout == nil {
                return
            }
            
            // set the cell view size here
            let circularLayout = self.collectionViewLayout as! CircularCollectionViewLayout
            circularLayout.itemSize.width = CGFloat(Int(0.85 * bounds.width)) + 1.0
            circularLayout.itemSize.height = bounds.height * 0.9 // indicator exists
            
            self.collectionViewLayout.invalidateLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

extension MultipleChoiceCardsView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // return the number of items in the given section
        if (hostCardTemplateView.vCard == nil || (hostCardTemplateView.vCard?.cardOptions.isEmpty)!){
            return 3
        }
        return hostCardTemplateView.vCard!.cardOptions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cardCellID, for: indexPath) as! CardTemplateViewCell
        if (hostCardTemplateView.vCard == nil || hostCardTemplateView.vCard?.cardOptions == nil){
            for subview in cell.contentView.subviews{
                subview.removeFromSuperview()
            }
            
            let singleCard = CardTemplateManager.sharedManager.createCardTemplateWithKey(JudgementCardTemplateView.styleKey(),frame:cell.bounds)
            cell.singleCard = singleCard
            
            cell.contentView.addSubview(cell.singleCard)
            return cell
        }
        configureCell(cell, atIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: CardTemplateViewCell, atIndexPath indexPath: IndexPath) {
 
        cell.setupCard(hostCardTemplateView.key())
        // attache card content
        if cell.singleCard.isKind(of: JudgementCardTemplateView.self) {
            let judgement = cell.singleCard as! JudgementCardTemplateView
//            judgement.backImages = backImagesStyle0
        
            judgement.confirmButton.tag = indexPath.item + 100
            judgement.denyButton.tag = indexPath.item + 200
            judgement.flipButton.tag = indexPath.item + 300
            
            judgement.confirmButton.addTarget(self, action: #selector(chosenAsAnswer(_:)), for: .touchUpInside)
            judgement.denyButton.addTarget(self, action: #selector(goToNextOption(_:)), for: .touchUpInside)
            judgement.flipButton.addTarget(self, action: #selector(flipItem(_:)), for: .touchUpInside)
            
            judgement.setCardContent(hostCardTemplateView.vCard!, defaultSelection: hostCardTemplateView.vCard!.cardOptions[indexPath.row])
            // hostView for calling back
            judgement.hostView = hostCardTemplateView.hostView
        }else if cell.singleCard.isKind(of: PlainCardView.self){
            let plain = cell.singleCard as! PlainCardView
            let option = hostCardTemplateView.vCard!.cardOptions[indexPath.row]
            
            plain.setupWithText(option.match?.info, prompt: option.match?.statement, side: "", image: convertDataObjectToImage( option.match?.imageObj))
        }
     }
    
}

extension MultipleChoiceCardsView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // setup the metric selection value and call host
        chosenItem = indexPath.item
    }
    
}

// spinning card view for multiple choice selection cards of same risk factor
class SpinningMultipleChoiceCardsTemplateView : CardTemplateView {
    override func key() -> String {
        return SpinningMultipleChoiceCardsTemplateView.styleKey()
    }
    
    class func styleKey()->String {
        return "4094702e-bb0c-11e6-a4a6-cec0c932ce01"
    }
    
    // called within init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBasic()
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupBasic()
        loadView()
    }
    
    // resize the view
    override var frame: CGRect {
        didSet {
            if multipleChoiceCards != nil {
                multipleChoiceCards.frame = self.bounds
            }
        }
    }
    
    // data
    override func setCardContent(_ card: CardInfoObjModel, defaultSelection: CardOptionObjModel?) {
        super.setCardContent(card, defaultSelection: defaultSelection)
        // setup the collection view
    }
    
    var multipleChoiceCards: MultipleChoiceCardsView!
    
    fileprivate func loadView() {
        backImageView.removeFromSuperview()
        multipleChoiceCards = MultipleChoiceCardsView.createMultipleChoiceCardsView(self.bounds, hostView: self)
        self.addSubview(multipleChoiceCards)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        multipleChoiceCards.frame = self.bounds
    }
}