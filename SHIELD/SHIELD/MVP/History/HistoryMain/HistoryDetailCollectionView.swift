//
//  HistoryDetailCollectionView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/21.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class HistoryDetailCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    weak var timelineTable: TimelineTableView!
    var tableIndexPath: IndexPath!

    class func createCollectionView() -> HistoryDetailCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1000
        layout.scrollDirection = .horizontal
        
        let collectionView = HistoryDetailCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.register(HistoryMeasurementDisplayCell.self, forCellWithReuseIdentifier: historyMeasurementDisplayCellID)
        collectionView.backgroundColor = UIColor.clear
        collectionView.dataSource = collectionView
        collectionView.delegate = collectionView
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }
    
    fileprivate var dataArray = [[MeasurementObjModel]]()
    fileprivate var timelineType = TimelineType.dayline
    fileprivate var chosen = Set<IndexPath>()
    func setupWithDataArray(_ dataArray: [[MeasurementObjModel]], timelineType: TimelineType, chosenInfo: Set<IndexPath>) {
        self.dataArray = dataArray
        self.timelineType = timelineType
        self.chosen = chosenInfo
         
        reloadData()
    }
    
    // data source
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: historyMeasurementDisplayCellID, for: indexPath) as! HistoryMeasurementDisplayCell
        let data = dataArray[indexPath.item]
        cell.setupWithMeasurement(data.first!, multiple: data.count != 1, timelineType: timelineType)
        cell.isChosen = chosen.contains(indexPath)
        cell.allowSelection = isCellSelectable(indexPath)
        
        return cell
    }
    
    fileprivate func isCellSelectable(_ indexPath: IndexPath) -> Bool {
        let comparisonRiskKey = cardsCursor.comparisonRiskKey
       
        if comparisonRiskKey == nil {
            return true
        }else {
            let measurement = dataArray[indexPath.item].first!
            return (comparisonRiskKey == measurement.riskKey)
        }
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let itemH = bounds.height
        let itemW = bounds.height / 70 * 45
        flowLayout.minimumLineSpacing = itemW * 0.2
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: itemW * 0.1, bottom: 0, right: itemW * 0.1)
        
        return CGSize(width: itemW, height: itemH)
    }
    
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isCellSelectable(indexPath) {
            let alert = UIAlertController(title: nil, message: "Records can be compared only for the some game", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            viewController.present(alert, animated: true, completion: {
            })
            
            return
        }
        
        let data = dataArray[indexPath.item]
        if let vc = self.viewController as? HistoryMapViewController {
            vc.chooseMeasurements(data)
        }
    }
}
