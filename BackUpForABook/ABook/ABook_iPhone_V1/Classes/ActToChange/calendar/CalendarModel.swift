//
//  CalendarModel.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/28.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CalendarModel {
    class func getMondayStartCalendarOfDate(_ date: Date) -> (monthDays: [Int] , weekDays: [Int], dayIndex: Int) {
        var calendar = Calendar.current
        calendar.firstWeekday = 2 // from Monday
        
        let totalDays = calendar.range(of: .day, in: .month, for: date)!.count
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        components.day = 1
        let firstDay = calendar.date(from: components)!
        let firstWeekday = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDay)!
      
        // the whole month
        var monthDays = [Int]()
        let totalNumber = totalDays + firstWeekday - 1
        for i in 0..<totalNumber {
            if i < firstWeekday - 1 {
                monthDays.append(0)
            }else {
                monthDays.append(i - firstWeekday + 2)
            }
        }
        
        // the core day( like, today)
        let dayIndex = calendar.component(.day, from: date) + firstWeekday - 2
        
        // the week
        let rowIndex = dayIndex / 7
        var weekDays = [Int]()
        for i in rowIndex * 7 ..< (rowIndex + 1) * 7 {
            weekDays.append(monthDays[i])
        }
        
        return (monthDays, weekDays, dayIndex)
    }
    
    // monday as 0
    class func getWeekIndexOfDate(_ date: Date) -> Int {
        var weekday = Calendar.current.component(.weekday, from: date)

        if weekday == 1 {
            // Sunday
            weekday = 6
        }else {
            weekday -= 2
        }
        
        return weekday
    }
    
    // the dates for this month
    class func getDaysOfMonthForDate(_ date: Date) -> [Date] {
        var days = [Date]()
        let calendar = Calendar.current
        
        let totalDays = calendar.range(of: .day, in: .month, for: date)!.count
        var components = calendar.dateComponents([.year, .month, .day], from: date)
        for i in 1...totalDays {
            components.day = i
            days.append(calendar.date(from: components)!)
        }
        
        return days
    }
    
    // compare
    class func theSameDay(day1: Date, day2: Date) -> Bool {
        let components1 = Calendar.current.dateComponents([.year, .month, .day], from: day1)
        let components2 = Calendar.current.dateComponents([.year, .month, .day], from: day2)
        
        if components1.day == components2.day && components1.month == components2.month && components1.year == components1.year {
            return true
        }else {
            return false
        }
    }
    
    // get the age
    class func ageForDateOfBirth(_ birthday: Date!) -> Int {
        if birthday == nil {
            return 0
        }
        
        let birthdayComponents = Calendar.current.dateComponents([.year, .month, .day], from: birthday)
        let currentComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var age = birthdayComponents.year! - currentComponents.year!
        if birthdayComponents.month! < currentComponents.month! {
            age -= 1
        }else if birthdayComponents.month == currentComponents.month! {
            if birthdayComponents.day! < currentComponents.day! {
                age -= 1
            }
        }
        
        return max(age, 0)
    }
}

