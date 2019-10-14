//
//  MultipleSelectTableView.swift
//  AnnielyticX
//
//  Created by L on 2019/4/28.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation
enum SelectTableType {
    case player, game, time
}

class MultipleSelectTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var isMultiple = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource = self
        
        self.tableFooterView = UIView()
    }
    
    // setup
    fileprivate var selectType = SelectTableType.player
    fileprivate var keys = [String]()
    
    // result
    fileprivate var availableNumber = 0
    fileprivate var selectedKeys = Set<String>()
    var result: [String] {
        return Array(selectedKeys)
    }
    
    func loadWithAllKeys(_ allKeys: [String], available: [String], selected: [String], selectType: SelectTableType) {
        self.selectType = selectType
        
        // prepare
        selectedKeys.removeAll()
        for key in selected {
            selectedKeys.insert(key)
        }
        
        // data source
        keys.removeAll()
        var unable = [String]()
        // sort
        for key in allKeys {
            if available.contains(key) {
                keys.append(key)
            }else {
                unable.append(key)
            }
        }
        availableNumber = keys.count
        keys.append(contentsOf: unable)
       
        // refresh
        reloadData()
        self.contentOffset = CGPoint.zero
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return keys.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = keys[indexPath.item]
        var text: String?
        switch selectType {
        case .player:
            text = userCenter.getDisplayNameOfKey(key)
        case .game:
            let risk = collection.getRisk(key)!
            text = risk.name
        case .time:
            let time = keys[indexPath.item]
            let date = ISO8601DateFormatter().date(from: time.appending("T06:41:26Z")) // fake data string
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM, yyyy"
            text = formatter.string(from: date!)
        }
        
        return SelectTableViewCell.cellWithTableView(tableView, text: text, available: indexPath.item < availableNumber, selected: selectedKeys.contains(key))
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.item >= availableNumber {
            let catAlert = CatCardAlertViewController()
            catAlert.addTitle("Can not select the data due to your selection in other tables", subTitle: nil, buttonInfo: [("Got It", false, nil), ("Clear Other", false, clearOtherData)])
            viewController.presentOverCurrentViewController(catAlert, completion: nil)
        }else {
            let key = keys[indexPath.item]
            if isMultiple {
                if selectedKeys.contains(key) {
                    selectedKeys.remove(key)
                }else {
                    selectedKeys.insert(key)
                }
                
                reloadRows(at: [indexPath], with: .automatic)
            }else {
                if selectedKeys.contains(key) {
                    selectedKeys.remove(key)
                    reloadRows(at: [indexPath], with: .automatic)
                }else {
                    selectedKeys = [key]
                    reloadData()
                }
            }
        }
    }
    
    fileprivate func clearOtherData() {
        let chooseVC = viewController as! TreeRingMapDatabaseChooseViewController
        chooseVC.clearChosenRecord()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55 * fontFactor
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
