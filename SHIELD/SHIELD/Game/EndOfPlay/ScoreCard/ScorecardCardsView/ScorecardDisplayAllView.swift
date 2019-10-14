//
//  ScorecardDisplayAllView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/6/11.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class ScorecardDisplayAllView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadBasicView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadBasicView()
    }
    
    fileprivate let mainView = ScorecardMainView.createWithFrame(CGRect.zero, viewsOn: [])
    fileprivate let indicatorView = ImagesIndicatorCollectionView.createWithFrame(CGRect.zero, images: [])
    fileprivate let leftArrow = UIButton(type: .custom)
    fileprivate let rightArrow = UIButton(type: .custom)
    
    fileprivate func loadBasicView() {
        addSubview(mainView)
        indicatorView.scorecardAll = self
        
        addSubview(indicatorView)
      
//        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(goToLast))
//        mainView.addGestureRecognizer(rightSwipe)
//        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(goToNext))
//        leftSwipe.direction = .left
//        mainView.addGestureRecognizer(leftSwipe)
    }
    
    fileprivate var indiCards = [String: [Int]]()
    fileprivate var currentIndex = 0
    fileprivate var viewsOn = [UIView]()
    fileprivate var indiImages = [UIImage]()
    fileprivate var indiTypes = [String]()
    fileprivate var riskKey: String!
    func setupWithMeasurement(_ measurement: MeasurementObjModel) {
        self.riskKey = measurement.riskKey!
        
        let userKey = measurement.playerKey!
        var userInfo = UserInfoObjModel()
        
        if userKey == userCenter.loginKey {
            userInfo = userCenter.loginUserObj.details()
        }else {
            userInfo = userCenter.getPseudoUser(userKey)!.details()
        }
        
        let cover = ScorecardCoverView()
        cover.setupWithUserInfo(userInfo, measurement: measurement)
        
        let overall = ScorecardFirstView()
        overall.setupWithMeasurement(measurement)
    
        let card = ScorecardSecondView()
        card.setupWithMeasurement(measurement)
        
        viewsOn = [cover, overall, card]
        
        // special how
        if riskKey == brainAgeKey || riskKey == sleepQualityKey {
            let refView = ScorecardReferenceView()
            refView.scoreRef.scorecardAll = self
            refView.setupWithMeasurement(measurement)
            viewsOn.append(refView)
        }
        
        // how
        let howView = ScorecardHowView()
        howView.setupWithMeasurement(measurement)
        viewsOn.append(howView)
        
        // url
        if let risk = collection.getRisk(riskKey) {
            // insight
            for insightUrl in risk.insightUrls {
                let insight = ScorecardWebView()
                insight.setupWithRiskKey(riskKey, urlString: insightUrl, concertoType: .insight)
                viewsOn.append(insight)
            }
            
            // FYI
            for fyiUrl in risk.fyiUrls {
                let bonusPage = ScorecardWebView()
                bonusPage.setupWithRiskKey(riskKey, urlString: fyiUrl, concertoType: .fyi)
                viewsOn.append(bonusPage)
            }
        }
        
        for (i, view) in viewsOn.enumerated() {
            if view.isKind(of: ScorecardConcertoView.self) {
                let concerto = (view as! ScorecardConcertoView).concertoType
                let type = concerto.rawValue
                
                if indiCards[type] == nil {
                    indiCards[type] = [i]
                    indiTypes.append(type)
                    indiImages.append(concerto.decoImage)
                }else {
                    indiCards[type]!.append(i)
                }
                
            }else {
                indiCards["cover"] = [i]
                indiTypes.append("cover")
                indiImages.append(UIImage(named: "scorecard_cover")!)
            }
        }
        
        indiImages.append(UIImage(named: "scorecard_continue")!)
        
        mainView.viewsOn = viewsOn
        mainView.isScrollEnabled = false
        indicatorView.images = indiImages
        scrollToIndex(0)
    }
    
    override var frame: CGRect {
        didSet{
            let bottom = useBottom ? min(bounds.height * 0.08, bounds.width / CGFloat(indiImages.count + 1)) : 0
            let top = bounds.height - bottom
            mainView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: top)
            if useBottom {
                indicatorView.frame = CGRect(x: 0, y: top, width: bounds.width, height:bottom)
            }else {
                let arrowLength = bounds.width * 0.04
                let arrowHeight = arrowLength * 75 / 23
                let arrowY = bounds.midY * 0.8
    
                leftArrow.frame = CGRect(x: 0, y: arrowY, width: arrowLength, height: arrowHeight)
                rightArrow.frame = CGRect(x: bounds.width - arrowLength, y: arrowY, width: arrowLength, height: arrowHeight)
            }
        }
    }
    
    fileprivate var useBottom = true
    func setupWithoutBottom()  {
        useBottom = false
        // page control
        leftArrow.setBackgroundImage(UIImage(named: "left_rect"), for: .normal)
        rightArrow.setBackgroundImage(UIImage(named: "right_rect"), for: .normal)
        leftArrow.layer.addBlackShadow(4 * fontFactor)
        leftArrow.layer.shadowOpacity = 0.6
        rightArrow.layer.addBlackShadow(4 * fontFactor)
        rightArrow.layer.shadowOpacity = 0.6
        
        leftArrow.addTarget(self, action: #selector(goToLast), for: .touchUpInside)
        rightArrow.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        
        addSubview(leftArrow)
        addSubview(rightArrow)
        
        indicatorView.removeFromSuperview()
    }
    
    @objc func goToLast() {
        if currentIndex != 0 {
            scrollToIndex(currentIndex - 1)
        }
    }
    @objc func goToNext() {
        if currentIndex != viewsOn.count - 1 {
            scrollToIndex(currentIndex + 1)
        }
    }
    
    func scrollToIndex(_ index: Int) {
        if index < 0 || index >= viewsOn.count {
            return
        }
        
        leftArrow.isHidden = (index == 0)
        rightArrow.isHidden = (index == viewsOn.count - 1 || viewsOn.isEmpty)
        
        mainView.performBatchUpdates({
            self.mainView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }, completion: { (true) in
            let currentView = self.viewsOn[index]
            if currentView.isKind(of: ScorecardWebView.self) {
                let webView = currentView as! ScorecardWebView
                if webView.concertoType == .fyi {
                    self.sendBonusInfo(webView)
                }else {
                    webView.evaluate("showWindow()")
                }
            }
        })
        
        // indicatorView
        let oldIndiC = indicatorView.currentIndex
        if index == 0 {
            // go to cover
            indicatorView.currentIndex = 0
        }else {
            // balloon
            let currentView = viewsOn[index]
            if currentView.isKind(of: ScorecardConcertoView.self) {
                let concerto = (currentView as! ScorecardConcertoView).concertoType.rawValue
                
                for (i, type) in indiTypes.enumerated() {
                    if type == concerto {
                        indicatorView.currentIndex = i
                        break
                    }
                }
            }
        }
        
        if oldIndiC != indicatorView.currentIndex {
            let all = [IndexPath(item: oldIndiC, section: 0), IndexPath(item: indicatorView.currentIndex, section: 0)]
            indicatorView.performBatchUpdates({
                self.indicatorView.reloadItems(at: all)
            }, completion: nil)
        }
        
        self.currentIndex = index
    }
    
    fileprivate func sendBonusInfo(_ webView: ScorecardWebView) {
        let bonus = collection.getBonusCardsOfRisk(self.riskKey)
        var bArrayS = "\"["
        for card in bonus {
            var currentMatch = card.getDisplayOptions().first!.match!
            var selection = -1
            if let result = card.currentSelection() {
                currentMatch = card.currentMatch()!
                selection = result
            }
            
            bArrayS.append("{'CardStyleKey': '\(card.cardStyleKey!)','Key':'\(currentMatch.key!)','Name':'\(currentMatch.name ?? "")','PictureKey':'\(currentMatch.pictureKey ?? "")', 'Info': '\(currentMatch.info ?? "")','Statement': '\(currentMatch.statement ?? "")', 'Result': '\(selection)'},")
        }
        
        bArrayS.removeLast()
        bArrayS.append("]\"")
        webView.evaluate("showWindow(\(bArrayS))")
    }
    
    func scrollToIndicatorOfType(_ typeValue: String) {
        if indiCards[typeValue] == nil {
            scrollToIndex(0)
        }else {
            scrollToIndex(indiCards[typeValue]!.first!)
        }
    }
    
    func scrollToIndicator(_ index: Int) {
        let type = indiTypes[index]
        scrollToIndicatorOfType(type)
    }
}

