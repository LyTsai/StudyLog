//
//  ActToChangeView.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/1/14.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
let metricCellID = "metric Cell ID"
class MetricInfoCell: UITableViewCell {
    
    fileprivate var metricImageView = UIImageView()
    fileprivate var nameLabel = UILabel()
    fileprivate var riskCollection : RiskCollectionView!
    
    class func cellWithTableView(_ tableView: UITableView, metric: MetricObjModel)-> MetricInfoCell {
        var infoCell = tableView.dequeueReusableCell(withIdentifier: metricCellID) as? MetricInfoCell
        if infoCell == nil {
            infoCell = MetricInfoCell(style: .default, reuseIdentifier: metricCellID)
            infoCell?.backgroundColor = UIColorGray(248)
            
            // addCollection
            infoCell!.riskCollection = RiskCollectionView.createRiskCollectionWithFrame(CGRect.zero, dataSourceMetirc: metric)
            infoCell!.addSubview(infoCell!.riskCollection)
            infoCell!.addSubview(infoCell!.metricImageView)
            infoCell!.addSubview(infoCell!.nameLabel)
        }
        
        infoCell!.metricImageView.image = metric.imageObj
        infoCell!.nameLabel.text = metric.name
        infoCell!.riskCollection.dataSourceMetirc = metric
        
        return infoCell!
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let imageLength = bounds.height * 0.92
        metricImageView.frame = CGRect(center: CGPoint(x: 10 + imageLength * 0.5, y: bounds.midY), length: imageLength)
        
        let labelX = metricImageView.frame.maxX + 4
        let rightWidth = bounds.width - labelX - 10
        let hRatio: CGFloat = 0.36
        
        nameLabel.frame = CGRect(x: labelX, y: 0, width: rightWidth, height: bounds.height * hRatio)
        nameLabel.font = UIFont.systemFont(ofSize: bounds.height * hRatio / 2.6)
        riskCollection.frame = CGRect(x: labelX, y: bounds.height * hRatio, width: rightWidth, height: bounds.height * (1 - hRatio))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        riskCollection.dataSourceMetirc = nil
    }
}



class MetricInfoTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    fileprivate var metrics = [MetricObjModel]()
    fileprivate var selectedMetric: MetricObjModel!
    
    class func createTableViewWithFrame( _ frame: CGRect) -> MetricInfoTableView {
        let table = MetricInfoTableView(frame: frame, style: .plain)
        table.separatorStyle = .none
        let metricKeys = AIDMetricCardsCollection.standardCollection.getMetrics()
        for key in metricKeys {
            if let metric = AIDMetricCardsCollection.standardCollection.getMetric(key) {
                table.metrics.append(metric)
            }
        }
        table.allowsSelection = false
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metrics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MetricInfoCell.cellWithTableView(tableView, metric: metrics[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    // selected metric
    func scrollTableToMetric(_ metricKey: String!) {
        var index: Int!

        if metricKey == nil {
            return
        }
        
        for (i, metric) in metrics.enumerated() {
            if metric.key == metricKey {
                index = i
                selectedMetric = metric
                break
            }
        }
        
        if index == nil {
            print("wrong, no such metric")
            return
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        scrollToRow(at: indexPath, at: .top, animated: true)
        // change backgroundColor ??
    }
}


