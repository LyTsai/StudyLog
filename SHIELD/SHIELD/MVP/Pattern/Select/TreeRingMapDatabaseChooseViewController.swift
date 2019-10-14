//
//  TreeRingMapDatabaseChooseViewController.swift
//  AnnielyticX
//
//  Created by L on 2019/4/28.
//  Copyright © 2019 AnnielyticX. All rights reserved.
//

import Foundation

class TreeRingMapDatabaseChooseViewController: UIViewController {
 
    @IBOutlet weak var confirmChoose: GradientBackStrokeButton!
    @IBOutlet var selectButtons: [UIButton]!
    @IBOutlet weak var selectTableView: MultipleSelectTableView!
    
    weak var mapViewController: TreeRingMapViewController!
    
    class func createFromNib() -> TreeRingMapDatabaseChooseViewController {
        return Bundle.main.loadNibNamed("TreeRingMapDatabaseChooseViewController", owner: self, options: nil)?.first as! TreeRingMapDatabaseChooseViewController
    }
    
    fileprivate var allMeasurements = [MeasurementObjModel]()
    fileprivate var allPlayers = [String]()
    fileprivate var allRisks = [String]()
    fileprivate var allTimes = [String]()
    
    fileprivate var availablePlayers = [String]()
    fileprivate var availableRisks = [String]()
    fileprivate var availableTimes = [String]()
    
    // selected
    fileprivate var players = [String]()
    fileprivate var risks = [String]()
    fileprivate var times = [String]()
    
    fileprivate var topicArray = [SelectTableType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // basic setup
        for button in selectButtons {
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16 * fontFactor, weight: .medium)
            button.setTitleColor(UIColor.black, for: .selected)
        }
        
        confirmChoose.setupWithTitle("Confirm")
        selectTableView.layer.borderColor = UIColorGray(151).cgColor
        selectTableView.layer.borderWidth = fontFactor
        selectTableView.layer.cornerRadius = 4 * fontFactor
        
        // first time load
        allMeasurements = selectionResults.getAllBaselineMeasuremes()
        allPlayers = selectionResults.getPlayersInMeasurements(allMeasurements)
        allRisks = selectionResults.getRisksInMeasurements(allMeasurements)
        allTimes = selectionResults.getDayTimeStringsInMeasurements(allMeasurements).sorted(by: {$0 > $1})
        
        availablePlayers = allPlayers
        availableRisks = allRisks
        availableTimes = allTimes
        
