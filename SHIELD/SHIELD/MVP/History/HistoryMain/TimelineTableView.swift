//
//  TimelineTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/11/21.
//  Copyright © 2018年 AnnielyticX. All rights reserved.
//

import Foundation
enum TimelineType {
    case monthline
    case dayline
    
}

class TimelineTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource = self
        self.delegate = self
    }
    
    /** tableIndexPath: collectionViewIndexPath */
    fileprivate var chosenInfo = [IndexPath: Set<IndexPath>]()
    fileprivate var timelineType = TimelineType.monthline
    fileprivate var tableDetailData = [[[MeasurementObjModel]]]() // ([collection's [measurements]])
    func setupWithMeasurements(_ measurements: [MeasurementObjModel], timelineType: TimelineType) {
        self.timelineType = timelineType
        tableDetailData.removeAll()
        chosenInfo.removeAll()
        
        var tableDic = [Int: [MeasurementObjModel]]()
        for one in measurements {
            var iden = 0
            let date = ISO8601DateFormatter().date(from: one.timeString)!
            switch timelineType {
            case .monthline: iden = CalendarCenter.getMonthOfDate(date)
            case .dayline: iden = CalendarCenter.getDayOfDate(date)
            }
            
            if tableDic[iden] == nil {
                tableDic[iden] = [one]
            }else {
                tableDic[iden]!.append(one)
            }
        }
        
        // collectionView data
        var tableDetail = [(Int, [[MeasurementObjModel]])]()
        for (time, measurements) in tableDic {
            var dataArray = [[MeasurementObjModel]]()
            
            var sortDic = [String: [MeasurementObjModel]]()
            for one in measurements {
                var key = ""
                switch timelineType {
                case .dayline: key = one.timeString
                case .monthline: key = collection.getRisk(one.riskKey)!.metricKey!
                }
                if sortDic[key] != nil {
                    sortDic[key]!.append(one)
                }else {
                    sortDic[key] = [one]
                }
            }
            
            var sortArray = [(String, [MeasurementObjModel])]()
            for (key, value) in sortDic {
                var sortKey = ""
                switch timelineType {
                case .dayline: sortKey = key
                case .monthline:
                    sortKey = "\(collection.getMetric(key)!.seqNumber ?? 0)"
                }
                sortArray.append((sortKey, value))
            }
            sortArray.sort(by: { $0.0 < $1.0})
            
            for (_, value) in sortArray {
                dataArray.append(value)
            }
            
            tableDetail.append((time, dataArray))
        }
        tableDetail.sort(by: {$0.0 > $1.0})
            
        for (_, data) in tableDetail {
            tableDetailData.append(data)
        }
    }

    func setupChosenInfo(_ chosen: [MeasurementObjModel]) {
        chosenInfo.removeAll()
        for (row, collectionData) in tableDetailData.enumerated() {
            let tableIndex = IndexPath(row: row, section: 0)
            var collectionIndexPathes = Set<IndexPath>()

            for (item, measurments) in collectionData.enumerated() {
                for measurement in chosen {
                    if measurments.contains(measurement) {
                        collectionIndexPathes.insert(IndexPath(item: item, section: 0))
                    }
                }
            }

            if collectionIndexPathes.count != 0 {
                chosenInfo[tableIndex] = collectionIndexPathes
            }
        }
    }
    
    // dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDetailData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TimelineCell.cellWithTableView(self, collectionData: tableDetailData[indexPath.item], timelineType: timelineType, chosenInfo: chosenInfo[indexPath] ?? [])
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch timelineType {
        case .monthline: return UIView()
        case .dayline:
            let firstX = 0.15 * bounds.width
            let anchorL = 10 * fontFactor
            let header = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: 80 * fontFactor))
            header.backgroundColor = UIColor.clear
            
            let monthLabel = UILabel(frame: CGRect(x: 0, y: 0, width: firstX - anchorL, height: header.frame.height))
            monthLabel.textAlignment = .right
            monthLabel.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
            
            let timeString = tableDetailData[0].first!.first?.timeString
            let date = ISO8601DateFormatter().date(from: timeString!)
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM"
            monthLabel.text = formatter.string(from: date!)
            monthLabel.backgroundColor = UIColor.white
            
            let anchorLayer = CAShapeLayer()
            anchorLayer.path = UIBezierPath(ovalIn: CGRect(center: CGPoint(x: firstX, y: header.bounds.midY), length: anchorL)).cgPath
            anchorLayer.lineWidth = 2
            anchorLayer.fillColor = UIColorFromHex(0xFF9E9C).cgColor
            anchorLayer.strokeColor = UIColorFromHex(0xEE6D6B).cgColor
            
            let backHint = UILabel(frame: CGRect(x: firstX + anchorL, y: 0, width: bounds.width - firstX - anchorL, height: header.frame.height))
            backHint.text = "◀︎ Back to Month"
            backHint.font = UIFont.systemFont(ofSize:  12 * fontFactor)
            backHint.backgroundColor = UIColor.white
            
            let tapGR = UITapGestureRecognizer(target: self, action: #selector(goBackToMonth))
            header.addGestureRecognizer(tapGR)
            
            header.addSubview(monthLabel)
            header.layer.addSublayer(anchorLayer)
            header.addSubview(backHint)
            
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    // delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 * fontFactor
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return timelineType == .monthline ? 0.01 : 80 * fontFactor
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40 * standHP
    }
    
    @objc func goBackToMonth() {
        if viewController.isKind(of: HistoryMapViewController.self) {
            let vc = viewController as! HistoryMapViewController
            vc.backToMonthTable()
        }
    }
}
