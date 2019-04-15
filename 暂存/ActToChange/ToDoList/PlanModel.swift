//
//  PlanModel.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/24.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

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
        let week = CalendarCenter.getWeekIndexOfDate(date)
        return chosenWeeks.contains(week)
    }
    
    func isRemindedForDate(_ date: Date) -> Bool {
        let week = CalendarCenter.getWeekIndexOfDate(date)
        return remindedWeeks.contains(week)
    }
}
