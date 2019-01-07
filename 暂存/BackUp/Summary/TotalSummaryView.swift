//
//  TotalSummary.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/23.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class TotalSummaryTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var classifiedMetrics = (warn: [MetricObjModel](), caution: [MetricObjModel](), keep: [MetricObjModel]())
    fileprivate var colors = [warnColor, cautionColor, keepColor]
    fileprivate var folded = [false, true, true]
    
    class func createWithFrame(_ frame: CGRect) -> TotalSummaryTableView {
        let table = TotalSummaryTableView(frame: frame, style: .plain)
        
        // get data
        table.fillMetricData()
        table.fillAdviceData()
        
        // style
        if table.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            table.separatorInset = UIEdgeInsets.zero
        }
        if table.responds(to: #selector(setter: UIView.layoutMargins)) {
            table.layoutMargins = UIEdgeInsets.zero
        }
        
        // delegate
        table.dataSource = table
        table.delegate = table
        
        return table
    }
    
    // metric
    fileprivate var totalNumber = 0
    fileprivate var relatedNumber = 0
    fileprivate func fillMetricData() {
        let metricKeys = AIDMetricCardsCollection.standardCollection.getMetrics()
        totalNumber = (AIDMetricCardsCollection.standardCollection.getMetricObjs()?.count)!
        relatedNumber = metricKeys.count
    
        for (index, key) in metricKeys.enumerated() {
            let metric = AIDMetricCardsCollection.standardCollection.getMetric(key)
            if index % 3 == 0 {
                classifiedMetrics.warn.append(metric!)
            }else if index % 3 == 1 {
                classifiedMetrics.caution.append(metric!)
            }else {
                classifiedMetrics.keep.append(metric!)
            }
        }
    }
    
    // advice, just test now
    fileprivate var advices = [(name: String, image: UIImage?, detail: String?)]()
    fileprivate func fillAdviceData() {
        advices.append(("Take VD", UIImage(named: "icon_risk_VD"), "The onset of rectal cancer is by rectal tissue cell malignant transformation and the formation, with improvement of "))
        advices.append(("Jogging", UIImage(named: "icon_risk_VD"), "The onset of rectal cancer is by rectal tissue cell malignant transformation and the formation, with improvement of "))
        advices.append(("Sleep well", UIImage(named: "icon_risk_VD"), "The onset of rectal cancer is by rectal tissue cell malignant transformation and the formation, with improvement of "))
        advices.append(("keep diet", UIImage(named: "icon_risk_VD"), "The onset of rectal cancer is by rectal tissue cell malignant transformation and the formation, with improvement of "))
    }
    
    // MARK: ----------------------- dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1
            // metrics
        case 1: return folded[0] ? 0 : classifiedMetrics.warn.count
        case 2: return folded[1] ? 0 : classifiedMetrics.caution.count
        case 3: return folded[2] ? 0 : classifiedMetrics.keep.count
            // advice
        default: return advices.count
        }
    }
    fileprivate var selectedIndexPath = IndexPath(row: 0, section: 0)
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return SummaryHeaderCell.cellWithTableView(tableView, relatedNumber: relatedNumber, totalNumber: totalNumber)
        }
        if indexPath.section == 4 {
            let advice = advices[indexPath.row]
            let selected = (indexPath == selectedIndexPath)
            return SummaryAdviceCell.cellWithTableView(tableView, adviceName: advice.name, detailImage: advice.image, detailText: advice.detail, selected: selected)
        }
        
        var metrics = [MetricObjModel]()
        switch indexPath.section {
        case 1: metrics = classifiedMetrics.warn
        case 2: metrics = classifiedMetrics.caution
        case 3: metrics = classifiedMetrics.keep
        default: break
        }
        let cell = SummaryMetricCell.cellWithTableView(tableView, metric: metrics[indexPath.row], color: colors[indexPath.section - 1])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // header
        if section == 0  {
            return nil
        }
        
        // super for add
        let headerView = UIView(frame: CGRect(x: -1, y: 0, width: bounds.width + 2, height: 27))
        headerView.layer.borderColor = UIColor.lightGray.cgColor
        headerView.layer.borderWidth = 0.5
        headerView.backgroundColor = UIColor.white
        
        // advice
        if section == 4 {
            let label = UILabel(frame: CGRect(x: 28, y: 2, width: bounds.width / 2, height: 44))
            label.textColor = keepColor
            label.text = "Top things"
            headerView.addSubview(label)
            
            return headerView
        }
        
        // label
        let label = UILabel(frame: CGRect(x: 10, y: 2.5, width: bounds.width / 3, height: 22))
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        
        switch section {
        case 1: label.text = "  warn"
        case 2: label.text = "  caution"
        case 3:label.text = "  keep"
        default: break
        }
        
        label.backgroundColor = colors[section - 1]
        headerView.addSubview(label)
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(center: CGPoint(x: bounds.width - 42, y: 13), length: 22)
        button.setImage(UIImage(named: "arrow_down_green"), for: .normal)
        button.tag = 99 + section
        button.addTarget(self, action: #selector(changeSectionState(_:)), for: .touchUpInside)
        button.transform = CGAffineTransform(rotationAngle: folded[section - 1] ? 0 : CGFloat(Double.pi))
        
        headerView.addSubview(button)
        
        return headerView
    }
    
    func changeSectionState(_ button: UIButton)  {
        let index = button.tag - 100
        folded[index] = !folded[index]

        // cell
        reloadSections(IndexSet(integer: index + 1), with: .automatic)

        if folded[index] == false {
            scrollToRow(at: IndexPath(row: 0, section: index + 1), at: .top, animated: true)
        }
    }
    /*
     func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
         let header = view as! UITableViewHeaderFooterView
         header.textLabel?.textColor = keepColor
     }
     */
    // MARK: ----------------------- delegate
    // styles
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0: return 96
        case 4: return (indexPath == selectedIndexPath) ? 122 : 42
        default: return 63
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0: return 0.01
        case 4: return 44
        default: return 27
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    
    // actions
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 4 {
            if selectedIndexPath == indexPath {
                selectedIndexPath = IndexPath(row: 0, section: 0)
                reloadRows(at: [indexPath], with: .automatic)
            }else {
                let old = selectedIndexPath
                selectedIndexPath = indexPath
                reloadRows(at: [old, indexPath], with: .automatic)
            }
        }
    }
}

