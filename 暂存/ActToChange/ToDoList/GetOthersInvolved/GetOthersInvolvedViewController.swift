//
//  GetOthersInvolvedViewController.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/5/8.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation

class GetOthersInvolvedViewController: UITableViewController {
    var chosenPlans = [PlanModel]()
    var chosenIndex = 0 {
        didSet{
            tableView.reloadData()
        }
    }
    
    fileprivate var chosenPlan: PlanModel! {
        if chosenIndex > 0 && chosenIndex < chosenPlans.count {
            return chosenPlans[chosenIndex]
        }else {
            return nil
        }
    }
    
    fileprivate var involvedExist: Bool {
        if chosenPlan == nil || chosenPlan.involved.count == 0 {
            return false
        }else {
            return true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = ""
        view.backgroundColor = UIColor.white
        
        tableView.separatorStyle = .none
        
        // data of plans
        let plans = NSKeyedUnarchiver.unarchiveObject(withFile: planPath) as? [PlanModel]
        if plans != nil {
            for plan in plans! {
                if plan.chosenWeeks.count != 0 {
                    chosenPlans.append(plan)
                }
            }
        }
        
    }
    
    // view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Get Others Involved"
    }
}

// data source
extension GetOthersInvolvedViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if involvedExist {
            return 3
        }
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = AllPlansMadeCell.cellWith(tableView, plans: chosenPlans)
            cell.tableVCDelegate = self
            
            return cell
        }else {
            
            
            return NoneInvolvedCell.cellWith(tableView)
        }
    }
}

// delegate
extension GetOthersInvolvedViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let topHeight = 170 * height / 667
        
        if indexPath.row == 0 {
            return topHeight
        }else {
            return height - topHeight - 64 - 49
        }
    }
}

