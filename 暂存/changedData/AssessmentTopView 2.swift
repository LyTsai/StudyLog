//
//  AssessmentTopView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 16/10/31.
//  Copyright © 2016年 LyTsai. All rights reserved.
//

import UIKit


enum CardsViewType: String {
    case WheelOfCards
    case VerticalFlow
    case TableView
    case StackView
}

// MARK: ------------------ risk assessment view -----------------
// class
class AssessmentTopView: UIView, CardNotificationProtocol{
    var headerHeight: CGFloat = 80
    var headerCollectionView : UICollectionView!
 
    // IDs for linking to collection cell and header classes
    let cellID = "Cell Identifier"
    let headerViewID = "HeaderView Identifier"

    //////////////////////////////////////////////////////////////////////////////
    // views for presenting the data input cards.  this is the card "working" area
    // only one view can be visible at any given time
    //////////////////////////////////////////////////////////////////////////////
    var cardsViewType: CardsViewType = .WheelOfCards {
        didSet {
            showCardsView(cardsViewType)
        }
    }
    
    // wheel of card view
    var wheelCardsView: WheelOfCardsCollectionView!
    // true for feeding one set of AIDMetricDeckOfCards into the view for viewing one metric in the view.
    // false means feeding [AIDMetricDeckOfCards] array into the view for viewing array of metrics in the view
    // simply put, true means showing one metric at a time and false means showing one risk at a time
    // set to false to see all metric cards of focused risk
    // set to ture to see option card of ONE metric with event sending back for scrolling
    var byMetric = false // true
    
    // vertical flow collection view
    var verticalFlowView:VerticalFlowView!
    
    // We will add this view later once we are done with other views
    // table view
    
    // stack view
    var stackView: CardsContainerView!
    
    //////////////////////////////////////////////////////////////////////////////
    // source of cards navigated through by the above views
    //////////////////////////////////////////////////////////////////////////////
    var cardSource = RiskMetricCardsCursor()

