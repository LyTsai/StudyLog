//
//  AssessmentTopView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/10/31.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit

// expected from AssessmentTopView for receving events from card template view and card host view such as WheelOfCardsCollectionView, CardsContainerView and VerticalFlowView etc
protocol CardNotificationProtocol {
    // data input has been made
    // if value is nil, take as skip
    func onValueSet(_ value: Double?)
    // user asks to skip a card for input
//    func moveToNextCard()
    // moving onto a new metric card
    func onFocusingOnMetric(_ card: CardInfoObjModel?)
    // hit the end of card list (as result of user forcing over the end)
    func onEnd()
    // hit the beginning of card list (as result of user forcing over the beginning)
    func onBegin()
    
    func setupIndicator(_ item: Int)
}

// AssessmentTopView: AssessmentModelView navigation view over [User][riskClasses][RiskObjModel]
// MARK: ------------------ risk assessment view -----------------
// class
class AssessmentTopView: UIView, CardNotificationProtocol {
    var cardIndexCollection: CardIndexCollectionView!
    var cartCenter = CGPoint(x: 300, y: 40)
    weak var controllerDelegate: ABookRiskAssessmentViewController!
    
    fileprivate var headerHeight: CGFloat {
        return 59 * bounds.height / 667
    }
    fileprivate var topMargin: CGFloat {
        return 8 * bounds.height / 667
    }
    
    fileprivate let cardsViewType = RiskMetricCardsCursor.sharedCursor.getRiskClassCardsViewType()
    fileprivate let factory = VDeckOfCardsFactory.metricDeckOfCards
    //////////////////////////////////////////////////////////////////////////////
    // views for presenting the data input cards.  this is the card "working" area
    // only one view can be visible at any given time
    //////////////////////////////////////////////////////////////////////////////
    // stack view.  deck of cards style
    var stackView: TemplateCardContainer!

    // wheel of card view.  wheel of cards
    var wheelCardsView: WheelOfCardsCollectionView!
    
    // vertical flow collection view.  3 x 3 card for each row
    var verticalFlowView: VerticalFlowView!
    
    // table view of card collection.  each row: icon + card name, card options (with user current selection highlighted)
    var tableView: UITableView!
    

    // methods

