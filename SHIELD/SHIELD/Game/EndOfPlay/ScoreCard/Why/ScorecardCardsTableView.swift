//
//  ScorecardCardsTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/12/29.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation

class ScorecardCardsTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    fileprivate var measurement: MeasurementObjModel!
    class func createTable() -> ScorecardCardsTableView {
        let table = ScorecardCardsTableView(frame: CGRect.zero, style: .plain)
        table.backgroundColor = UIColor.clear
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.bounces = false
        table.dataSource = table
        table.delegate = table
        table.tableFooterView = UIView()
        
        return table
    }
    
    fileprivate var showComplementary = false
    func loadAllCardsWithMeasurement(_ measurement: MeasurementObjModel) {
        self.measurement = measurement
        showComplementary = (MatchedCardsDisplayModel.getMatchedComplementaryCardsInMeaurement(measurement).count != 0)
        reloadData()
    }
    
    // dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return showComplementary ? 2 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ScorecardCardsTableViewCell.cellWithTableView(tableView, measurment: measurement, factorType: indexPath.section == 0 ? .score : .complementary)
        cell.table = self
        cell.indexPath = indexPath
        
        return cell
    }
    
    fileprivate var cellHeights = [IndexPath: CGFloat]()
    func cellHeightIsCalculatedFor(_ indexPath: IndexPath, cellHeight: CGFloat) {
        if let current = cellHeights[indexPath] {
            if abs(cellHeight - current) > 1 {
                cellHeights[indexPath] = cellHeight
                reloadData()
            }
        }else {
            cellHeights[indexPath] = cellHeight
            reloadData()
        }
    }
    
    // delegate
    fileprivate var headerHeight: CGFloat {
        return bounds.width / 363 * 87
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = ScorecardHeaderTagView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: headerHeight))
        header.setupForScore(section == 0)
        
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 100
    }
}