    // methods
    // ---------------- init ------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        updateWheelUIAndData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateWheelUIAndData()
    }
    
    func updateWheelUIAndData() {
        // create hearder view
        setupHeaderCollectionView()
        // create views ready for use in the card view area
        setupDeckOfCardViews()
        // create the node graph view for the graph area
    }
    
    // set collectionView of top
    func setupHeaderCollectionView() {
        let collectionViewframe = CGRect(x: 0, y: 0, width: bounds.width, height: headerHeight)
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        collectionViewLayout.scrollDirection = .Horizontal
        collectionViewLayout.minimumLineSpacing = 10
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        collectionViewLayout.itemSize = CGSize(width: 120, height: 50)
        collectionViewLayout.headerReferenceSize = CGSize(width: 3, height: 10)
        
        headerCollectionView = UICollectionView(frame: collectionViewframe, collectionViewLayout: collectionViewLayout)
        headerCollectionView.backgroundColor = UIColor.lightGrayColor()
        
        headerCollectionView.registerClass(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        headerCollectionView.registerClass(HeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerViewID)
        headerCollectionView.dataSource = self
        headerCollectionView.delegate = self
        
        addSubview(headerCollectionView)
    }
    
    // set metric deck of crd view type
    private func showCardsView(cardsViewType: CardsViewType) {
        // wheelCardsView
        wheelCardsView.hidden = (cardsViewType == .WheelOfCards ? false : true)

        // verticalFlowView
        verticalFlowView.hidden = (cardsViewType == .VerticalFlow ? false : true)

        // stackView
        stackView.hidden = (cardsViewType == .StackView ? false : true)
    }
    
    // firat time creating deck of card view area
    private func setupDeckOfCardViews() {
        // wheel of card
        setupSpinningWheelView()
        // !!! Lisa add all other views
        
    }

    // first time setting up the wheel of cards view
    private func setupSpinningWheelView() {
        
        let frame = CGRect(x: 0, y: headerHeight, width: bounds.width, height: bounds.height-headerHeight)
        
        // create WheelOfCardsCollectionView
        wheelCardsView = WheelOfCardsCollectionView.createWheelCollectionView(frame)
        wheelCardsView.assessmentTopDelegate = self
        wheelCardsView.backgroundColor = UIColor.whiteColor()
        addSubview(wheelCardsView)
        
        // set focus on the first risk item
        if (self.cardSource.numberOfRisks > 0)
        {
            riskItemSelectedAtIndexPath(NSIndexPath(forItem: 0, inSection: 0), refresh: true)
        }
     }

    private func nextStackOfCards(index: Int) -> [VCardModel] {
        if index < 0 || index > cardSource.numberOfRisks - 2 {
            return []
        }
        return cardSource.getVCardsOfRiskIndex(index + 1)
    }
    
    // MARK: --------- collectionView of header -----------------
    var selectedIndexPath = NSIndexPath(forItem: 0, inSection: 0) // the first as default
    
    // dataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if collectionView.isKindOfClass(VerticalFlowView.self) {
            return 1
        }
        
        return 2
    }
 
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.isKindOfClass(VerticalFlowView.self) {
            return 9
        }
        if section == 1 {
            return 0
        }
        return cardSource.numberOfRisks
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellID, forIndexPath: indexPath) as! HeaderCollectionViewCell
        if (indexPath.item >= 0 && indexPath.item < cardSource.numberOfRisks) {
            configureCell(cell, forIndexPath: indexPath)
        }
        
        return cell
    }
    
    func configureCell(cell: HeaderCollectionViewCell, forIndexPath indexPath: NSIndexPath) {
        cell.selected = false
        cell.text = cardSource.nameOfRiskAtItem(indexPath.item)
        if indexPath == selectedIndexPath {
            cell.selected = true
        }
    }
    
    // header
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerViewID, forIndexPath: indexPath) as! HeaderView
        return header
    }
    
    // delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        riskItemSelectedAtIndexPath(indexPath, refresh: false)
        
        if collectionView.isKindOfClass(VerticalFlowView.self) {
            showMetricDeckOfCardsInView(VDeckOfCardsFactory.metricDeckOfCards)
        }
    }
    
    func riskItemSelectedAtIndexPath(indexPath: NSIndexPath, refresh: Bool) {
        
        let lastSelectedIndexPath = self.selectedIndexPath
        self.selectedIndexPath = indexPath
        if (!refresh && lastSelectedIndexPath == indexPath) { return }
        
        // new selection of risk
        headerCollectionView.performBatchUpdates({
            self.headerCollectionView.reloadItemsAtIndexPaths([lastSelectedIndexPath])
            self.headerCollectionView.reloadItemsAtIndexPaths([indexPath])
        }) { (true) in
            self.headerCollectionView.scrollToItemAtIndexPath(NSIndexPath(forItem: indexPath.item, inSection: indexPath.section), atScrollPosition: .CenteredHorizontally, animated: true)
           
            // put focus onto selected risk item
            self.focusOntoRiskItem(indexPath.item, authorID: SYSTEM)
        }
    }
    
    ///////////////////////////////////////////////////////////////////
    // CardNotificationProtocol
    // has selection
    func onSave() {
        // saved a new metric
        self.moveOntoNextMetric()
    }
    // skip this card
    func onSkip() {
        // skip this metric group
        self.moveOntoNextMetric()
    }
    
    // move to next metric card
    func onNext() {
        self.moveOntoNextMetric()
    }
    
    // move to previous card
    func onPrevious() {
        self.moveOntoPreviousMetric()
    }
    
    // move onto next metric deck of cards
    func moveOntoNextMetric() {
        
        if (byMetric == false) {
            // navigation is not by metric.  invlid request
            return
        }

        // move cursor
        self.cardSource.moveMetricCursorForward()
        VDeckOfCardsFactory.metricDeckOfCards.attachToMetrics([self.cardSource.getMetricDeckOfCardsAtCursor()])
        
        //  show it in wheel of cards view
        showMetricDeckOfCardsInView(VDeckOfCardsFactory.metricDeckOfCards)
    }

    // move onto previous metric deck of cards
    func moveOntoPreviousMetric() {
        if (byMetric == false) {
            // navigation is not by metric.  invlid request
            return
        }
        
        // move cursor
        self.cardSource.moveMetricCursorBackward()
        VDeckOfCardsFactory.metricDeckOfCards.attachToMetrics([self.cardSource.getMetricDeckOfCardsAtCursor()])
        
        //  show it in wheel of cards view
        showMetricDeckOfCardsInView(VDeckOfCardsFactory.metricDeckOfCards)
    }

    ////////////////////////////////////////////////////////////////////////////
    // set risk focus cursor position
    func focusOntoRiskItem(item: Int, authorID: String) {
        
        // (1) set risk focusing cursor
        cardSource.focusOnRisk(item, authorID: authorID)
        
        // !!! for now use the ID of system user which is default list of cards
        let authorID = AIDMetricCardsCollection.systemUser().id
        
        // (2) attach cuurent risk factor metrics collection to deck of cards factory
        if (byMetric == false) {
            VDeckOfCardsFactory.metricDeckOfCards.attachToMetrics(self.cardSource.getFocusingRiskMetricDeckOfCardsCollection(authorID))
        }else{
            VDeckOfCardsFactory.metricDeckOfCards.attachToMetrics([self.cardSource.getMetricDeckOfCardsAtCursor()])
        }
        
        // (3) show it in wheel of cards view
        cardsViewType = cardSource.getCardsViewTypeAtIndex(item)
        showMetricDeckOfCardsInView(VDeckOfCardsFactory.metricDeckOfCards)
    }
    
    // show metricDeckOfCards
    func showMetricDeckOfCardsInView(metricDeckOfCards: VDeckOfCardsFactory) {
        VDeckOfCardsFactory.metricDeckOfCards.byOption = byMetric
        if (cardsViewType == .WheelOfCards) {
            wheelCardsView.showDeckOfCards(metricDeckOfCards)
        } else if (cardsViewType == .VerticalFlow) {
            verticalFlowView.showDeckOfCards(metricDeckOfCards)
        }
    }
}