    // ---------------- init ------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateUIAndData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateUIAndData()
    }
    
    func updateDisplayedCards() {
        if cardIndexCollection != nil {
            cardIndexCollection.removeFromSuperview()
        }
        createHeader()
        
        // show metricDeckOfCards
        switch cardsViewType {
        case .StackView: stackView.showDeckOfCards()
        case .WheelOfCards: wheelCardsView.showDeckOfCards()
        default: break
        }
    
        setupMaskPath(-1)
//        
//        let card = factory.getVCard(0)!
//        controllerDelegate.titleForNavi = card.metric?.name ?? "Disease"
    }
    
    fileprivate let maskLayer = CAShapeLayer()
    fileprivate func updateUIAndData() {
        let cardBackImage = UIImageView(image: ProjectImages.sharedImage.backImage)
        cardBackImage.layer.mask = maskLayer
        maskLayer.path = UIBezierPath(rect: bounds).cgPath
        cardBackImage.frame = bounds
        addSubview(cardBackImage)
        
        // create views ready for use in the card view area
        createAllCardViews()
    }
    
    fileprivate func createHeader() {
        let headerFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: headerHeight))
        cardIndexCollection = CardIndexCollectionView.createWithFrame(headerFrame, bottomSpace: topMargin)
        cardIndexCollection.assessmentViewDelegate = self
        addSubview(cardIndexCollection)
        
        sendSubview(toBack: cardIndexCollection)
    }

    fileprivate func createAllCardViews()  {
        let cardsViewFrame = CGRect(x: 0, y: headerHeight + topMargin, width: bounds.width, height: bounds.height - headerHeight - topMargin)
        
        // Stack
        stackView = TemplateCardContainer(frame: cardsViewFrame)
        stackView.assessmentTopDelegate = self
        stackView.backgroundColor = UIColor.clear
        addSubview(stackView)
        
        // wheel
        wheelCardsView = WheelOfCardsCollectionView.createWheelCollectionView(cardsViewFrame)
        wheelCardsView.topDelegate = self
        addSubview(wheelCardsView)
        
        // table
        tableView = UITableView(frame: cardsViewFrame, style: .plain)
        //tableView.assessmentTopDelegate = self
        addSubview(tableView)
        
        // VerticalFlow
        verticalFlowView = VerticalFlowView.createViewWithFrame(cardsViewFrame, interitemSpacing: 5, lineSpacing: 5, adjustHeight: 0)
        addSubview(verticalFlowView)
//        verticalFlowView.assessmentTopDelegate = self
        
        // hide or show
        wheelCardsView.isHidden = (cardsViewType == .WheelOfCards ? false : true)
        verticalFlowView.isHidden = (cardsViewType == .VerticalFlow ? false : true)
        stackView.isHidden = (cardsViewType == .StackView ? false : true)
        tableView.isHidden = (cardsViewType == .TableView ? false : true)
    }

    // MARK: ----------- up arrow -----------------
    // set arrow
    func setupMaskPath(_ optionIndex: Int) {
        let total = cardIndexCollection.numberOfItems(inSection: 0)
        
        if total == 0 {
            print("no card, no need to add mask")
            maskLayer.path = UIBezierPath(rect: bounds).cgPath
            return
        }
        
        // collection view info
        var item = cardIndexCollection.currentItem
        var number = 0
        // keep the item in center
        cardIndexCollection.scrollToItem(at: IndexPath(item: item, section: 0), at: .centeredHorizontally, animated: true)
        
        let layout = cardIndexCollection.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = layout.itemSize.width
        var baseX: CGFloat = 0
        
        // card info
        let card = factory.getVCard(item)!
        let isJudgement = (card.cardStyleKey == JudgementCardTemplateView.styleKey())
        
        // base X
        // if the number is less than 3
        if total == 2 {
            if item == 1 {
                // template use for it
                item = 3
            }
        }
        
        if item == 0 {
            print("at the beginning")
            baseX = cardIndexCollection.frame.minX + layout.sectionInset.left
        }else if item == total - 1 {
            print("at the end")
            baseX = cardIndexCollection.frame.maxX - itemWidth - layout.sectionInset.right
        } else {
            baseX = cardIndexCollection.frame.minX + layout.sectionInset.left + itemWidth + layout.minimumLineSpacing
        }
        
        if isJudgement {
            number = 1
            baseX += itemWidth * 0.5
        } else {
            // mulitiple
            number = card.cardOptions.count
            let oneBase = itemWidth / CGFloat(number)
            if optionIndex >= 0 && optionIndex < number {
                baseX += oneBase * (0.5 + CGFloat(optionIndex))
            }else {
                // init state, to the first one
                baseX += oneBase * 0.5
            }
        }
        
        // path
        let topY = headerHeight - topMargin * 0.5
        let bottomY = headerHeight + topMargin * 0.95
        let xOffset = topMargin * 1.5
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: bottomY, width: bounds.width, height: bounds.height - topMargin))
        path.move(to: CGPoint(x: baseX - xOffset, y: bottomY))
        path.addLine(to: CGPoint(x: baseX, y: topY))
        path.addLine(to: CGPoint(x: baseX + xOffset, y: bottomY))
        
        maskLayer.path = path.cgPath
        
        // cursor
        if optionIndex < 0 || optionIndex >= number {
            cardIndexCollection.cursorItem = 0
        }else {
            cardIndexCollection.cursorItem = optionIndex
        }
    }
    
    // navigate to risk model of risk class
    // riskKey - selected risk model of riskClassKey risk class
    fileprivate let userDefaults = UserDefaults.standard
    
    func restartCurrentGame() {
        switch cardsViewType {
        case .StackView: stackView.getBackToFirstCard()
        case .TableView: break
        case .VerticalFlow: break
        case .WheelOfCards: wheelCardsView.contentOffset = CGPoint.zero
        }
        
        cardIndexCollection.focusOnItem(0)
    }
    
    func goToCard(_ cardIndex: Int) {
        switch cardsViewType {
        case .StackView: stackView.goToCard(cardIndex)
        case .TableView: break
        case .VerticalFlow: break
        case .WheelOfCards: wheelCardsView.contentOffset = CGPoint.zero
        }
        
        cardIndexCollection.focusOnItem(cardIndex)
    }
    
    func updateStackViewWithCards() {
        stackView.showDeckOfCards()
        
        // if the welcome is not shown
        cardsGuide()
    }
    
    func cardsGuide() {
        let userDefaults = UserDefaults.standard
        let stackjudgementKey = "stack judgement card showed"
        let stackMultipleChoiceKey = "stack MultipleChoice card showed"
            
       
        if factory.totalNumberOfItems() != 0 {
            let oneCard = factory.getVCard(0)
            let alert = AssessGuideAlertController()
            
            if oneCard?.cardStyleKey == JudgementCardTemplateView.styleKey() && userDefaults.object(forKey: stackjudgementKey) == nil {
                alert.useJudgementGuide()
                
                userDefaults.set(true, forKey: stackjudgementKey)
                userDefaults.synchronize()
                controllerDelegate.present(alert, animated: true, completion: nil)
            }else if oneCard?.cardStyleKey == SpinningMultipleChoiceCardsTemplateView.styleKey() && userDefaults.object(forKey: stackMultipleChoiceKey) == nil  {
                alert.useStackMultipleGuide()
                
                userDefaults.set(true, forKey: stackMultipleChoiceKey)
                userDefaults.synchronize()
                controllerDelegate.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func updateTableViewWithCards() {
        
    }
    func updateVerticalFlowViewWithCards() {
        verticalFlowView.showDeckOfCards()
    }
    func updateWheelViewWithCards() {
        wheelCardsView.showDeckOfCards()
    }

    ///////////////////////////////////////////////////////////////////
    // CardNotificationProtocol
    // data input has been made
    // if value is nil, skip the card
    func onValueSet(_ value: Double?) {
        // !!! check the condition for saving ethe result.  for now, save immediatly
        switch cardsViewType {
        case .WheelOfCards: wheelCardsView.scrollCard()
        case .StackView:
            if value == nil {
                stackView.skipCurrentCard()
            }else {
                stackView.answerCurrentCard(cartCenter)
            }
        default: break
        }
        // move the indicator
        let item = stackView.currentCardIndex
        cardIndexCollection.focusOnItem(item)
    }

    // choose answer
    func setupIndicator(_ item: Int) {
        switch cardsViewType {
        case .StackView:
            // add answer
            setupMaskPath(item)
            cardIndexCollection.setupAnswers(stackView.currentCardIndex, value: item)
        
        default: break
        }

    }
    
    // moving onto a new metric card
    func onFocusingOnMetric(_ card: CardInfoObjModel?) {
        
    }
    
    // hit the end of card list (as result of user forcing over the end)
    func onEnd() {
        
    }
    
    // hit the beginning of card list (as result of user forcing over the beginning)
    func onBegin() {
        
    }
}

