//
//  PlayersTableView.swift
//  AnnielyticX
//
//  Created by iMac on 2018/9/6.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation

class PlayersTableView: UITableView, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    let searchController = UISearchController(searchResultsController: nil)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.delegate = self
        
        searchController.dimsBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = true
        
        self.dataSource = self
        self.delegate = self
    }
    
    var players = [String]() {
        didSet{
            getRemains()
        }
    }
    
    fileprivate var remains = [String]()
    fileprivate var results = [String]()
    
    // choose
    fileprivate var targetKey: String!
    func setUserChosen(_ userKey: String) {
        searchController.view.endEditing(true)
        
        if targetKey != userKey {
            let playerVC = self.viewController as! ABookPlayerViewController
            UIView.animate(withDuration: 0.5) {
                playerVC.bottomView.transform = CGAffineTransform.identity
            }
            
            var update = [getIndexOfUserKey(targetKey)]
            targetKey = userKey
            update.append(getIndexOfUserKey(targetKey))
            self.reloadRows(at: update as! [IndexPath], with: .automatic)
        }
    }
    
    fileprivate func getIndexOfUserKey(_ userKey: String) -> IndexPath! {
        if userKey == userCenter.loginKey {
            return IndexPath(row: 0, section: 0)
        }
        
        let data = searchController.isActive ? results : remains
        for (i, key) in data.enumerated() {
            if userKey == key {
                return IndexPath(row: i, section: 1)
            }
        }
        
        return nil
    }
    
    // delete
    fileprivate var pseudoUser2Backend: PseudoUserAccess!
    fileprivate var deletedUserKey: String!
    func deleteUser(_ userKey: String) {
        deletedUserKey = userKey
        if pseudoUser2Backend == nil {
            pseudoUser2Backend = PseudoUserAccess(callback: self)
        }
        
        pseudoUser2Backend.beginApi(self)
        pseudoUser2Backend.deleteOneByKey(key: userKey)
    }
    
    fileprivate func deleteFinished() {
        userCenter.deletePseudoUser(deletedUserKey)
        if deletedUserKey == userCenter.currentGameTargetUser.Key() {
            userCenter.setLoginUserAsTarget()
        }
        // reload
        let playerVC = self.viewController as! ABookPlayerViewController
        playerVC.reloadPlayerView()
    }
    
    fileprivate func getRemains() {
        remains.removeAll()
        
        targetKey = userCenter.currentGameTargetUser.Key()
        if players.contains(targetKey) {
            remains = [targetKey]
  
            for key in players {
                if key != targetKey  {
                    remains.append(key)
                }
            }
        }else {
            // user is chosen
            remains = players
        }
    }
    
    // dataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return (userCenter.userState == .login ? 2 : 0)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : (searchController.isActive ? results.count: remains.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = PlayerDisplayCell.cellWithTableView(self, userKey: userCenter.loginKey, isChosen: (userCenter.loginKey == targetKey))
            cell.backgroundColor = UIColorFromHex(0xF7FFF1)
            return cell
        }else {
            let userKey = searchController.isActive ? results[indexPath.row] : remains[indexPath.row]
            let cell = PlayerDisplayCell.cellWithTableView(self, userKey: userKey, isChosen: (userKey == targetKey))
            cell.backgroundColor = UIColorFromHex(0xE7F8DA)
            return cell
        }
    }
    
    // delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ?  fontFactor * 75 : fontFactor * 65
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            setUserChosen(userCenter.loginKey)
        }else {
            let userKey = searchController.isActive ? results[indexPath.row] : remains[indexPath.row]
            setUserChosen(userKey)
        }
    }
    
    // header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 1 {
            let header = AddPeopleOrGroupView.createFromNib()
            header.usedToAdd(.addPeople)
            
            return header
        }else {
            let header = UIView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: max(30 * fontFactor, 57)))
            let search = searchController.searchBar
            search.placeholder = "Enter the name"
            search.frame = header.bounds
            search.barTintColor = UIColorFromHex(0xC9ECB0)
            header.addSubview(search)
//            for sub in search.subviews {
//                if sub.isKind(of: UITextField.classForCoder()) {
//                    sub.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 30 * fontFactor)
//                    s
//                }
//            }
            return header
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 92 * standWP : max(30 * fontFactor, 57)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
       return section == 1 ? 0.08 * height : 0.01
    }
    
    // search
    func updateSearchResults(for searchController: UISearchController) {
        results.removeAll()
        if let inputString = searchController.searchBar.text {
            for data in remains {
                let name = userCenter.getPseudoUser(data)!.displayName ?? ""
                if name.lowercased().contains(inputString.lowercased()) {
                    results.append(data)
                }
            }
        }
        reloadSections(IndexSet(integer: 1), with: .automatic)
        
    }
    
//    func willPresentSearchController(_ searchController: UISearchController) {
//
//        self.frame.origin = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y - UIApplication.shared.statusBarFrame.size.height)
//    }
//    func willDismissSearchController(_ searchController: UISearchController) {
//        self.frame.origin = CGPoint(x: self.frame.origin.x, y: self.frame.origin.y + UIApplication.shared.statusBarFrame.size.height)
//    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
    }
    
    
    // methods
    func chooseAsTarget() {
        userCenter.setUserAsTarget(targetKey)
        let userKey = userCenter.currentGameTargetUser.Key()
        // loadRecord
        for riskKey in collection.getAllRisks() {
            selectionResults.getAllLocalMeasurementsForUser(userKey, riskKey: riskKey)
            selectionResults.useLastMeasurementForUser(userKey, riskKey: riskKey, whatIf: false)
        }
        
        getRemains()
        reloadData()
    }
}

extension PlayersTableView: DataAccessProtocal {
    func didFinishDeleteDataByKey(_ obj: AnyObject) {
        pseudoUser2Backend.endApi()
        print("delete pseudoUser success")
        deleteFinished()

    }
    
    func failedDeleteDataByKey(_ error: String) {
        print(error)
        deleteFinished()
    }
}


