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


class CalendarView: UICollectionView, UICollectionViewDataSource {

    let today = Date()
    fileprivate var days = [Int]()
    fileprivate var dayIndex = -1
    
    class func createWithFrame(_ frame: CGRect, showAll: Bool) -> CalendarView {
        let calendar = CalendarView(frame: frame, collectionViewLayout: CalendarLayout())
        calendar.backgroundColor = UIColor.white
        
        calendar.register(CalendarHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: calendarHeaderID)
        calendar.register(CalendarCell.self, forCellWithReuseIdentifier: calendarCellID)
        
        let result = CalendarModel.getMondayStartCalendarOfDate(Date())
        calendar.days = result.days
        calendar.dayIndex = result.dayIndex
        
        calendar.dataSource = calendar
        
        return calendar
    }
    
    // dataSource
    // header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: calendarHeaderID, for: indexPath) as! CalendarHeader
        headerView.dateOnShow = today
        
        return headerView
    }
    
    // cell
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarCellID, for: indexPath) as! CalendarCell
        configureCell(cell, indexPath: indexPath)
        
        return cell
    }
    
    fileprivate func configureCell(_ cell: CalendarCell, indexPath: IndexPath) {
        let day = days[indexPath.row]
        cell.day = day
        
        cell.isWeekend = (indexPath.row % 7 == 5 || indexPath.row % 7 == 6)
        cell.isToday = (indexPath.row == dayIndex)

        cell.planState = .none
    }
}
