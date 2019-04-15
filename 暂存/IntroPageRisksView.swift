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
    
    fileprivate var risksCollectionView: UICollectionView!
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
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionViewFrame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height - footerHeight)
        risksCollectionView = UICollectionView(frame: collectionViewFrame, collectionViewLayout: layout)
        risksCollectionView.backgroundColor = UIColor.white
        risksCollectionView.dataSource = self
        
        // green bar
        let displayView = IntroPageRisksDisplayView.createWithFrame( CGRect(x: 0, y: collectionViewFrame.maxY, width: bounds.width, height: footerHeight * 0.8), riskNumber: risks.count)
        displayView.fillColor = GameTintApplication.sharedTint.gameTintColor.cgColor
        addSubview(displayView)
        if risks.count != 0 {
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(changeState))
            displayView.addGestureRecognizer(tapGR)
        }else {
            changeState()
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
            self.transform = CGAffineTransform(translationX: 0, y: cellIsFolded ? -offsetY : 0)
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
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
}



