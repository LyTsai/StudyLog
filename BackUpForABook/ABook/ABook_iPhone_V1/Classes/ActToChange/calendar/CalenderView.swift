//
//  CalenderView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/4/27.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class CalendarLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        scrollDirection = .vertical
        sectionInset = UIEdgeInsets.zero
        minimumLineSpacing = 0
        minimumInteritemSpacing = 0
        
        let collectionWidth = collectionView!.bounds.width
        let cellWidth = collectionWidth / 7
        
        headerReferenceSize = CGSize(width: 10, height: cellWidth * 1.16)
        itemSize = CGSize(width: cellWidth, height: cellWidth)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}


class CalendarView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate {

    weak var hostTable: PlanDisplayTableView!
    var coreDay = Date() {
        didSet{
            // dataSource
            let result = CalendarModel.getMondayStartCalendarOfDate(coreDay)
            monthDays = result.monthDays
            weekDays = result.weekDays
            dayIndex = result.dayIndex
            
            // reload if the cell can be selected
        }
    }
    fileprivate var monthDays = [Int]()
    fileprivate var weekDays = [Int]()
    fileprivate var dayIndex = -1
    var showAll = false {
        didSet{
            chosenItem = -1
            reloadData()
            
            if hostTable != nil {
                hostTable.showAll = showAll
            }
        }
    }
        
    class func createWithFrame(_ frame: CGRect, coreDay: Date, showAll: Bool) -> CalendarView {
        let calendar = CalendarView(frame: frame, collectionViewLayout: CalendarLayout())
        calendar.backgroundColor = UIColor.white
        calendar.coreDay = coreDay
        calendar.showAll = showAll

        // register
        calendar.register(CalendarHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: calendarHeaderID)
        calendar.register(CalendarCell.self, forCellWithReuseIdentifier: calendarCellID)
        
        calendar.dataSource = calendar
        calendar.delegate = calendar
        
        return calendar
    }
    
    // dataSource
    // header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: calendarHeaderID, for: indexPath) as! CalendarHeader
        headerView.dateOnShow = coreDay
        headerView.hostViewDelegate = self
        
        return headerView
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showAll ? monthDays.count : weekDays.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCellID, for: indexPath) as! CalendarCell
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: CalendarCell, indexPath: IndexPath) {
        let day = showAll ? monthDays[indexPath.item] : weekDays[indexPath.item]
        let todayIndex = showAll ? dayIndex : dayIndex % 7
        let weekIndex = indexPath.item % 7
        
        cell.day = day
        cell.isWeekend = (weekIndex == 5 || weekIndex == 6)
        cell.isToday = (indexPath.item == todayIndex)
        cell.isChosen = (indexPath.item == chosenItem)
        
        var planState = PlanState.none
        for plan in hostTable.plans {
            if plan.isChosenForWeek(weekIndex) {
                if indexPath.item > todayIndex {
                    planState = .planned
                }else if indexPath.item % 4 == 0 {
                    planState = .missed
                }else {
                    planState = .finished
                }
                
                break
            }
        }
        
        cell.planState = planState
    }
    
    // delegate
    fileprivate var chosenItem: Int = -1 {
        didSet {
            if chosenItem != oldValue {
                if chosenItem == -1 {
//                    performBatchUpdates({
//                        self.reloadItems(at: [IndexPath(item: oldValue, section: 0)])
//                    }, completion: nil)
                }else if oldValue == -1 {
                    performBatchUpdates({
                        self.reloadItems(at: [IndexPath(item: self.chosenItem, section: 0)])
                    }, completion: nil)
                }else {
                    performBatchUpdates({
                        self.reloadItems(at: [IndexPath(item: oldValue, section: 0), IndexPath(item: self.chosenItem, section: 0)])
                    }, completion: nil)
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let day = showAll ? monthDays[indexPath.item] : weekDays[indexPath.item]
        if day != 0 && showAll {
            chosenItem = indexPath.item
            hostTable.currentDate = getDateOfItem(indexPath.item)
        }
    }
    
    
    fileprivate func getDateOfItem(_ item: Int) -> Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: Date())

        if showAll {
            components.day = monthDays[item]
            return calendar.date(from: components)!
        } else {
            return Date()
        }
    }
}
