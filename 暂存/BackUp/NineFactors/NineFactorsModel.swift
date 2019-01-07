//
//  NineFactorsModel.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/11/14.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation

class NineFactorsModel: NSObject,NSCoding {
//    var index: Int!
    var text: String!
    var imageName: String!
    var checked = false
    var bannerColor: UIColor!
    
//    private enum CodingKeys: CodingKey {
//        case text, imageName, checked, bannerColor
//    }
    
    
    // coding
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//
//        try container.encode(text, forKey: .text)
//        try container.encode(imageName, forKey: .imageName)
//        try container.encode(checked, forKey: .checked)
////        try container.encode(bannerColor, forKey: .bannerColor)
//    }
    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        text = try container.decode(String.self, forKey: .text)
//        imageName = try container.decode(String.self, forKey: .imageName)
//        checked = try container.decode(Bool.self, forKey: .checked)
////        bannerColor = try container.decode(UIColor.self, forKey: .bannerColor)
//    }
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "factorText")
        aCoder.encode(imageName, forKey: "factorImageName")
        aCoder.encode(checked, forKey: "factorIsChecked")
        aCoder.encode(bannerColor, forKey: "factorColor")
    }

    override init() {
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()

        text = aDecoder.decodeObject(forKey: "factorText") as! String
        imageName = aDecoder.decodeObject(forKey: "factorImageName") as! String
        checked = aDecoder.decodeBool(forKey: "factorIsChecked")
        bannerColor = aDecoder.decodeObject(forKey: "factorColor") as! UIColor
    }
    
    // all data
    class func getAllFactors() -> [NineFactorsModel] {
        var factors = [NineFactorsModel]()
        let texts = ["Current Smoking", "Obesity", "Sedentary Lifestyle", "Inadequate Fruits and Veggies Consumption", "Sleeping other than 7-8 hours daily", "Depression", "Hypertension", "High Cholesterol", "Diabetes (Type 2)"]
        
        for (i, text) in texts.enumerated() {
            let factor = NineFactorsModel()
            factor.text = text
            factor.imageName = "9factors_\(i)"
//            factor.index = i
            factor.bannerColor = colorPairs[i % colorPairs.count].fill.withAlphaComponent(0.7)
            factors.append(factor)
        }
        
        return factors
    }
    
    class func getArchivedFactors() -> [NineFactorsModel]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: nineFactorsPath) as? [NineFactorsModel]
    }
    
    class func archiveFactors(_ factors: [NineFactorsModel]) -> Bool {
        return NSKeyedArchiver.archiveRootObject(factors, toFile: nineFactorsPath)
    }
}
