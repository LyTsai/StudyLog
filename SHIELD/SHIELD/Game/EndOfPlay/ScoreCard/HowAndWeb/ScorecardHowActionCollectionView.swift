//
//  ScorecardHowActionCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/27.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardHowActionCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var displayInfo = [(String, String)]() {
        didSet{
            reloadData()
        }
    }
    fileprivate var color = dosageColor
    fileprivate var title = ""
    class func createWithColor(_ color: UIColor, title: String) -> ScorecardHowActionCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1000
        let plannerCollectionView = ScorecardHowActionCollectionView(frame: CGRect(x: 100, y: 100, width: 100, height: 200), collectionViewLayout: layout)
        plannerCollectionView.backgroundColor = UIColor.clear
        plannerCollectionView.showsHorizontalScrollIndicator = false
        
        plannerCollectionView.register(ScorecardHowActionCell.self, forCellWithReuseIdentifier: scorecardHowActionCellID)
        plannerCollectionView.color = color
        plannerCollectionView.title = title
        
        // delegate
        plannerCollectionView.dataSource = plannerCollectionView
        plannerCollectionView.delegate = plannerCollectionView
        
        return plannerCollectionView
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: scorecardHowActionCellID, for: indexPath) as! ScorecardHowActionCell
        cell.setupWithColor(color, title: "\(displayInfo[indexPath.item].0)")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates({
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }) { (true) in
            let urlString = self.displayInfo[indexPath.item].1
            let webVC = ScorecardWebDisplayViewController()
            webVC.setupWithTitle(self.title, subTitle: "", urlString: urlString)
            self.viewController.presentOverCurrentViewController(webVC, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frameH = collectionView.bounds.height
        let layout = collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: frameH * 2, height: frameH)
        let margin = frameH * 0.1
        layout.sectionInset = UIEdgeInsets(top: 0, left: margin, bottom: 0, right: margin)
        
        return layout.itemSize
    }
}
