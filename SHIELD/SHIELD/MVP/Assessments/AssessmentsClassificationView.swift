//
//  AssessmentsClassificationView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/17.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class AssessmentsClassificationView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var classificationInfo = [(name: String, number: Int, color: UIColor)]() {
        didSet {
           reloadData()
        }
    }
    class func createWithFrame(_ frame: CGRect) -> AssessmentsClassificationView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 1000
        
        let collectionView = AssessmentsClassificationView(frame: frame, collectionViewLayout: layout)
        collectionView.bounces = false
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(AssessmentsClassificationCell.self, forCellWithReuseIdentifier: assessmentsClassificationCellID)
        collectionView.dataSource = collectionView
        collectionView.delegate = collectionView
        
        return collectionView
    }
    
    
    // dataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return classificationInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: assessmentsClassificationCellID, for: indexPath) as! AssessmentsClassificationCell
        let cellInfo = classificationInfo[indexPath.item]
        cell.configureWithName(cellInfo.name, number: cellInfo.number, color: cellInfo.color)
        
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let floatN = CGFloat(classificationInfo.count)
        
        let itemH = bounds.height
        let itemW = bounds.width / 6
        
        let gap = (bounds.width - floatN * itemW) / (floatN + 1)
        flowLayout.minimumLineSpacing = gap
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: gap, bottom: 0, right: gap)
        
        return CGSize(width: itemW, height: itemH)
    }
}
