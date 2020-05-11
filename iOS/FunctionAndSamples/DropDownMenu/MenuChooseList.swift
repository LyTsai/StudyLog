//
//  MenuChooseList.swift
//  BeautiPhi
//
//  Created by L on 2019/11/8.
//  Copyright © 2019 MingHui. All rights reserved.
//

import Foundation
import UIKit

class MenuChooseList: UITableView, UITableViewDataSource, UITableViewDelegate {
    var pulldown = true
    var firstFrame = CGRect.zero
    var maxDisplay: Int = 5
    var selectionIsMade: ((Int)->Void)?
    
    fileprivate var selections = [String]()
    fileprivate var selectedIndex = -1
    func setupWithSelections(_ selections: [String], selectedIndex: Int?) {
        self.selections = selections
        self.selectedIndex = selectedIndex ?? -1
        
        let displayH = CGFloat(min(selections.count, maxDisplay)) * firstFrame.height
        self.frame = CGRect(x: firstFrame.minX, y: pulldown ? firstFrame.minY : firstFrame.minY - displayH + firstFrame.height, width: firstFrame.width, height: displayH)
        
        self.bounces = false
        self.delegate = self
        self.dataSource = self
        
        reloadData()
    }
    
    func setSelectedIndex(_ index: Int?) {
        self.selectedIndex = index ?? -1
        reloadData()
    }
    
    // data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuChooseListCell.cellWithTable(tableView, selectionName: selections[indexPath.row], selected: selectedIndex == indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return firstFrame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != selectedIndex {
            var update = [indexPath]
            if selectedIndex != -1 {
                update.append(IndexPath(row: selectedIndex, section: 0))
            }
            selectedIndex = indexPath.row
            reloadRows(at: update, with: .automatic)
        }
        
        selectionIsMade?(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
}


