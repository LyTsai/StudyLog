//
//  FacialLandmarksView.swift
//  AnnielyticX
//
//  Created by L on 2019/6/3.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation
class FacialLandmarkModel {
    /*
     HF, horizontal forehead lines;
     GF, glabellar frown lines;
     PO, periorbital lines;
     PA, preauricular lines;
     CL, cheek lines;
     NL, nasolabial folds;
     UL, upper radial lip lines;
     LL, lower radial lip lines;
     CM, corner of the mouth lines;
     ML, marionette lines;
     LM, labiomental crease;
     NF, horizontal neck folds.
     */
    
    var name: String!
    var abbreviation: String!
    var seqNumber: Int!
//    var cards: [CardInfoObjModel]!
    
    var boundingBox: CGRect!
    
    
    class func getDefaultData() -> [FacialLandmarkModel] {
        var landmarks = [FacialLandmarkModel]()
        let landmarkData = [("HF", "horizontal forehead lines"),
                            ("GF", "glabellar frown lines"),
                            ("PO", "periorbital lines"),
                            ("PA", "preauricular lines"),
                            ("CL", "cheek lines"),
                            ("NL", "nasolabial folds"),
                            ("UL", "upper radial lip lines"),
                            ("LL", "lower radial lip lines"),
                            ("CM", "corner of the mouth lines"),
                            ("ML", "marionette lines"),
                            ("LM", "labiomental crease"),
                            ("NF", "horizontal neck folds")]
        for (i, landmark) in landmarkData.enumerated() {
            let landmarkModel = FacialLandmarkModel()
            landmarkModel.seqNumber = i + 1
            landmarkModel.abbreviation = landmark.0
            landmarkModel.name = landmark.1
            
            landmarks.append(landmarkModel)
        }
        
        return landmarks
    }
}

class FacialLandmarksView: UIView {
    
}
