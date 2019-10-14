//
//  IntroPageRisksCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/3/21.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class IntroPageRisksCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {
    // risk selection is defined by {risk.Metric, risk.RiskType} or (subject, type)
    fileprivate var riskClass: MetricObjModel!
    // selected risk object
    var risks = [RiskObjModel]()
    
    fileprivate var currentItem = 0 {
        didSet{
            if currentItem == oldValue {
                return
            }
            
            // choose a new one
            var updates = [IndexPath]()
            for item in min(currentItem, oldValue)...max(currentItem, oldValue) {
                updates.append(IndexPath(item: item, section: 0))
            }
            
            let currentIndexPath = IndexPath(item: currentItem, section: 0)
            performBatchUpdates({
                self.reloadItems(at: updates)
            }) { (true) in
                self.scrollToItem(at: currentIndexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    class func createWithFrame(_ frame: CGRect) -> IntroPageRisksCollectionView {
        let layout = ScaleLayout()
        layout.minRatio = 1
        
        let vGap = frame.height * 0.02
        let hGap = frame.width * 0.04
        layout.itemSize = CGSize(width: (frame.width - 2 * hGap), height: frame.height - 2 * vGap)
        layout.sectionInset = UIEdgeInsets(top: vGap, left: hGap, bottom: vGap, right: hGap)
        layout.minimumLineSpacing = -layout.itemSize.width * 0.99
        
        // create
        let intro = IntroPageRisksCollectionView(frame: frame, collectionViewLayout: layout)
        intro.backgroundColor = UIColor.clear
        intro.register(IntroPageCardCell.self, forCellWithReuseIdentifier: introPageCardCellID)
        intro.isScrollEnabled = false

        intro.dataSource = intro
        intro.delegate = intro
        
        intro.addGestureRecognizers()
        
        return intro
    }

    func loadWithCurrentData() {
        riskClass = cardsCursor.selectedRiskClass
        risks.removeAll()
        
        for key in collection.getRiskModelKeys(riskClass.key, riskType: cardsCursor.riskTypeKey) {
            if let risk = collection.getRisk(key) {
                risks.append(risk)
            }
        }
        reloadData()
    }
    
    func checkForHint() {
        if risks.count != 0 {
            let hintKey = "risk play hint shown before key"
            if !userDefaults.bool(forKey: hintKey) && !RISKPLAYHINT {
                let hintVC = AbookHintViewController()
                hintVC.focusOnFrame(CGRect(x: 0, y: frame.minY + 155 * fontFactor, width: frame.width, height: 170 * fontFactor).insetBy(dx: frame.width * 0.05, dy: 0), hintText: "Tap to play card-matching game: for you or for someone else, to establish baseline or play What-if.")
                hintVC.hintKey = hintKey
                viewController.overCurrentPresentController?.present(hintVC, animated: true, completion: nil)
                
                RISKPLAYHINT = true
            }
        }
    }
    
    fileprivate func addGestureRecognizers() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeToCheck))
        leftSwipe.direction = .left
        addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeToCheck))
        rightSwipe.direction = .right
        addGestureRecognizer(rightSwipe)
    }
    
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return max(risks.count, 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: introPageCardCellID, for: indexPath) as! IntroPageCardCell
        let headerRatio: CGFloat = 250 / 345
        var startPoint: CGFloat = 0
        if risks.count > 1 {
            startPoint = (1 - headerRatio) / CGFloat(risks.count - 1) * CGFloat(indexPath.item)
        }
        // attach this collection view to selected risk
        cell.configureWithRisk(risks.isEmpty ? nil : risks[indexPath.item], metric: riskClass, headerRatio: headerRatio, startPoint: startPoint)
//        cell.isCurrent = indexPath.item == currentItem
        cell.itemGap = (indexPath.item - currentItem)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentItem = indexPath.item
    }
    
    @objc func swipeToCheck(_ swipeGR: UISwipeGestureRecognizer) {
        if swipeGR.direction == .left {
            if currentItem != risks.count - 1 {
                currentItem += 1
            }
        }else {
            if currentItem != 0 {
                currentItem -= 1
            }
        }
    }
}

