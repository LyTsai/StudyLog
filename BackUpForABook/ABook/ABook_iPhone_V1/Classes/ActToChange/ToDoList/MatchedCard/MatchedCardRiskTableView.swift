//
//  MatchedCardRiskTableView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/6/7.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class MatchedCardRiskTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var risks = [RiskObjModel]() {
        didSet{
            if risks != oldValue {
                resetRiskGroup(risks)
                if risks.count != oldValue.count {
                    // change frame
                    let height = min(maxHeight, cellHeight * CGFloat(riskGroup.count))
                    frame = CGRect(origin: frame.origin, size: CGSize(width: frame.width, height: height))
                }
                reloadData()
            }
        }
    }
    
    // read only, an array, with sequenece
    fileprivate var riskGroup = [(MetricObjModel,[RiskObjModel])]()
    fileprivate func resetRiskGroup(_ risks: [RiskObjModel]){
        riskGroup.removeAll()
        
        var groupDic = [MetricObjModel: [RiskObjModel]]()
        for risk in risks {
            if risk.metricKey == nil {
                print("no metric")
                continue
            }
            
            var metric = risk.metric
            if metric == nil {
                metric = AIDMetricCardsCollection.standardCollection.getMetric(risk.metricKey!)
            }
            
            if metric == nil {
                print("no metric")
                continue
            }
            
            if groupDic[metric!] == nil {
                groupDic[metric!] = [risk]
            }else {
                groupDic[metric!]?.append(risk)
            }
        }
        
        for (key, value) in groupDic {
            riskGroup.append((key, value))
        }
    }
    
    fileprivate var cellHeight: CGFloat = 0
    fileprivate var maxHeight: CGFloat = 0
    class func createWithFirstFrame(_ frame: CGRect, maxHeight: CGFloat, risks: [RiskObjModel]) -> MatchedCardRiskTableView {
        let table = MatchedCardRiskTableView(frame: frame, style: .plain)
        table.cellHeight = frame.height
        table.maxHeight = maxHeight
        
        table.risks = risks // call method of adjust
        
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    // MARK: --------- dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riskGroup.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let groupObj = riskGroup[indexPath.item]
        
        return MatchedCardRiskCell.cellWithTableView(tableView, metric: groupObj.0, risks: groupObj.1)
    }
    
    
    // MARK: --------- delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

