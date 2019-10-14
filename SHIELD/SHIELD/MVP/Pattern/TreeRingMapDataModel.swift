//
//  TreeRingMapDataModel.swift
//  AnnielyticX
//
//  Created by iMac on 2019/2/18.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

enum TreeRingMapType {
    case PersonGamesDates        // player -> games -> dates
    case GamePeopleDates         // players -> game -> dates
    case DatePeopleGames          // players -> games -> date
    
    // one game, show cards
    case DatePeopleCards        // players -> game(show by cards) -> date
    case PersonCardsPeriod      // player -> game(show by cards) -> dates
    
    // method
    func getNameOfType() -> String {
        switch self {
        case .PersonGamesDates:
        return "Single Person\nMultiple Games\nMultiple Dates"
        
        case .GamePeopleDates:
        return "Single Game\nMultiple People\nMultiple Dates"
        
        case .DatePeopleGames:
        return "Single Date\nMultiple People\nMultiple Games"
        
        case .DatePeopleCards:
        return "Single Date\nMultiple People\nMultiple Game Cards"
        
        case .PersonCardsPeriod:
        return "Single Person\nMultipleGame Cards\nMultiple Dates"
        }
    }
    
    func getOneLineName() -> String {
        let lines = getNameOfType().split(separator: "\n")
        var line = ""
        for one in lines {
            line.append("\(String(one)), ")
        }
        line.removeLast(2)
        
        return line
    }
    
    func getGoalString() -> String {
        switch self {
        case .PersonGamesDates:
            return "Show the patterns of an individual's assessed scores."
            
        case .GamePeopleDates:
            return "To explore multiple individuals’ assessed scores over time for a single game."
            
        case .DatePeopleGames:
            return "To explore multiple individuals’ assessed scores for multiple games on the same time date."
            
        case .DatePeopleCards:
            return "To explore multiple individuals’ assessed scores for multiple cards of a single game for a single time date."
            
        case .PersonCardsPeriod:
            return "To explore a single individual’s assessed scores for multiple cards of one game on multiple time dates."
        }
    }
    
    func getObjectiveString() -> String {
        switch self {
        case .PersonGamesDates:
            return "To explore how a specific individual's assessed scores change over time (multiple dates) for multiple games."
            
        case .GamePeopleDates:
            return "To explore for a specific game, how one or more individual’s assessed scores change over time or how these scores compare, correlate, and vary among the different individuals."
            
        case .DatePeopleGames:
            return "To explore how one or more individual’s assessed scores compare, correlate, and vary over multiple games for a specific date."
            
        case .DatePeopleCards:
            return "To explore how one or more individual’s assessed scores compare, correlate, and vary over multiple cards of a specific game for a single time date."
            
        case .PersonCardsPeriod:
            return "To explore how a specific individual’s assessed scores compare, correlate, and vary over multiple cards of a specific game and over multiple time dates."
        }
    }
    
    func getThumbIcon() -> UIImage?  {
        switch self {
        case .PersonGamesDates: return UIImage(named: "treeRingMap_PersonGamesDates")
        case .GamePeopleDates: return UIImage(named: "treeRingMap_GamePeopleDates")
        case .DatePeopleGames: return UIImage(named: "treeRingMap_DatePeopleGames")
        case .DatePeopleCards: return UIImage(named: "treeRingMap_DatePeopleCards")
        case .PersonCardsPeriod:  return UIImage(named: "treeRingMap_PersonCardsPeriod")
        }
    }
    
}

class TreeRingMapDataModel {
    // currently selected measurements based on riskTypeKey
    var maxNumber: Int = 12
    var type = TreeRingMapType.PersonCardsPeriod
    
    fileprivate var players = [String]()
    fileprivate var risks = [String]()
    fileprivate var times = [String]()
    
    fileprivate var measurements = [MeasurementObjModel]()

