//
//  TotalSummaryCells.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/23.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
let xibName = "TotalSummaryCells"

// MARK: -------------- header cell ---------------
let summaryHeaderCellID = "summaryHeaderCellID"
class SummaryHeaderCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var totalResultLabel: UILabel!
    
    class func cellWithTableView(_ tableView: UITableView, relatedNumber: Int, totalNumber: Int) -> SummaryHeaderCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: summaryMetricCellID) as? SummaryHeaderCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?.first as? SummaryHeaderCell
            cell?.selectionStyle = .none
        }
     
        cell!.totalResultLabel.text = "Risks: \(relatedNumber)/\(totalNumber)"
        return cell!
    }
    
    
    @IBAction func mail(_ sender: Any) {
        // send mail
    }

    
    @IBAction func print(_ sender: Any) {
        // print
    }
}

// MARK: -------------- metric cell ---------------
let summaryMetricCellID = "Summary Metric Cell Identifier"
class SummaryMetricCell: UITableViewCell {
    
    fileprivate weak var collection: RiskClassCollectionView!
    fileprivate var iconView = UIImageView()
    class func cellWithTableView(_ tableView: UITableView, metric: MetricObjModel, color: UIColor) -> SummaryMetricCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: summaryMetricCellID) as? SummaryMetricCell
        
        if cell == nil {
            cell = SummaryMetricCell(style: .default, reuseIdentifier: summaryMetricCellID)
            cell!.setupUI()
        }
        cell!.collection.metric = metric
        cell!.iconView.image = metric.imageObj
        cell!.iconView.layer.borderColor = color.cgColor
        
        return cell!
    }
    
    fileprivate func setupUI() {
        // main
        selectionStyle = .none
        
        // sub
        collection = RiskClassCollectionView.createWithFrame(CGRect.zero, metric: MetricObjModel())
        iconView.layer.borderWidth = 1
        iconView.layer.masksToBounds = true
        
        addSubview(iconView)
        addSubview(collection)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let hMargin = 5 / 375 * bounds.width
        let iconLenght = 36 * bounds.height / 63
        let iconFrame = CGRect(x: hMargin, y: bounds.height - hMargin - iconLenght, width: iconLenght, height: iconLenght)
        let collectionFrame = CGRect(x: iconFrame.maxX + hMargin, y: 0, width: bounds.width - iconFrame.maxX - 2 * hMargin, height: bounds.height)
        
        iconView.frame = iconFrame
        iconView.layer.cornerRadius = iconLenght * 0.5
        collection.frame = collectionFrame
    }
}

let summaryAdviceCellID1 = "Summary Advice ID 1"
let summaryAdviceCellID2 = "Summary Advice ID 2"
class SummaryAdviceCell: UITableViewCell {
    @IBOutlet weak var adviceNameLabel: UILabel!
    @IBOutlet weak var indiArrowImageView: UIImageView!
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailLabel: UILabel!
    
    class func cellWithTableView(_ tableView: UITableView, adviceName: String?, detailImage: UIImage?, detailText: String?, selected: Bool) -> SummaryAdviceCell {
        var cell: SummaryAdviceCell!
        
        if selected {
            cell = tableView.dequeueReusableCell(withIdentifier: summaryAdviceCellID2) as? SummaryAdviceCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?[2] as? SummaryAdviceCell
                cell.indiArrowImageView.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                
                // UI adjust
                cell.detailLabel.textColor = UIColorGray(130)
                cell.detailImageView.layer.cornerRadius = 2
                cell.detailImageView.layer.borderColor = keepColor.cgColor
                cell.detailImageView.layer.borderWidth = 1
                cell.detailImageView.layer.masksToBounds = true
            }
            
            // fill data of details
            cell.detailImageView.image = detailImage
            cell.detailLabel.text = detailText
            
        }else {
            cell = tableView.dequeueReusableCell(withIdentifier: summaryAdviceCellID1) as? SummaryAdviceCell
            if cell == nil {
                cell = Bundle.main.loadNibNamed(xibName, owner: self, options: nil)?[1] as? SummaryAdviceCell
            }
        }
        
        // fill name data
        cell.selectionStyle = .none
        cell.adviceNameLabel.text = adviceName
        
        return cell
    }
}