        players.removeAll()
        risks.removeAll()
        times.removeAll()
    }
    
    fileprivate var type = TreeRingMapType.GamePeopleDates
    func setupWithType(_ type: TreeRingMapType) {
        self.type = type
        //        case PersonGamesDates        // player -> games -> dates
        //        case GamePeopleDates         // game -> players ->  dates
        //        case DatePeopleGames         // date -> players -> games
        //        case DatePeopleCards          // date  ->  game  -> players
        //        case PersonCardsPeriod      // player -> game(show by cards) -> dates
        switch type {
        case .PersonGamesDates: topicArray = [.player, .game, .time]
        case .GamePeopleDates: topicArray = [.game, .player, .time]
        case .DatePeopleGames: topicArray = [.time, .player, .game]
        case .DatePeopleCards: topicArray = [.time, .game, .player]
        case .PersonCardsPeriod: topicArray = [.player, .game, .time]
        }
        
        for (i, button) in selectButtons.enumerated() {
            var topicString = ""
            switch topicArray[i] {
            case .player: topicString = "Individual"
            case .game: topicString = "Game"
            case .time: topicString = "Time"
            }
            
            button.setTitle("Select \(topicString)", for: .normal)
        }
        
        currentSelectType = topicArray.first!
    }
    
    func clearChosenRecord() {
        availablePlayers = allPlayers
        availableRisks = allRisks
        availableTimes = allTimes
        
        players.removeAll()
        risks.removeAll()
        times.removeAll()
        
        // go back to first
        currentSelectType = topicArray.first!
    }
    
    fileprivate func checkMultiple() {
        //        case PersonGamesDates        // player -> games -> dates
        //        case GamePeopleDates         // game -> players ->  dates
        //        case DatePeopleGames         // date -> players -> games
        //        case DatePeopleCards          // date  ->  game  -> players
        //        case PersonCardsPeriod      // player -> game(show by cards) -> dates
        switch currentSelectType {
        case .player:
            // first one
            if type == .PersonGamesDates || type == .PersonCardsPeriod {
                selectTableView.isMultiple = false
            }else {
                selectTableView.isMultiple = true
            }
        case .game:
            if type == .GamePeopleDates || type == .PersonCardsPeriod || type == .DatePeopleCards {
                selectTableView.isMultiple = false
            }else {
                selectTableView.isMultiple = true
            }
        case .time:
            if type == .DatePeopleCards || type == .DatePeopleGames {
                selectTableView.isMultiple = false
            }else {
                selectTableView.isMultiple = true
            }
        }
    }

    // result
    fileprivate var currentSelectType = SelectTableType.player {
        didSet{
            filterData()
            setupButtonBacks()
            checkMultiple()
            loadCurrentTable()
        }
    }
    
    fileprivate func filterData() {
        var availableMeasurements = allMeasurements
        
        switch currentSelectType {
        case .player:
            if risks.count != 0 {
                availableMeasurements = selectionResults.filterWithRisks(risks, inMeasurements: availableMeasurements)
            }
            
            if times.count != 0 {
                availableMeasurements = selectionResults.filterWithDayTimes(times, inMeasurements: availableMeasurements)
            }
        case .game:
            if players.count != 0 {
                availableMeasurements = selectionResults.filterWithPlayers(players, inMeasurements: availableMeasurements)
            }
            
            if times.count != 0 {
                availableMeasurements = selectionResults.filterWithDayTimes(times, inMeasurements: availableMeasurements)
            }
        case .time:
            if players.count != 0 {
                availableMeasurements = selectionResults.filterWithPlayers(players, inMeasurements: availableMeasurements)
            }
            if risks.count != 0 {
                availableMeasurements = selectionResults.filterWithRisks(risks, inMeasurements: availableMeasurements)
            }
        }
        
        availablePlayers = selectionResults.getPlayersInMeasurements(availableMeasurements)
        availableRisks = selectionResults.getRisksInMeasurements(availableMeasurements)
        availableTimes = selectionResults.getDayTimeStringsInMeasurements(availableMeasurements).sorted(by: {$0 > $1})
        
        players = intersectionArrayOf(players, array2: availablePlayers)
        risks = intersectionArrayOf(risks, array2: availableRisks)
        times = intersectionArrayOf(times, array2: availableTimes)
    }
    
    fileprivate func loadCurrentTable() {
        switch currentSelectType {
        case .player:
            selectTableView.loadWithAllKeys(allPlayers, available: availablePlayers, selected: players, selectType: .player)
        case .game:
            selectTableView.loadWithAllKeys(allRisks, available: availableRisks, selected: risks, selectType: .game)
        case .time:
            selectTableView.loadWithAllKeys(allTimes, available: availableTimes, selected: times, selectType: .time)
        }
    }
    
    fileprivate func updateLastData() {
        let chosen = selectTableView.result
        
        switch currentSelectType {
        case .player:
            if compareArrayElements(players, array2: chosen) {
                return
            }
            players = chosen
        case .game:
            if compareArrayElements(risks, array2: chosen) {
                return
            }
            risks = chosen
        case .time:
            if compareArrayElements(times, array2: chosen) {
                return
            }
            times = chosen
        }
    }
    
    fileprivate func compareArrayElements(_ array1: [String], array2: [String]) -> Bool {
        if array1.count != array2.count {
            return false
        }
        for element in array1 {
            if !array2.contains(element) {
                return false
            }
        }
        
        return true
    }
    
    fileprivate func intersectionArrayOf(_ array1: [String], array2: [String]) -> [String] {
        var intersection = [String]()
        
        for element in array1 {
            if array2.contains(element) {
                intersection.append(element)
            }
        }
        
        return intersection
    }
    
    fileprivate var selectType = SelectTableType.player
    @IBAction func selectOtherTable(_ sender: UIButton) {
        let index = sender.tag - 100
        selectType = topicArray[index]
        
        if currentSelectType != selectType {
            if selectTableView.result.count != 0 {
                updateLastData()
            }
            
            currentSelectType = selectType
        }
    }

    
    fileprivate func setupButtonBacks() {
        var focusIndex = 0

        for (i, selectType) in topicArray.enumerated() {
            if selectType == currentSelectType {
                focusIndex = i
                break
            }
        }
        
        for (i, button) in selectButtons.enumerated() {
            button.backgroundColor = (i == focusIndex) ? UIColor.clear : UIColorFromHex(0xECEDEE)
            button.isSelected = (i == focusIndex)
        }
    }
    
    
    @IBAction func confirmCurrenChoose(_ sender: Any) {
        let chosen = selectTableView.result
        switch currentSelectType {
        case .player: players = chosen
        case .game: risks = chosen
        case .time: times = chosen
        }
        
        if players.isEmpty || risks.isEmpty || times.isEmpty {
            let catAlert = CatCardAlertViewController()
            catAlert.addTitle("You should select for all the tables", subTitle: nil, buttonInfo: [("Got It", false, nil)])
            presentOverCurrentViewController(catAlert, completion: nil)
        }else {
            dismiss(animated: true) {
                // update treeRingMap
                self.updateMap()
            }
        }
    }

    fileprivate func updateMap() {
        updateLastData()
        
        if self.mapViewController != nil {
            self.mapViewController.setupWithPlayers(self.players, risks:self.risks, times: self.times)
        }
    }
    
    @IBAction func dismissVC(_ sender: Any) {
        dismiss(animated: true) {
            if self.mapViewController != nil {
                self.mapViewController.resignChange()
            }
        }
    }
}
