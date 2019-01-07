//
//  InfoInputModel.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/10.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class InfoInputModel {
    var title = "My Height"
    var units = ["ft", "cm", "m"]
    var descri = "the height of you"
    
    class func getRequiredInfo() -> [InfoInputModel] {
        let height = InfoInputModel()
        
        let weight = InfoInputModel()
        weight.title = "My Weight"
        weight.units = ["lbs", "kg", "st"]
        weight.descri = "the weight"
        
        let age = InfoInputModel()
        age.title = "My Age"
        age.units = ["year", "month"]
        age.descri = "this is about the age, long for test, test, test"
        
        return [height, weight, age]
    }
}
