//
//  SearchTable.swift
//  Demo_testUI
//
//  Created by iMac on 2018/10/9.
//  Copyright © 2018年 LyTsai. All rights reserved.


import Foundation
class SearchTableView: UITableView, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {

    
    let searchController = UISearchController(searchResultsController: nil)
    
    let searchCellID = "search cell identifier"
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchController.searchResultsUpdater = self
        
        self.dataSource = self
        self.delegate = self
    }
    
    fileprivate var remains = ["ah", "bac", "ccgag", "daghfeidsaf"]
    fileprivate var results = [String]()
    // dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (searchController.isActive ? results.count: remains.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: searchCellID)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: searchCellID)
            cell!.backgroundColor = UIColorFromHex(0xE7F8DA)
        }
        
        if indexPath.section == 0 {
           cell?.textLabel?.text = "searchController.isActive ? results[indexPath.item] : remains[indexPath.item]"
        }else {
           cell?.textLabel?.text = searchController.isActive ? results[indexPath.item] : remains[indexPath.item]
        }
        
        
        return cell!
        
    }
    
    // delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ?  fontFactor * 75 : fontFactor * 65
    }

    // header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = UIView()
            
            return header
        }else {
            let search = searchController.searchBar
            search.placeholder = "Enter the name"
            search.barTintColor = UIColorFromHex(0xC9ECB0)
            return search
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 92 * standWP : 30 * fontFactor
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return section == 1 ? 0.08 * height : 0.01
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        results.removeAll()
        if let inputString = searchController.searchBar.text {
            for data in remains {
                if data.lowercased().contains(inputString.lowercased()) {
                    results.append(data)
                }
            }
        }
//        reloadSections(<#T##sections: IndexSet##IndexSet#>, with: <#T##UITableViewRowAnimation#>)
        
    }
    
    
}