    func loadDataWithPlayers(_ players: [String], risks: [String], times: [String]) -> TreeRingMapDataTable {
        self.players = players
        self.risks = risks
        self.times = times.sorted(by: {$0 < $1}) // time ranged for display
        
        // available data
        measurements = selectionResults.filterWithPlayers(players, inMeasurements: selectionResults.getAllBaselineMeasuremes())
        measurements = selectionResults.filterWithRisks(risks, inMeasurements: measurements)
        measurements = selectionResults.filterWithDayTimes(times, inMeasurements: measurements)
        
        // can be nil for some type, used for "One xxx" type
        let riskKey = risks.first!       // focusing risk, the only one
        let dateString = times.first!     // focusing date, the only one
        let userKey = players.first!     // focusing date, the only one
        
        // data
        var columnModels = [TreeRingMapAxisDataModel]()
        var rowModels = [TreeRingMapAxisDataModel]()
        var title = ""
        
        // load data
        switch type {
        case .PersonGamesDates:
            // setup title, column and row display information
            title = userCenter.getDisplayNameOfKey(userKey) ?? "Anonymous"
            columnModels = getRisksAxis()
            rowModels = getDayDateAxis()
        case .GamePeopleDates:
            // one game, all users, multiple dates
            title = collection.getRisk(riskKey).name
            title += " Assessment"
            columnModels = getPlayersAxis()
            rowModels = getDayDateAxis()
        case .DatePeopleGames:
            // one date, all people and multiple games
            title = dateString
            columnModels = getPlayersAxis()
            rowModels = getRisksAxis()
        case .DatePeopleCards:
            // one game, one date and multiple people cards
            title = "\(collection.getRisk(riskKey).name!) Assessment, \(dateString)"
            columnModels = getCardsAxis()
            rowModels = getPlayersAxis()
        case .PersonCardsPeriod:
            // one person, one game card and multiple date
            title = collection.getRisk(riskKey).name
            title += " Assessment"
            columnModels = getCardsAxis()
            rowModels = getDayDateAxis()
        }
        
        // rowModel number
        if rowModels.count > maxNumber {
            rowModels = Array(rowModels[(rowModels.count - maxNumber)..<rowModels.count])
        }
        
        // data fill
        let dataTable = TreeRingMapDataTable()
        dataTable.title = title
        dataTable.createTableColumns(columnModels)
        
        for row in rowModels {
            var oneRow = [String: ANDataTableCell]()
            for column in columnModels {
                if let iden = getResultOfRow(row.key, column: column.key, type: type) {
                    // cell
                    let oneCell = ANDataTableCell()
                    oneCell.color = MatchedCardsDisplayModel.getColorOfIden(iden)
                    oneCell.tip = MatchedCardsDisplayModel.getNameOfIden(iden)
                    
                    // for card
                    oneCell.title = getDetailOfRow(row.key, column: column.key, type: type)
                    oneCell.imageUrl = getImageOfRow(row.key, column: column.key, type: type)
                    
                    oneRow[column.key] = oneCell
                }
            }
            dataTable.addRow(row, cells: oneRow)
        }
        
        return dataTable
    }
    
    // detail display
    fileprivate func getResultOfRow(_ row: String, column: String, type: TreeRingMapType) -> String? {
        switch type {
        case .PersonGamesDates, .GamePeopleDates, .DatePeopleGames:
            if let measurement = getMeasurmentOfRow(row, column: column, type: type) {
                return MatchedCardsDisplayModel.getResultClassificationKeyOfMeasurement(measurement)
            }
        case .DatePeopleCards, .PersonCardsPeriod:
            if let match = getMatchOfRow(row, column: column, type: type) {
                return match.classificationKey ?? UnClassifiedIden
            }
        }
    
        return nil
    }
    
    fileprivate func getMeasurmentOfRow(_ row: String, column: String, type: TreeRingMapType) -> MeasurementObjModel? {
        for measurement in measurements {
            switch type {
            case .PersonGamesDates:
                // row: date, column: riskKey
                if measurement.timeString.contains(row) && measurement.riskKey == column {
                    return measurement
                }
            case .GamePeopleDates:
                if measurement.timeString.contains(row) && measurement.playerKey == column {
                    return measurement
                }
            case .DatePeopleGames:
                if measurement.riskKey == row && measurement.playerKey == column {
                    return measurement
                }
            default: break
            }
        }
        return nil
    }
    
