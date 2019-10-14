//
//  RiskTypesDisplayView.swift
//  AnnielyticX
//
//  Created by L on 2019/5/15.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

let riskTypeDisplayCellID = "riskType Display Cell Identifier"
class RiskTypeDisplayCell: UITableViewCell {
    fileprivate let typeButton = CustomButton.usedAsRiskTypeButton("")
    class func cellWithTablView(_ table: UITableView, riskTypeKey: String) -> RiskTypeDisplayCell {
        var cell = table.dequeueReusableCell(withIdentifier: riskTypeDisplayCellID) as? RiskTypeDisplayCell
        if cell == nil {
            cell = RiskTypeDisplayCell(style: .default, reuseIdentifier: riskTypeDisplayCellID)
            cell?.addBasic()
        }
        
        cell?.typeButton.setForRiskType(riskTypeKey)
        
        return cell!
    }
    
    fileprivate func addBasic() {
        selectionStyle = .none
        backgroundColor = UIColor.clear
        typeButton.isUserInteractionEnabled = false
        
        addSubview(typeButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let typeFrame = CGRect(center: CGPoint(x: bounds.midX, y: bounds.midY), width: min(bounds.width, bounds.height * 1.2), height: bounds.height * 0.8)
        typeButton.adjustRiskTypeButtonWithFrame(typeFrame)
    }
}


class RiskTypesDisplayView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var cellIsChosen: (()->Void)?
    fileprivate var riskTypes = [String]()
    fileprivate var oneFrame = CGRect.zero
    class func createWithOneFrame(_ frame: CGRect) -> RiskTypesDisplayView {
        let table = RiskTypesDisplayView(frame: frame, style: .plain)
        table.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        table.oneFrame = frame
        table.separatorStyle = .none
        
        table.delegate = table
        table.dataSource = table
        
        return table
    }
    
    func setupOneFrame(_ frame: CGRect) {
        self.oneFrame = frame
        self.frame = CGRect(origin: oneFrame.origin, size: CGSize(width: oneFrame.width, height: oneFrame.height * CGFloat(riskTypes.count)))
    }
    
    func setupWithRiskTypes(_ riskTypes: [String]) {
        self.riskTypes = riskTypes
        self.frame = CGRect(origin: oneFrame.origin, size: CGSize(width: oneFrame.width, height: oneFrame.height * CGFloat(riskTypes.count)))
        
        reloadData()
    }
    
    // datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return riskTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = RiskTypeDisplayCell.cellWithTablView(tableView, riskTypeKey: riskTypes[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return oneFrame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let riskTypeKey = riskTypes[indexPath.row]
        cardsCursor.riskTypeKey = riskTypeKey
        
        cellIsChosen?()
    }
    
}
