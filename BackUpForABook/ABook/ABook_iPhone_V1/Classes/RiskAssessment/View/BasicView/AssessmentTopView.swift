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
    func onValueSet()
    // user asks to skip a card for input
    func moveToNextCard()
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
    
    fileprivate var headerHeight: CGFloat {
        return 67 * bounds.height / 667
    }
    fileprivate var topMargin: CGFloat {
        return 8 * bounds.height / 667
    }
    
    var cardIndexCollection: CardIndexCollectionView!
    weak var controllerDelegate: ABookRiskAssessmentViewController!
    
    var cardsViewType: CardsViewType = .WheelOfCards {
        didSet {
            showCardsView(cardsViewType)
        }
    }
    
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
    
    //////////////////////////////////////////////////////////////////////////////
    // source of cards navigated through by the above views
    //////////////////////////////////////////////////////////////////////////////
    fileprivate var dataCursor = RiskMetricCardsCursor.sharedCursor
    
    // REST api risk model source
    fileprivate var riskListAccess: RiskListAccess!
    
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
    fileprivate let maskLayer = CAShapeLayer()
    fileprivate let cardBackImage = UIImageView(image: ProjectImages.sharedImage.backImage)
    fileprivate func updateUIAndData() {
        riskListAccess = RiskListAccess(callback: self)
        backgroundColor = UIColor.clear
    
        // background
        cardBackImage.frame = bounds
        addSubview(cardBackImage)
        
        // create hearder view
        let headerFrame = CGRect(origin: CGPoint.zero, size: CGSize(width: bounds.width, height: headerHeight))
        cardIndexCollection = CardIndexCollectionView.createWithFrame(headerFrame)
        cardIndexCollection.assessmentViewDelegate = self
        addSubview(cardIndexCollection)
        cardIndexCollection.isHidden = true

        // create views ready for use in the card view area
        createAllCardViews()
        
        // do we have data?
        let riskClassKey = dataCursor.selectedRiskClassKey!
            // switch to REST api data source instead of local coredata
            // focusDeckOfCardViewsOnRiskClass(riskClassKey) <- assumes risk model object was already loaded
            
            // do we have risk model object loaded aready?
        if dataCursor.checkRiskObject(dataCursor.focusingRiskKey) {
            // have the risk object already
            focusDeckOfCardViewsOnRiskClass(riskClassKey)
        }else {
            // no.  need to load the object
            loadRiskGraph(key: dataCursor.selectedRisk(riskClassKey)!)
        }
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
        
        stackView.isHidden = true
        wheelCardsView.isHidden = true
        tableView.isHidden = true
        verticalFlowView.isHidden = true
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
        
        // keep the item in center
        cardIndexCollection.scrollToItem(at: IndexPath(item: item, section: 0), at: .centeredHorizontally, animated: true)
        if optionIndex < 0 || optionIndex >= total {
            cardIndexCollection.cursorItem = 0
        }else {
            cardIndexCollection.cursorItem = optionIndex
        }
        
        let layout = cardIndexCollection.collectionViewLayout as! UICollectionViewFlowLayout
        let itemWidth = layout.itemSize.width
        var baseX: CGFloat = 0
        
        // card info
        let card = VDeckOfCardsFactory.metricDeckOfCards.getVCard(item)!
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
            // yes or no
            if optionIndex == 1 {
                // placed at right, as no
                baseX += itemWidth * 0.75
            } else {
                // init state, and yes answer
                 baseX += itemWidth * 0.25
            }
        } else {
            // mulitiple
            let number = card.cardOptions.count
            let oneBase = itemWidth / CGFloat(number)
            if optionIndex >= 0 && optionIndex < number {
                baseX += oneBase * (0.5 + CGFloat(optionIndex))
            }else {
                // init state, to the first one
                baseX += oneBase * 0.5
            }
        }
        
        // path
        let topY = headerHeight - topMargin
        let bottomY = headerHeight
        let xOffset = topMargin * 1.5
        
        let path = UIBezierPath(rect: CGRect(x: 0, y: bottomY, width: bounds.width, height: bounds.height - topMargin))
        path.move(to: CGPoint(x: baseX - xOffset, y: bottomY))
        path.addLine(to: CGPoint(x: baseX, y: topY))
        path.addLine(to: CGPoint(x: baseX + xOffset, y: bottomY))
        
        maskLayer.path = path.cgPath
    }
    
    // navigate to risk model of risk class
    // riskKey - selected risk model of riskClassKey risk class
    fileprivate let userDefaults = UserDefaults.standard
    
    func focusDeckOfCardViewsOnRiskClass(_ riskMetricKey:String) {
        // put focus onto riskMetricKey
        focusOntoRisklClass(riskMetricKey)
        
        switch cardsViewType {
        case .StackView: updateStackViewWithCards()
        case .TableView: updateTableViewWithCards()
        case .VerticalFlow: updateVerticalFlowViewWithCards()
        case .WheelOfCards: updateWheelViewWithCards()
        }
    }
    
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
            
        let factory = VDeckOfCardsFactory.metricDeckOfCards
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
    // set metric deck of crd view type
    fileprivate func showCardsView(_ cardsViewType: CardsViewType) {
        // wheelCardsView
        wheelCardsView.isHidden = (cardsViewType == .WheelOfCards ? false : true)

        // verticalFlowView
        verticalFlowView.isHidden = (cardsViewType == .VerticalFlow ? false : true)

        // stackView
        stackView.isHidden = (cardsViewType == .StackView ? false : true)
        
        // tableView
        tableView.isHidden = (cardsViewType == .TableView ? false : true)
        
    }
    
    ///////////////////////////////////////////////////////////////////
    // CardNotificationProtocol
    // data input has been made
    func onValueSet() {
        // !!! check the condition for saving ethe result.  for now, save immediatly
        switch cardsViewType {
        case .WheelOfCards: wheelCardsView.scrollCard()
        case .StackView:
            stackView.flyAwayAndPop()
            
            // move the indicator
            let item = stackView.currentCardIndex
            cardIndexCollection.focusOnItem(item)
            
        default: break
        }

    }

    // choose answer
    func setupIndicator(_ item: Int) {
        switch cardsViewType {
        case .StackView:
            // add answer
            setupMaskPath(item)
            cardIndexCollection.cardAnswers[stackView.currentCardIndex] = item
        
        default: break
        }

    }
    
    // user asks to skip a card for input
    func moveToNextCard() {
        switch cardsViewType {
        case .WheelOfCards: wheelCardsView.scrollCard()
        case .StackView: stackView.flyAwayAndPop()
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
    
    // show metricDeckOfCards
    func showMetricDeckOfCardsInView() {
        if (cardsViewType == .WheelOfCards) {
            wheelCardsView.showDeckOfCards()
        }else if (cardsViewType == .VerticalFlow) {
            verticalFlowView.showDeckOfCards()
        }else if (cardsViewType == .TableView) {
            stackView.showDeckOfCards()
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    // set risk focus cursor position
    // !!! load a risk "game" and attach it to navigation cursor for card matching "game"
    func focusOntoRisklClass(_ riskMetricKey: String) {
        
        // (2) set focusing risk in dataCursor.
        let riskKey = dataCursor.focusOnRiskClass(riskMetricKey)
        
        // (3) attach current risk factor metrics collection to deck of cards factory
        VDeckOfCardsFactory.metricDeckOfCards.attachToRiskFactorMetricCards(riskKey, metricsCards: self.dataCursor.getFocusingRiskMetricDeckOfCardsCollection())
        
        // (4) show it in cards view
        cardsViewType = dataCursor.getRiskClassCardsViewType(riskMetricKey)
        
        showMetricDeckOfCardsInView()
        cardIndexCollection.isHidden = false
        cardIndexCollection.reloadData()
        cardBackImage.layer.mask = maskLayer
        setupMaskPath(-1)
    }
    
    // load a full risk object graph from REST api backend
    func loadRiskGraph(key: String) {
        riskListAccess.beginApi(nil)
        riskListAccess.getOneGraphByKey(key: key)
    }
}

extension AssessmentTopView: DataAccessProtocal {
    func didFinishGetGraphByKey(_ obj: AnyObject) {
        
        if obj is RiskObjListModel {
            AIDMetricCardsCollection.standardCollection.updateRiskModelObjects(obj as! RiskObjListModel)
        }
        
        focusDeckOfCardViewsOnRiskClass(dataCursor.selectedRiskClassKey)
    }
    
    func failedGetDataByKey(_ error: String) {
        
        // show error messages.  !!! to do
    }
}

