//
//  IndiSummaryView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/23.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class IndividualSummaryTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    let factory = VDeckOfCardsFactory.metricDeckOfCards
    
    var metrics: [MetricObjModel] {
        var cardMetrics = [MetricObjModel]()
        for i in 0..<factory.totalNumberOfItems() {
            if let metric = factory.getVCard(i)?.metric {
            cardMetrics.append(metric)
            }
        }
        
        return cardMetrics
    }
    
    fileprivate var answered = 0
    class func createWithFrame(_ frame: CGRect, answered: Int) -> IndividualSummaryTableView {
        let table = IndividualSummaryTableView(frame: frame, style: .plain)
        table.answered = answered
        
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2 + factory.totalNumberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let headerCell = SummaryHeaderCell.cellWithTableView(tableView, relatedNumber: answered, totalNumber: factory.totalNumberOfItems())
            headerCell.titleLabel.text = "Individual Summary"

            return headerCell
        case 1:
            let overallCell = IndividualOverallCell.cellWithTableView(tableView)
            return overallCell
        default:
            let metric = metrics[indexPath.row - 2]
            let metricCell = MetricInfoCell.cellWithTableView(tableView, metric: metric)
            return metricCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 0.2 * bounds.height
        case 1:
            return 0.4 * bounds.height
        default:
            return 0.1 * bounds.height
        }
        
    }
}
