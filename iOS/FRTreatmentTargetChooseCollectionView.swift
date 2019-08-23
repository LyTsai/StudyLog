//
//  FRTreatmentTargetChooseCollectionView.swift
//  FacialRejuvenationByDesign
//
//  Created by L on 2019/6/18.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

class FRTreatmentTargetChooseCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        register(FRTreatmentTargetChooseCell.self, forCellWithReuseIdentifier: FRTreatmentTargetChooseCellID)
        dataSource = self
        delegate = self
    }
    
    fileprivate var landmarks = [FRAssessLandmarkModel]()
    func loadWithLandmarks(_ landmarks: [FRAssessLandmarkModel]) {
        self.landmarks = landmarks
        reloadData()
    }
    
    // data
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return landmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FRTreatmentTargetChooseCellID, for: indexPath) as! FRTreatmentTargetChooseCell
        cell.setWithLandmark(landmarks[indexPath.item])
        return cell
    }
    
    // delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let horizontal = 15 * fontFactor
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: horizontal, bottom: 0, right: horizontal)
        flowLayout.minimumLineSpacing = 2 * horizontal
        flowLayout.minimumInteritemSpacing = 1000
        
        return bounds.insetBy(dx: horizontal, dy: 0).size
    }
}
