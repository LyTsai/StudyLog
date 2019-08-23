//
//  FRTreatmentTargetChooseCell.swift
//  FacialRejuvenationByDesign
//
//  Created by L on 2019/6/18.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation

let FRTreatmentTargetChooseCellID = "FRTreatmentTargetChooseCell identifier"
class FRTreatmentTargetChooseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        addBasic()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addBasic()
    }
    
    fileprivate var chooseView: FRTreatmentTargetChooseView!
    fileprivate func addBasic() {
        self.backgroundColor = UIColor.clear
        
        chooseView = FRTreatmentTargetChooseView()
        contentView.addSubview(chooseView)
    }
    
    fileprivate var landmark: FRAssessLandmarkModel!
    func setWithLandmark(_ landmark: FRAssessLandmarkModel)  {
        self.landmark = landmark
        chooseView.setupWithCard(landmark.cardKey, matchKey: landmark.matchKey)
        chooseView.setTarget(landmark.treatments)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        chooseView.frame = bounds
    }
    
    func updateTreatment() {
//        landmark.treatments = chooseView.chosenTargets
    }
}
