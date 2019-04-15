//
//  ScorecardAblumTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/5/9.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
// sort

class ScorecardAlbumTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundView = nil
        self.delegate = self
        self.dataSource = self
    }
    
    var reverse = false {
        didSet{
            if reverse != oldValue {
                switch sortRule {
                case .gameSubject:
                    subjectTableData.reverse()
                case .gameType:
                    typeTableData.reverse()
                case .date:
                    dateTableData.reverse()
                }
                reloadData()
            }
        }
    }
    
    var risks = [String]() {
        didSet{
            setSubjectTableData()
            setTypeTableData()
            setDateTableData()
        }
    }
    var sortRule = AlbumSortRule.gameSubject {
        didSet{
           reloadData()
        }
    }
    
    // kinds of data
    // by subject
    fileprivate var subjectTableData = [(subject: String, risks: [String])]()
    fileprivate func setSubjectTableData() {
        var dic = [String : [String]]()
        for key in risks {
            if let risk = collection.getRisk(key) {
                if let metricKey = risk.metricKey {
                    if dic[metricKey] == nil {
                        dic[metricKey] = [key]
                    }else {
                        dic[metricKey]!.append(key)
                    }
                }
            }
        }
        
        subjectTableData.removeAll()
        for (key, value) in dic {
            // sort risks?
            subjectTableData.append((key, value))
        }
        subjectTableData.sort(by: {
            collection.getMetric($0.subject)!.name < collection.getMetric($1.subject)!.name
        })
    }

    // by name
    fileprivate var typeTableData = [(type: String, risks: [String])]()
    fileprivate func setTypeTableData() {
        var dic = [String : [String]]()
        for key in risks {
            if let risk = collection.getRisk(key) {
                if let type = risk.riskTypeKey {
                    if dic[type] == nil {
                        dic[type] = [key]
                    }else {
                        dic[type]!.append(key)
                    }
                }
            }
        }
        
        typeTableData.removeAll()
        for (key, value) in dic {
            // sort risks?
            typeTableData.append((key, value))
        }
        typeTableData.sort(by: {
            collection.getRiskTypeByKey($0.type)!.seqNumber ?? 0 < collection.getRiskTypeByKey($1.type)!.seqNumber ?? 0
        })
    }
    
    // by date
    fileprivate var dateTableData = [(date: String, risks: [String])]()
    fileprivate func setDateTableData() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd, yyyy"
        
        let sortFormatter = ISO8601DateFormatter()
        
        var transDic = [String: String]()
        var dic = [String : [String]]()
        for key in risks {
            if let _ = collection.getRisk(key) {
                var dateS = formatter.string(from: Date())
                var standS = sortFormatter.string(from: Date())
                
                if let m = selectionResults.getLastMeasurementOfUser(userCenter.currentGameTargetUser.Key(), riskKey: key) {
                    dateS = formatter.string(from: m.time)
                    standS = sortFormatter.string(from: m.time)
                }
                
                if dic[dateS] == nil {
                    dic[dateS] = [key]
                    transDic[dateS] = standS
                }else {
                    dic[dateS]!.append(key)
                }
            }
        }
        
        dateTableData.removeAll()
        for (key, value) in dic {
            // sort risks?
            dateTableData.append((key, value))
        }
        dateTableData.sort(by: {
            transDic[$0.date]! < transDic[$1.date]!
        })

    }
    // dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        switch sortRule {
        case .gameSubject: return subjectTableData.count
        case .gameType: return typeTableData.count
        case .date: return dateTableData.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch sortRule {
        case .gameSubject: return subjectTableData[section].risks.count
        case .gameType: return typeTableData[section].risks.count
        case .date: return dateTableData[section].risks.count
        }
    }
    
//    fileprivate func getDataInfoForSection(_ section: Int) -> [(multiple: Bool, key: String)] {
//        var allKeys =  [(multiple: Bool, key: String)]()
//        if let data = tableData[riskClassesOnDisplay[section]] {
//            for (type, risks) in data {
//                if risks.count == 1 {
//                    allKeys.append((false, risks.first!))
//                }else {
//                    allKeys.append((false, type))
//                    for riskKey in risks {
//                        allKeys.append((true, riskKey))
//                    }
//                }
//            }
//        }
//        
//        return allKeys
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: ScorecardAlbumCell!
        var risk: String! {
            switch sortRule {
            case .gameSubject: return subjectTableData[indexPath.section].risks[indexPath.row]
            case .gameType: return typeTableData[indexPath.section].risks[indexPath.row]
            case .date: return dateTableData[indexPath.section].risks[indexPath.row]
            }
        }
        cell = ScorecardAlbumCell.cellWithTableView(tableView, riskKey: risk, userKey: userCenter.currentGameTargetUser.Key(), sortRule: sortRule, isLast: indexPath.item == numberOfRows(inSection: indexPath.section) - 1, row: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var name = ""
        var typeName: String!
        var typeColor: UIColor!
        var imageUrl: URL!
        switch sortRule {
        case .gameSubject:
            let metricKey = subjectTableData[section].subject
            if let metric = collection.getMetric(metricKey) {
                name = metric.name
                imageUrl = metric.imageUrl
            }
        case .gameType:
            let typeKey = typeTableData[section].type
            name = collection.getFullNameOfRiskType(typeKey)
            typeName = collection.getAbbreviationOfRiskType(typeKey)
            if let type = collection.getRiskTypeByKey(typeKey) {
               typeColor = type.realColor
            }
        case .date:
            name = dateTableData[section].date
        }
        
        let header = ScorecardAlbumHeaderView.createWithName(name, typeName: typeName, typeColor: typeColor, imageUrl: imageUrl)
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        
        return view
    }
    
    // delegate
    // heights
    fileprivate var oneW: CGFloat {
        return bounds.width / 345
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 42 * oneW
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44 * oneW
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20 * oneW
    }

}
