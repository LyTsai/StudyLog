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
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.delegate = self
        self.dataSource = self
        
    }
    
    // result
    func getFilteredMeasurements() -> [MeasurementObjModel] {
        switch selectType {
        case .player:
            return selectionResults.getFilteredMeasurements
        default:
            <#code#>
        }
    }
    
    
    // setup
    fileprivate var selectType = SelectTableType.player
    fileprivate var measurements = [MeasurementObjModel]()
    
    
    // detail
    fileprivate var players = [String]()
    fileprivate var risks = [String]()
    fileprivate var times = [String]()
    
    fileprivate var selectedKeys = Set<String>()
    
    func loadWithMeasurements(_ measurements: [MeasurementObjModel], selectType: SelectTableType) {
        self.measurements = measurements
        self.selectType = selectType
    
        switch selectType {
        case .player: players = selectionResults.getPlayersInMeasurements(measurements)
        case .game: risks = selectionResults.getRisksInMeasurements(measurements)
        case .time: times = selectionResults.getDayTimeStringsInMeasurements(measurements)
        }
        selectedKeys.removeAll()
        
        // refresh
        reloadData()
    }
    
    
    
    
//
//    func setupWithPlayers(_ players: [String]) {
//        tableType = .player
//    }
//
//
//    func setupWithRisks(_ risks: [String]) {
//        tableType = .game
//    }
//
//    func setupWithTimes(_ players: [String]) {
//        tableType = .time
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectType {
        case .player: return players.count
        case .game: return risks.count
        case .time: return times.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let key = getKeyAtIndexPath(indexPath)
        var text = ""
        switch selectType {
        case .player:
            if key == userCenter.loginKey {
                // user
                let user = userCenter.loginUserObj
                text = user.displayName
            }else {
                let pseudo = userCenter.getPseudoUser(key)
                text = pseudo.displayName
            }
        case .game:
            let risk = collection.getRisk(key)!
            text = risk.name
        case .time:
            let time = times[indexPath.item]
            text = time
        }
        
        return SelectTableViewCell.cellWithTable(tableView, text: text, selected: selectedKeys.contains(key))
    }
    
    fileprivate func getKeyAtIndexPath(_ indexPath: IndexPath) -> String {
        switch selectType {
        case .player: return players[indexPath.item]
        case .game: return risks[indexPath.item]
        case .time: return times[indexPath.item]
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let key = getKeyAtIndexPath(indexPath)
        if selectedKeys.contains(key) {
            selectedKeys.remove(key)
        }else {
            selectedKeys.insert(key)
        }
        
        reloadRows(at: [indexPath], with: .automatic)
    }
}
