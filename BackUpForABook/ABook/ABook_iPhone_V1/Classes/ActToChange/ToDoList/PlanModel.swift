//
//  PlanModel.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

// MARK:--- not a typical model
let colorPairs: [(border: UIColor, fill: UIColor)] = [
    (UIColorFromRGB(168, green: 208, blue: 120), UIColorFromRGB(200, green: 225, blue: 168)),  // green
    (UIColorFromRGB(242, green: 152, blue: 25),  UIColorFromRGB(242, green: 202, blue: 134)),  // orange
    (UIColorFromRGB(69, green: 189, blue: 212),  UIColorFromRGB(122, green: 202, blue: 218)),  // cyan
    (UIColorFromRGB(243, green: 206, blue: 32),  UIColorFromRGB(245, green: 228, blue: 110)),  // yellow
    (UIColorFromRGB(139, green: 98, blue: 167),  UIColorFromRGB(174, green: 142, blue: 191)),  // purple
    (UIColorFromRGB(226, green: 109, blue: 70),  UIColorFromRGB(239, green: 139, blue: 107)),
    (UIColorFromRGB(197, green: 192, blue: 192), UIColorFromRGB(225, green: 224, blue: 226)),
    (UIColorFromRGB(25, green: 99, blue: 242),   UIColorFromRGB(134, green: 136, blue: 238))
]

class PlanModel: NSObject, NSCoding {
    var image: UIImage!
    var text: String!
    var reminderText: String!
    var reminderTime: Date! // fine to use
    
    // set of weekIndexes, 0 as Monday
    var chosenWeeks = NSMutableSet()
    var remindedWeeks = NSMutableSet()
    
    // other users involved
    var involved = NSMutableSet() // id is saved, string
    
    // MARK: --------------- NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(image, forKey: "planImage")
        aCoder.encode(text, forKey: "planText")
        aCoder.encode(reminderText, forKey: "reminderText")
        aCoder.encode(reminderTime, forKey: "reminderTime")
        
        aCoder.encode(chosenWeeks, forKey: "chosenWeeks")
        aCoder.encode(remindedWeeks, forKey: "remindedWeeks")
        
        aCoder.encode(involved, forKey: "usersInvolved")
    }
    
    override init() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init()
        
        image = aDecoder.decodeObject(forKey: "planImage") as? UIImage
        text = aDecoder.decodeObject(forKey: "planText") as? String
        reminderText = aDecoder.decodeObject(forKey: "reminderText") as? String
        reminderTime = aDecoder.decodeObject(forKey: "reminderTime") as? Date
        
        chosenWeeks = aDecoder.decodeObject(forKey: "chosenWeeks") as! NSMutableSet
        remindedWeeks = aDecoder.decodeObject(forKey: "remindedWeeks") as! NSMutableSet
        
        involved = aDecoder.decodeObject(forKey: "usersInvolved") as! NSMutableSet
    }
    
    // MARK: ------- demo data --------
    class func getPlans() -> [PlanModel] {
        var plans = [PlanModel]()
        let texts = ["EAT A HEALTHY DIET", "Be Physically Active Every Day, Your Way", "GET VACCINATED", "DON’T USE ANY FORM OF TOBACCO", "AVOID OR MINIMIZE USE OF ALCOHOL", "Manage Stress for Your Physical and Mental Health", "PRACTICE GOOD HYGIENE", "DON’T SPEED, OR DRINK AND DRIVE", "WEAR A SEAT- BELT WHEN DRIVING ADN HELMET WHEN CYCLING", "PRACTICE SAFE SEX", "REGULARLY CHECK YOUR HEALTH", "BREAST FEEDING; BEST FOR BABIES"]
        
        for (i, text) in texts.enumerated() {
            let plan = PlanModel()
            plan.text = text
            plan.image = UIImage(named: "plan_\(i)")
            plans.append(plan)
        }
        
        return plans
    }
    
    // methods for judgement
    func isChosenForWeek(_ week: Int) -> Bool {
        return chosenWeeks.contains(week)
    }
    
    func isRemindedForWeek(_ week: Int) -> Bool {
        return remindedWeeks.contains(week)
    }
    
    func isChosenForDate(_ date: Date) -> Bool {
        let week = CalendarModel.getWeekIndexOfDate(date)
        return chosenWeeks.contains(week)
    }
    
    func isRemindedForDate(_ date: Date) -> Bool {
        let week = CalendarModel.getWeekIndexOfDate(date)
        return remindedWeeks.contains(week)
    }
}
