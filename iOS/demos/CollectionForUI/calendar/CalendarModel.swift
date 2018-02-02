//
//  CalendarModel.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CalendarModel {
//    var plan: PlanModel!
//    var planState = PlanState.none
    
    class func getMondayStartCalendarOfDate(_ date: Date) -> (days: [Int] , dayIndex: Int) {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // from Monday
        
        let totalDays = calendar.range(of: .day, in: .month, for: date)!.count
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.day = 1
        let firstDay = calendar.date(from: components)!
        let firstWeekday = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDay)!
      
        let totalNumber = totalDays + firstWeekday - 1
        var days = [Int]()
        
        for i in 0..<totalNumber {
            if i < firstWeekday - 1 {
                days.append(0)
            }else {
                days.append(i - firstWeekday + 2)
            }
        }
        
        let dayOfDate = calendar.component(.day, from: date) + firstWeekday - 2
        
        return (days, dayOfDate)
    }
}

