//
//  IntroPageRisksTableView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/9/22.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class IntroPageRisksView: UIView {
    weak var hostVC: IntroPageViewController!
    
    var risksCollectionView: UICollectionView!
    var risks = [RiskObjModel]()
    var cellIsFolded = false
    
    class func createWithFrame(_ frame: CGRect, footerHeight: CGFloat, risks: [RiskObjModel]) -> IntroPageRisksView {
        let risksView = IntroPageRisksView(frame: frame)
        risksView.setupWithRisks(risks, footerHeight: footerHeight)
        
        return risksView
    }
    
    fileprivate var footerHeight: CGFloat = 39
    fileprivate var displayView: IntroPageRisksDisplayView!
    fileprivate func setupWithRisks(_ risks: [RiskObjModel], footerHeight: CGFloat) {
        backgroundColor = UIColor.clear
        self.footerHeight = footerHeight
        self.risks = risks
       
        // risks
        let collectionViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - footerHeight)
        let layout = CoverFlowLayout()
        
        if risks.count == 1 {
            layout.itemSize = CGSize(width: bounds.width, height: collectionViewFrame.height)
        }else {
            let hGap = bounds.width * 0.04
            let vGap = collectionViewFrame.height * 0.02
            layout.itemSize = CGSize(width: (bounds.width - 2 * hGap) / 2, height: collectionViewFrame.height - 2 * vGap)
            layout.sectionInset = UIEdgeInsets(top: vGap, left: layout.itemSize.width, bottom: vGap, right: layout.itemSize.width)
        }
       
        risksCollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        risksCollectionView.showsHorizontalScrollIndicator = false
        
        if risks.count == 1 {
            let cellNib = UINib(nibName: "IntroPageRiskCell", bundle: Bundle.main)
            risksCollectionView.register(cellNib, forCellWithReuseIdentifier: introPageRiskCellID)
        }else {
            let cellNib = UINib(nibName: "IntroPageRisksCell", bundle: Bundle.main)
            risksCollectionView.register(cellNib, forCellWithReuseIdentifier: introPageRisksCellID)
        }
        
        risksCollectionView.backgroundColor = UIColor.white
        risksCollectionView.dataSource = self
        risksCollectionView.delegate = self
        
        addSubview(risksCollectionView)
        
        // green bar
        displayView = IntroPageRisksDisplayView.createWithFrame( CGRect(x: 0, y: collectionViewFrame.maxY, width: bounds.width, height: footerHeight * 0.8), riskNumber: risks.count)
        displayView.fillColor = GameTintApplication.sharedTint.gameTintColor.cgColor
        addSubview(displayView)
        if risks.count != 0 {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(changeState))
            displayView.addGestureRecognizer(tapGR)
        }else {
            cellIsFolded = true
            self.transform = CGAffineTransform(translationX: 0, y: -collectionViewFrame.height)
        }
    }
    
    func updateData() {
        risksCollectionView.reloadData()
    }
    func changeState() {
        cellIsFolded = !cellIsFolded
        let offsetY = (cellIsFolded ? 1 : -1 ) * (bounds.height - footerHeight)
        let pageTable = hostVC.pageTableView!
        let pageFrame = pageTable.frame
        let expectedFrame = CGRect(x: pageFrame.minX, y: pageFrame.minY - offsetY, width: pageFrame.width, height: pageFrame.height + offsetY)
    
        UIView.animate(withDuration: 0.4, animations: {
            self.transform = CGAffineTransform(translationX: 0, y: self.cellIsFolded ? -offsetY : 0)
            pageTable.frame = expectedFrame
        }) { (true) in
            self.displayView.setupState(self.cellIsFolded)
        }
    }
}

 // data source
extension IntroPageRisksView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return risks.count
            
//            <= 1 ? risks.count : risks.count + 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: risks.count == 1 ? introPageRiskCellID : introPageRisksCellID, for: indexPath) as! IntroPageRiskCell
        cell.hostView = self
        var index = indexPath.item
        
//        if risks.count > 1 {
//            if index == 0 {
//                index = risks.count - 1
//            }else if index == risks.count + 1 {
//                index = 0
//            }else {
//                index -= 1
//            }
//        }
        
        cell.configureWithRisk(risks[index])
        
        // card like
        if risks.count > 1 {
            let riskTypeKey = RiskMetricCardsCursor.sharedCursor.riskTypeKey
            let color = AIDMetricCardsCollection.standardCollection.getRiskTypeByKey(riskTypeKey)!.realColor ?? tabTintGreen
            cell.layer.cornerRadius = 8 * fontFactor
            cell.layer.borderColor = color.cgColor
            cell.layer.borderWidth = fontFactor * 2
//            cell.layer.addBlackShadow(6 * fontFactor)
            
        }
        
        return cell
    }
}

// scroll
extension IntroPageRisksView: UICollectionViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        if offset < bounds.width {
            
        }
        
    }
}



