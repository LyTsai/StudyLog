//
//  GetOthersInvolvedCells.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/12.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

let involvedXIBName = "GetOthersInvolvedCells"
let involvedCellIDs = ["all Plans Made Cell ID", "empty Number of Involved ID", "chose involved people ID", "mission group ID"]

class AllPlansMadeCell: UITableViewCell {
    weak var tableVCDelegate: GetOthersInvolvedViewController!
    
    @IBOutlet weak var notificatiionLabel: UILabel!
    @IBOutlet weak var messageNumberLabel: UILabel!
    @IBOutlet weak var plansMadeCollectionView: PlansMadeCollectionView!

    class func cellWith(_ tableView: UITableView, plans: [PlanModel]) -> AllPlansMadeCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: involvedCellIDs[0]) as? AllPlansMadeCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed(involvedXIBName, owner: self, options: nil)?.first as? AllPlansMadeCell
            cell?.plansMadeCollectionView.hostDelegate = cell!
        }
        
        // for no news now
        cell?.messageNumberLabel.isHidden = true
        cell?.notificatiionLabel.isHidden = true
        
        cell?.plansMadeCollectionView.plans = plans
        
        return cell!
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        notificatiionLabel.layer.cornerRadius = notificatiionLabel.bounds.width * 0.5
    }
}

class NoneInvolvedCell: UITableViewCell {
    class func cellWith(_ tableView: UITableView) -> NoneInvolvedCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: involvedCellIDs[1]) as? NoneInvolvedCell
        if cell == nil {
            cell =  Bundle.main.loadNibNamed(involvedXIBName, owner: self, options: nil)?[1] as? NoneInvolvedCell
            
        }
        return cell!
    }
    
    @IBAction func goToAdd(_ sender: Any) {
    }
}
