//
//  SelectionMenu.swift
//  ABook_iPhone_V1
//
//  Created by iMac on 17/2/20.
//  Copyright © 2017年 LyTsai. All rights reserved.
//

import Foundation
let menuCellID = "Menu Cell Identifier"
class MenuTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    var menu = [String]() {
        didSet {
            if menu != oldValue {
                reloadData()
            }
        }
    }
    
    class func createWithFrame(_ frame: CGRect, menu: [String]) -> MenuTableView {
        let table = MenuTableView(frame: frame, style: .plain)
        table.menu = menu
        
        // seperator line
        if table.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            table.separatorInset = UIEdgeInsets.zero
        }
        if table.responds(to: #selector(setter: UIView.layoutMargins)) {
            table.layoutMargins = UIEdgeInsets.zero
        }
        table.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        
        // delegate
        table.delegate = table
        table.dataSource = table
        
        return table
    }
    
    // dataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: menuCellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: menuCellID)
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.textColor = lightGreenColor
            cell?.backgroundColor = UIColor.clear
            cell?.contentView.backgroundColor = UIColor.clear
            cell?.selectionStyle = .none
        }
        
        cell?.textLabel?.text = menu[indexPath.row]
        
        return cell!
    }
    
    // delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.responds(to: #selector(setter: UITableViewCell.separatorInset)) {
            cell.separatorInset = UIEdgeInsets.zero
        }
        if cell.responds(to: #selector(setter: UIView.layoutMargins)) {
            cell.layoutMargins = UIEdgeInsets.zero
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return bounds.height / CGFloat(menu.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