    fileprivate func getMatchOfRow(_ row: String, column: String, type: TreeRingMapType) -> MatchObjModel? {
        for measurement in measurements {
            switch type {
            case .DatePeopleCards:
                if measurement.playerKey == row {
                    for value in measurement.values {
                        if value.metricKey == collection.getCard(column)?.metricKey {
                            if let match = collection.getMatch(value.matchKey) {
                                return match
                            }
                        }
                    }
                }
            case .PersonCardsPeriod:
                if measurement.timeString.contains(row)  {
                    for value in measurement.values {
                        if value.metricKey == collection.getCard(column)?.metricKey {
                            if let match = collection.getMatch(value.matchKey) {
                                return match
                            }
                        }
                    }
                }
                
            default: break
            }
        }
        return nil
    }
    
    fileprivate func getDetailOfRow(_ row: String, column: String, type: TreeRingMapType) -> String! {
        if let match = getMatchOfRow(row, column: column, type: type) {
            return "\(match.name ?? "")\n\(match.statement ?? "")"
        }
        return nil
    }

    fileprivate func getImageOfRow(_ row: String, column: String, type: TreeRingMapType) -> URL? {
        if let match = getMatchOfRow(row, column: column, type: type) {
            return match.imageUrl
        }
        return nil
    }

    fileprivate func getRisksAxis() -> [TreeRingMapAxisDataModel] {
        // arrange
        var axis = [TreeRingMapAxisDataModel]()
        for key in risks {
            let oneAxi = TreeRingMapAxisDataModel()
            oneAxi.key = key
            let risk = collection.getRisk(key)!
            oneAxi.imageUrl = risk.metric?.imageUrl
            oneAxi.displayText = collection.getAbbreviationOfRiskType(risk.riskTypeKey!)
            let typeColor = collection.getRiskTypeByKey(risk.riskTypeKey)?.realColor ?? tabTintGreen
            oneAxi.imageBorderColor = typeColor
            oneAxi.textBackgoundColor = typeColor
            oneAxi.textColor = UIColor.white

            axis.append(oneAxi)
        }

        return axis
    }

    fileprivate func getPlayersAxis() -> [TreeRingMapAxisDataModel] {
        // arrange
        var axis = [TreeRingMapAxisDataModel]()
        for key in players {
            let oneAxi = TreeRingMapAxisDataModel()
            oneAxi.key = key
            oneAxi.showImage = false
            oneAxi.displayText = userCenter.getDisplayNameOfKey(key)
            axis.append(oneAxi)
        }

        return axis
    }

    // till day
    fileprivate func getDayDateAxis() -> [TreeRingMapAxisDataModel] {
        // arrange
        var axis = [TreeRingMapAxisDataModel]()
        for key in times {
            let oneAxi = TreeRingMapAxisDataModel()
            oneAxi.key = key
            oneAxi.showImage = false
            let date = ISO8601DateFormatter().date(from: key.appending("T06:41:26Z")) // fake data string
            let formatter = DateFormatter()
            formatter.dateFormat = "MM/ dd/ yy"
            oneAxi.displayText = formatter.string(from: date!)

            axis.append(oneAxi)
        }

        return axis
    }

    fileprivate func getCardsAxis() -> [TreeRingMapAxisDataModel] {
        var cards = Set<String>()
        for measurement in measurements {
            // e.g. : 2019-02-18T06:41:26Z
            for value in measurement.values {
                if let card = collection.getCardOfMetric(value.metricKey, matchKey: value.matchKey, inRisk: measurement.riskKey!) {
                    cards.insert(card.key)
                }
            }
        }
        
        // arrange
        let array = Array(cards).sorted(by: {collection.getCard($0)?.seqNumber ?? 0 < collection.getCard($1)?.seqNumber ?? 0 })
        var axis = [TreeRingMapAxisDataModel]()
        for key in array {
            let oneAxi = TreeRingMapAxisDataModel()
            oneAxi.key = key
            oneAxi.showText = false
            oneAxi.roundImage = false
            oneAxi.imageUrl = collection.getCard(key)?.getDisplayOptions().first?.match?.imageUrl

            axis.append(oneAxi)
        }
        
        return axis
    }
}

