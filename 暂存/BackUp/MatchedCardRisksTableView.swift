//
//  MatchedCardRisksTableView.swift
//  AnnieLyticx
//
//  Created by iMac on 2017/12/4.
//  Copyright © 2017年 AnnieLyticx. All rights reserved.
//

import Foundation





//let matchedCardRiskCellID = "matched card risk cell identifier"

// cell for layout
//class MatchedCardRiskCell: UITableViewCell {
//    class func cellWithTableView(_ tableView: UITableView, imageUrl: URL!, riskName: String!) -> MatchedCardRiskCell {
//        var cell = tableView.dequeueReusableCell(withIdentifier: matchedCardRiskCellID) as? MatchedCardRiskCell
//        if cell == nil {
//            // custom
//            cell = MatchedCardRiskCell(style: .default, reuseIdentifier: matchedCardRiskCellID)
//            cell!.imageView?.backgroundColor = UIColor.white
//            cell!.textLabel?.textAlignment = .left
//            cell!.backgroundColor = UIColor.clear
//            cell!.textLabel?.textColor = UIColor.white
//            cell!.textLabel?.numberOfLines = 0
//        }
//
//        // data
//        cell!.textLabel?.text = riskName
//        cell!.imageView?.sd_setShowActivityIndicatorView(true)
//        cell!.imageView?.sd_setIndicatorStyle(.gray)
//        cell!.imageView?.sd_setImage(with: imageUrl, placeholderImage: ProjectImages.sharedImage.indicator, options: .refreshCached, progress: nil) { (image, error, type, url) in
//        }
//
//        return cell!
//    }
//
//    // layout
//    override func layoutSubviews() {
//        super.layoutSubviews()
//
//        imageView?.layer.cornerRadius = bounds.height * 0.2
//
//        textLabel?.font = UIFont.systemFont(ofSize: bounds.height * 0.3, weight: UIFontWeightSemibold)
//        imageView?.frame = CGRect(center: CGPoint(x: bounds.width * 0.1, y: bounds.midY), length: bounds.height * 0.8)
//
//        // textLabel?.frame =
//    }
//}
//
//
//// risk table, a line
//class MatchedCardRisksTableView: UITableView {
//    var risks = [RiskObjModel]()
//    class func createWithFrame(_ frame: CGRect, risks: [RiskObjModel]) -> MatchedCardRisksTableView {
//        let table = MatchedCardRisksTableView(frame: frame, style: .plain)
//        table.backgroundColor = UIColor.clear
//        table.allowsSelection = false
//        table.separatorStyle = .none
//        table.isUserInteractionEnabled = false
//
//        table.dataSource = table
//        table.delegate = table
//
//        return table
//    }
//}
//
//// data source
//extension MatchedCardRisksTableView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return risks.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let risk = risks[indexPath.item]
//        let cell = MatchedCardRiskCell.cellWithTableView(tableView, imageUrl: risk.imageUrl, riskName: risk.name)
//        return cell
//    }
//}
//
//// delegate
//extension MatchedCardRisksTableView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return bounds.height
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
////        var rotation = CATransform3DRotate( CATransform3DIdentity, CGFloat(Double.pi) / 4, 0, 0.9, 0.4)
////        rotation.m34 = -1 / 1000.0
////        cell.contentView.layer.transform = rotation
////        UIView.animate(withDuration: 0.5) {
////            cell.contentView.layer.transform = CATransform3DIdentity
////        }
//    }
//
//}

