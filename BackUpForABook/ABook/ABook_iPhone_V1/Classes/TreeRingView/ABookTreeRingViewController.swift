//
//  ABookTreeRingViewController.swift
//  ABook_iPhone_V1
//
//  Created by hui wang on 3/3/17.
//  Copyright © 2017 LyTsai. All rights reserved.
//

import Foundation
import ABookData
import CoreData

enum ShowTRMapMode {
    case mode_1 //Time - Riskfactor
    case mode_2 //one person - one risk - multiple assessments
    case mode_3
    case mode_4
    case mode_5
    case mode_6
    case mode_7
    case mode_default
}

// MARK: --------
class ABookTreeRingViewController: UIViewController {
    
    var treeRingMapView: TreeRingMapView!
    // top and bottom margin of trmap
    var gap: CGFloat = 20
    
    // inverse because of landscape
    fileprivate var viewWidth: CGFloat{
        return UIScreen.main.bounds.size.height
    }
    fileprivate var viewHeight: CGFloat{
        return UIScreen.main.bounds.size.width
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 151.0/255.0, green: 190/255.0, blue: 76/255.0, alpha: 1.0)
        //navigationItem.title = "View of Games"
    }
    
    /**
     (1) Time - Riskfactor .based on given user or given pseudouser 
         Notice: given user and given pesudoUser fill only one
     */
    func showTRMapOfMode_1(_ measurements: [MeasurementObjModel]) {
        // add trmap
        let rc = CGRect(x: 0, y:0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap)
        treeRingMapView = TreeRingMapView.init(frame: rc)
        treeRingMapView.center.x = viewWidth / 2.0
        
        // read game data results
        let gameResultTable = loadDataTableForMode_1(measurements)
        
        // prepared data for tree ring map
        let dataTableForTreeRingMap = TRMetricDataTable.init("All measurements of risk at different time")
        
        // load gameResultTable into dataTableForTreeRingMap
        loadGameResultIntoTRMapTable(gameResultTable, treeRingMapTable: dataTableForTreeRingMap, mode: ShowTRMapMode.mode_1)
        
        // load dataTableForTreeRingMap into treeRingMapView
        treeRingMapView.loadOneTableOnly(dataTableForTreeRingMap)
        
        treeRingMapView.setSize(CGRect(x: 0, y: 0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap))
        view.addSubview(treeRingMapView)
        addBackButtonForTRMapView()
    }
    
    fileprivate func loadDataTableForMode_1(_ measurements: [MeasurementObjModel]) -> GameResultDataTable{
        let gameResultTable = GameResultDataTable()
        if measurements.count == 0 {
            return gameResultTable
        }
        
        // parse measurments into gameResultTable
        for measurement in measurements {
            
            // x axis parameter
            let date = measurement.time
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yy-MM-dd"
            let dateString = dateFormat.string(from: date!)

            for value in measurement.values {
                let metric = value.metric
                let classification = value.match?.classification
                
                let oneCell = ANDataTableCell()
                oneCell.unit_name = metric?.unit.name
                oneCell.unit_symbol = metric?.unit.symbol
                oneCell.value = Double(value.value)
                oneCell.viewSize = 16
                oneCell.image = classification == nil ? UIImage.init(named: "face1") : classification!.image?.imageObj
                oneCell.tip = classification == nil ? "" : classification?.info
                
                // set columns of resultTable
                if gameResultTable.metricColumns[metric!.key!] == nil {
                    gameResultTable.metricColumns[metric!.key!] = metric?.name
                }
                
                if gameResultTable.gameResultForMode_1[dateString] == nil {
                    gameResultTable.gameResultForMode_1[dateString] = UserGameResults()
                }
                
                if gameResultTable.gameResultForMode_1[dateString]?.metricDataSet[(metric?.name)!] == nil {
                    gameResultTable.gameResultForMode_1[dateString]?.metricDataSet[(metric?.name)!] = [ANDataTableCell]()
                }
                // [userName : [metricName : [ANDataTableCell]]]
                gameResultTable.gameResultForMode_1[dateString]?.metricDataSet[(metric?.name)!]?.append(oneCell)
            }
        }
        return gameResultTable
    }
    
    /**
     (2) one person - one risk - multiple assessments (here default assessment is created by the author of risk)
     */
    func showTRMapOfMode_2(_ assessments: [AssessmentObjModel]) {

        // add trmap
        let rc = CGRect(x: 0, y:0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap)
        treeRingMapView = TreeRingMapView.init(frame: rc)
        treeRingMapView.center.x = viewWidth / 2.0
        
        // read game data results
        let gameResultTable = loadDataTableForMode_2(assessments)
        
        // prepared data for tree ring map
        let dataTableForTreeRingMap = TRMetricDataTable.init("All measurements of one risk with different assessment")
        
        // load gameResultTable into dataTableForTreeRingMap
        loadGameResultIntoTRMapTable(gameResultTable, treeRingMapTable: dataTableForTreeRingMap, mode: ShowTRMapMode.mode_2)
        
        // load dataTableForTreeRingMap into treeRingMapView
        treeRingMapView.loadOneTableOnly(dataTableForTreeRingMap)
        
        treeRingMapView.setSize(CGRect(x: 0, y: 0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap))
        view.addSubview(treeRingMapView)
        addBackButtonForTRMapView()
    }
    
    fileprivate func loadDataTableForMode_2(_ assessments: [AssessmentObjModel]) -> GameResultDataTable{
        let gameResultTable = GameResultDataTable()

        if assessments.count == 0 {
            return gameResultTable
        }
        
        // parse measurments into gameResultTable
        for assessment in assessments {
            // ring default assessment's author == risk's author
            let assessmentName = assessment.classification.name!
            let measurement = assessment.measurement
         
            for value in measurement!.values {
                let metric = value.metric
                let classification = value.match?.classification
                
                let oneCell = ANDataTableCell()
                oneCell.unit_name = metric?.unit.name
                oneCell.unit_symbol = metric?.unit.symbol
                oneCell.value = Double(value.value)
                oneCell.viewSize = 16
                oneCell.image = classification == nil ? UIImage.init(named: "face1") : classification!.image?.imageObj
                oneCell.tip = classification == nil ? "" : classification?.info
                
                // set columns of resultTable
                if gameResultTable.metricColumns[metric!.key!] == nil {
                    gameResultTable.metricColumns[metric!.key!] = metric?.name
                }
                
                
                if gameResultTable.gameResultForMode_2[assessmentName] == nil {
                    gameResultTable.gameResultForMode_2[assessmentName] = UserGameResults()
                }
                
                if gameResultTable.gameResultForMode_2[assessmentName]?.metricDataSet[(metric?.name)!] == nil {
                    gameResultTable.gameResultForMode_2[assessmentName]?.metricDataSet[(metric?.name)!] = [ANDataTableCell]()
                }
                // [userName : [metricName : [ANDataTableCell]]]
                gameResultTable.gameResultForMode_1[assessmentName]?.metricDataSet[(metric?.name)!]?.append(oneCell)
            }
        }
        return gameResultTable
    }
    
    /**
     (3) One game class - Multiple algorithms
     */
    func showTRMapOfMode_3(_ measurements: [MeasurementObjModel]){

        // add trmap
        let rc = CGRect(x: 0, y:0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap)
        treeRingMapView = TreeRingMapView.init(frame: rc)
        treeRingMapView.center.x = viewWidth / 2.0
        
        // read game data results
        let gameResultTable = loadDataTableForMode_3(measurements)
        
        // prepared data subject for tree ring map
        let dataTableForTreeRingMap = TRMetricDataTable.init("All measurements of different algorithms with one class")
        
        // load gameResultTable into dataTableForTreeRingMap
        loadGameResultIntoTRMapTable(gameResultTable, treeRingMapTable: dataTableForTreeRingMap, mode: ShowTRMapMode.mode_3)
        
        // load dataTableForTreeRingMap into treeRingMapView
        treeRingMapView.loadOneTableOnly(dataTableForTreeRingMap)
        
        treeRingMapView.setSize(CGRect(x: 0, y: 0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap))
        view.addSubview(treeRingMapView)
        addBackButtonForTRMapView()
    }
    
    fileprivate func loadDataTableForMode_3(_ measurements: [MeasurementObjModel]) -> GameResultDataTable{
        let gameResultTable = GameResultDataTable()
        
        if measurements.count == 0 {
            return gameResultTable
        }
        
        // parse measurments into gameResultTable
        for measurement in measurements {
            let riskName = measurement.risk!.name!
            
            for value in measurement.values {
                let metric = value.metric
                let classification = value.match?.classification
                let oneCell = ANDataTableCell()
                oneCell.unit_name = metric?.unit.name
                oneCell.unit_symbol = metric?.unit.symbol
                oneCell.value = Double(value.value)
                oneCell.viewSize = 16
                // if with classifier == nil
                oneCell.image = classification == nil ? UIImage.init(named: "face1") : classification!.image?.imageObj
                oneCell.tip = classification == nil ? "" : classification?.info
                
                // set columns of resultTable
                if gameResultTable.metricColumns[metric!.key!] == nil {
                    gameResultTable.metricColumns[metric!.key!] = metric?.name
                }
                
                if gameResultTable.gameResultForMode_3[riskName] == nil {
                    gameResultTable.gameResultForMode_3[riskName] = UserGameResults()
                }
                
                if gameResultTable.gameResultForMode_3[riskName]?.metricDataSet[(metric?.name)!] == nil {
                    gameResultTable.gameResultForMode_3[riskName]?.metricDataSet[(metric?.name)!] = [ANDataTableCell]()
                }
                
                gameResultTable.gameResultForMode_3[riskName]?.metricDataSet[(metric?.name)!]?.append(oneCell)
            }
        }
        return gameResultTable
    }
    
    /**
     (4) One author - Multiple algorithms
     */
    func showTRMapOfMode_4(_ measurements: [MeasurementObjModel]) {
        
        // add trmap
        let rc = CGRect(x: 0, y:0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap)
        treeRingMapView = TreeRingMapView.init(frame: rc)
        treeRingMapView.center.x = viewWidth / 2.0
        
        // read game data results
        let gameResultTable = loadDataTableForMode_4(measurements)
        
        // prepared data subject for tree ring map
        let dataTableForTreeRingMap = TRMetricDataTable.init("All measurements of one person with same risk author")
        
        // load gameResultTable into dataTableForTreeRingMap
        loadGameResultIntoTRMapTable(gameResultTable, treeRingMapTable: dataTableForTreeRingMap, mode: ShowTRMapMode.mode_4 )
        
        // load dataTableForTreeRingMap into treeRingMapView
        treeRingMapView.loadOneTableOnly(dataTableForTreeRingMap)
        
        treeRingMapView.setSize(CGRect(x: 0, y: 0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap))
        view.addSubview(treeRingMapView)
        addBackButtonForTRMapView()
        
    }
    
    fileprivate func loadDataTableForMode_4(_ measurements: [MeasurementObjModel]) -> GameResultDataTable{
        
        let gameResultTable = GameResultDataTable()
        if measurements.count == 0 {
            return gameResultTable
        }
        
        // parse measurments into gameResultTable
        for measurement in measurements {
            let risk = measurement.risk
            
            for value in measurement.values {
                let metric = value.metric
                let classification = value.match?.classification
                let oneCell = ANDataTableCell()
                oneCell.unit_name = metric?.unit.name
                oneCell.unit_symbol = metric?.unit.symbol
                oneCell.value = Double(value.value)
                oneCell.viewSize = 16
                // if with classifier == nil
                oneCell.image = classification == nil ? UIImage.init(named: "face1") : classification!.image?.imageObj
                oneCell.tip = classification == nil ? "" : classification?.info
                
                // set all columns 
                if gameResultTable.metricColumns[metric!.key] == nil {
                    gameResultTable.metricColumns[metric!.key] = metric!.name
                }
                
                if gameResultTable.gameResultForMode_4[risk!.name!] == nil {
                    gameResultTable.gameResultForMode_4[risk!.name!] = UserGameResults()
                }
                
                if gameResultTable.gameResultForMode_4[risk!.name!]?.metricDataSet[(metric?.name)!] == nil {
                    gameResultTable.gameResultForMode_4[risk!.name!]?.metricDataSet[(metric?.name)!] = [ANDataTableCell]()
                }
                
                gameResultTable.gameResultForMode_4[risk!.name!]?.metricDataSet[(metric?.name)!]?.append(oneCell)
                
            }
        }
        return gameResultTable
    }
    
    /**
      (5) all users - riskfactors (one risk)
          given: one risk,one collectingUser, defalut is the latest date
      */
    func showTRMapOfMode_5(_ measurements: [MeasurementObjModel]) {
        // add back button for test
        addBackButtonForTRMapView()
        
        // add trmap
        let rc = CGRect(x: 0, y:0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap)
        treeRingMapView = TreeRingMapView.init(frame: rc)
        treeRingMapView.center.x = viewWidth / 2.0
        
        // read game data results
        let gameResultTable = loadGameResultTableForMode_5(measurements)
        
        // prepared data sobject for tree ring map
        let dataTableForTreeRingMap = TRMetricDataTable.init("-- Game of Low Vitmin D -- ")
        
        // load gameResultTable into dataTableForTreeRingMap
        loadGameResultIntoTRMapTable(gameResultTable, treeRingMapTable: dataTableForTreeRingMap, mode: ShowTRMapMode.mode_5)
        
        // load dataTableForTreeRingMap into treeRingMapView
        treeRingMapView.loadOneTableOnly(dataTableForTreeRingMap)
        
        treeRingMapView.setSize(CGRect(x: 0, y: 0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap))
        view.addSubview(treeRingMapView)
    }
    
    fileprivate func loadGameResultTableForMode_5(_ measurements: [MeasurementObjModel]) -> GameResultDataTable {
        
        let gameResultTable = GameResultDataTable()
        
        // parse measurments into gameResultTable
        for measurement in measurements {
            
            // read user target
            let ofPerson = measurement.user
            let ofPseuDoUser = measurement.pseudoUser
            
            // one measurement must have ofPerson and it can not have ofPseudoUser, if both this measurement is related to ofPseudoUser.
            if ofPerson == nil && ofPseuDoUser == nil {
                // not valid
                continue
            }
            
            // user name
            let userName = ofPerson == nil ? ofPseuDoUser!.name : ofPerson!.displayName
            
            for measurementValue in measurement.values {
                // read metric
                let metric = measurementValue.metric
                
                if metric == nil {
                    // not valid
                    continue
                }
                
                // set columns of resultTable
                if gameResultTable.metricColumns[metric!.key!] == nil {
                    gameResultTable.metricColumns[metric!.key!] = metric?.name
                }
                
                let classification = measurementValue.match?.classification
                
                let oneCell = ANDataTableCell()
                oneCell.unit_name = metric?.unit!.name
                oneCell.unit_symbol = metric?.unit!.symbol
                oneCell.value = Double(measurementValue.value)
                oneCell.viewSize = 16
                
                // if with classifier == nil
                oneCell.image = classification == nil ? UIImage.init(named: "face1") : classification!.image?.imageObj
                oneCell.tip = classification == nil ? "" : classification?.info
                
                
                if gameResultTable.gameResultForMode_5[userName!] == nil {
                    gameResultTable.gameResultForMode_5[userName!] = UserGameResults()
                }
                
                if gameResultTable.gameResultForMode_5[userName!]?.metricDataSet[(metric?.name)!] == nil {
                    gameResultTable.gameResultForMode_5[userName!]?.metricDataSet[(metric?.name)!] = [ANDataTableCell]()
                }
                // [userName : [metricName : [ANDataTableCell]]]
                gameResultTable.gameResultForMode_5[userName!]?.metricDataSet[(metric?.name)!]?.append(oneCell)
            }
        }
        
        return gameResultTable
    }

    
    /**
     (6) all users - all measurement
     given: one collectingUser, time range (defalut is the latest date)
     */
    func showTRMapOfMode_6(_ measurements: [MeasurementObjModel]){
        // add back button for test
        addBackButtonForTRMapView()
        
        // add trmap
        let rc = CGRect(x: 0, y:0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap)
        treeRingMapView = TreeRingMapView.init(frame: rc)
        treeRingMapView.center.x = viewWidth / 2.0
        
        // read game data results
        let gameResultTable = loadGameResultTableForMode_6(measurements)
        
        // prepared data sobject for tree ring map
        let dataTableForTreeRingMap = TRMetricDataTable.init("-- Game of Low Vitmin D -- ")
        
        // load gameResultTable into dataTableForTreeRingMap
        loadGameResultIntoTRMapTable(gameResultTable, treeRingMapTable: dataTableForTreeRingMap, mode: ShowTRMapMode.mode_6)
        
        // load dataTableForTreeRingMap into treeRingMapView
        treeRingMapView.loadOneTableOnly(dataTableForTreeRingMap)
        
        treeRingMapView.setSize(CGRect(x: 0, y: 0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap))
        view.addSubview(treeRingMapView)
    }
    
    fileprivate func loadGameResultTableForMode_6(_ measurements: [MeasurementObjModel]) -> GameResultDataTable {
        let gameResultTable = GameResultDataTable()
        if measurements.count == 0 {
            return gameResultTable
        }
        
        for measurement in measurements {
            // read user target
            let ofPerson = measurement.user
            let ofPseuDoUser = measurement.pseudoUser
            
            // one measurement must have ofPerson and it can not have ofPseudoUser, if both this measurement is related to ofPseudoUser.
            if ofPerson == nil && ofPseuDoUser == nil {
                // not valid
                continue
            }
            
            // user name
            let userName = ofPerson == nil ? ofPseuDoUser!.name : ofPerson!.displayName
            
            for measurementValue in measurement.values {
                // read metric
                let metric = measurementValue.metric
                
                if metric == nil {
                    // not valid
                    continue
                }
                
                // set columns of resultTable
                if gameResultTable.metricColumns[metric!.key!] == nil {
                    gameResultTable.metricColumns[metric!.key!] = metric?.name
                }
                
                let classification = measurementValue.match?.classification
                
                let oneCell = ANDataTableCell()
                oneCell.unit_name = metric?.unit!.name
                oneCell.unit_symbol = metric?.unit!.symbol
                oneCell.value = Double(measurementValue.value)
                oneCell.viewSize = 16
                
                // if with classifier == nil
                oneCell.image = classification == nil ? UIImage.init(named: "face1") : classification!.image?.imageObj
                oneCell.tip = classification == nil ? "" : classification?.info
                
                if gameResultTable.gameResultForMode_6[userName!] == nil {
                    gameResultTable.gameResultForMode_6[userName!] = UserGameResults()
                }
                
                if gameResultTable.gameResultForMode_6[userName!]?.metricDataSet[(metric?.name)!] == nil {
                    gameResultTable.gameResultForMode_6[userName!]?.metricDataSet[(metric?.name)!] = [ANDataTableCell]()
                }
                // [userName : [metricName : [ANDataTableCell]]]
                gameResultTable.gameResultForMode_6[userName!]?.metricDataSet[(metric?.name)!]?.append(oneCell)
            }
        }
        return gameResultTable
    }
    
    /**
     (7) Multiple people – One Risk algorithm
     */
    func showTRMapOfMode_7(_ measurements: [MeasurementObjModel]){
        // add back button for test
        addBackButtonForTRMapView()
        
        // add trmap
        let rc = CGRect(x: 0, y:0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap)
        treeRingMapView = TreeRingMapView.init(frame: rc)
        treeRingMapView.center.x = viewWidth / 2.0
        
        // read game data results
        let gameResultTable = loadGameResultTableForMode_7(measurements)
        
        // prepared data sobject for tree ring map
        let dataTableForTreeRingMap = TRMetricDataTable.init("-- Game of Low Vitmin D -- ")
        
        // load gameResultTable into dataTableForTreeRingMap
        loadGameResultIntoTRMapTable(gameResultTable, treeRingMapTable: dataTableForTreeRingMap, mode: ShowTRMapMode.mode_7)
        
        // load dataTableForTreeRingMap into treeRingMapView
        treeRingMapView.loadOneTableOnly(dataTableForTreeRingMap)
        
        treeRingMapView.setSize(CGRect(x: 0, y: 0, width: 1.5 * (viewHeight - gap), height: viewHeight - gap))
        view.addSubview(treeRingMapView)
    }
    
    fileprivate func loadGameResultTableForMode_7(_ measurements: [MeasurementObjModel]) -> GameResultDataTable {
        let gameResultTable = GameResultDataTable()
        if measurements.count == 0 {
            return gameResultTable
        }
        
        for measurement in measurements {
            // read user target
            let ofPerson = measurement.user
            let ofPseuDoUser = measurement.pseudoUser
            
            // one measurement must have ofPerson and it can not have ofPseudoUser, if both this measurement is related to ofPseudoUser.
            if ofPerson == nil && ofPseuDoUser == nil {
                // not valid
                continue
            }
            
            // user name
            let userName = ofPerson == nil ? ofPseuDoUser!.name : ofPerson!.displayName
            
            for measurementValue in measurement.values {
                // read metric
                let metric = measurementValue.metric
                
                if metric == nil {
                    // not valid
                    continue
                }
                
                // set columns of resultTable
                if gameResultTable.metricColumns[metric!.key!] == nil {
                    gameResultTable.metricColumns[metric!.key!] = metric?.name
                }
                
                let classification = measurementValue.match?.classification
                
                let oneCell = ANDataTableCell()
                oneCell.unit_name = metric?.unit!.name
                oneCell.unit_symbol = metric?.unit!.symbol
                oneCell.value = Double(measurementValue.value)
                oneCell.viewSize = 16
                
                // if with classifier == nil
                oneCell.image = classification == nil ? UIImage.init(named: "face1") : classification!.image?.imageObj
                oneCell.tip = classification == nil ? "" : classification?.info
                
                if gameResultTable.gameResultForMode_7[userName!] == nil {
                    gameResultTable.gameResultForMode_7[userName!] = UserGameResults()
                }
                
                if gameResultTable.gameResultForMode_7[userName!]?.metricDataSet[(metric?.name)!] == nil {
                    gameResultTable.gameResultForMode_7[userName!]?.metricDataSet[(metric?.name)!] = [ANDataTableCell]()
                }
                // [userName : [metricName : [ANDataTableCell]]]
                gameResultTable.gameResultForMode_7[userName!]?.metricDataSet[(metric?.name)!]?.append(oneCell)
            }
        }
        return gameResultTable
    }

    
    
    //MARK: load feteched data into tree ring map with metric as column and user as row
    // convert gameResultTable to treeRingMapTable for showing trmap
    func loadGameResultIntoTRMapTable(_ gameResultTable: GameResultDataTable, treeRingMapTable: TRMetricDataTable, mode: ShowTRMapMode) {
        // create metric column first
        var columnKeys = [String]()
        for (_, metricName) in gameResultTable.metricColumns{
            columnKeys.append(metricName)
        }
        treeRingMapTable.createTableColumnKeys(columnKeys)
        
        switch mode {
        // mode_1
        case ShowTRMapMode.mode_1:
            // all ring
            for (time, results) in gameResultTable.gameResultForMode_1 {
                var oneRow = [String:ANDataTableCell]()
                // one ring
                for (metricName, resultCells) in results.metricDataSet {
                    oneRow[metricName] = resultCells.first
                }
                treeRingMapTable.addRow(time, cells: oneRow)
            }
            break
            
        // mode_2
        case ShowTRMapMode.mode_2:
            // all row
            for (assessmentName, results) in gameResultTable.gameResultForMode_2 {
                var oneRow = [String:ANDataTableCell]()
                // one row
                for (metricName, resultCells) in results.metricDataSet {
                    oneRow[metricName] = resultCells.first
                }
                treeRingMapTable.addRow(assessmentName, cells: oneRow)
            }
            break
            
        // mode_3
        case ShowTRMapMode.mode_3:
            // all row
            for (riskName, results) in gameResultTable.gameResultForMode_3 {
                var oneRow = [String:ANDataTableCell]()
                // one row
                for (metricName, resultCells) in results.metricDataSet {
                    oneRow[metricName] = resultCells.first
                }
                treeRingMapTable.addRow(riskName, cells: oneRow)
            }
            break
            
        // mode_4
        case ShowTRMapMode.mode_4:
            // all row
            for (riskName, results) in gameResultTable.gameResultForMode_4 {
                var oneRow = [String:ANDataTableCell]()
                // one row
                for (metricName, resultCells) in results.metricDataSet {
                    oneRow[metricName] = resultCells.first
                }
                treeRingMapTable.addRow(riskName, cells: oneRow)
            }
            break
            
        // mode_5
        case ShowTRMapMode.mode_5:
            // all row
            for (userName, results) in gameResultTable.gameResultForMode_5 {
                var oneRow = [String:ANDataTableCell]()
                // one row
                for (metricName, resultCells) in results.metricDataSet {
                    oneRow[metricName] = resultCells.first
                }
                treeRingMapTable.addRow(userName, cells: oneRow)
            }
            break
            
        // mode_6
        case ShowTRMapMode.mode_6:
            // all row
            for (userName, results) in gameResultTable.gameResultForMode_6 {
                var oneRow = [String:ANDataTableCell]()
                // one row
                for (metricName, resultCells) in results.metricDataSet {
                    oneRow[metricName] = resultCells.first
                }
                treeRingMapTable.addRow(userName, cells: oneRow)
            }
            break
            
        // mode_7
        case ShowTRMapMode.mode_7:
            // all row
            for (userName, results) in gameResultTable.gameResultForMode_7 {
                var oneRow = [String:ANDataTableCell]()
                // one row
                for (metricName, resultCells) in results.metricDataSet {
                    oneRow[metricName] = resultCells.first
                }
                treeRingMapTable.addRow(userName, cells: oneRow)
            }
            break
            
        default:
            break
        }
        
    }
    
    // MARK: common function
    // add back button for test
    func addBackButtonForTRMapView(){
        let backButton = UIButton(frame: CGRect(x: 0, y: viewHeight - gap, width: viewWidth, height: gap))
        backButton.setTitle("Click  here  to  back", for: .normal)
        backButton.titleLabel?.textAlignment = .center
        backButton.setTitleColor(UIColor(red: 151.0/255.0, green: 190/255.0, blue: 76/255.0, alpha: 1.0), for: .normal)
        backButton.backgroundColor = UIColor.white
        backButton.addTarget(self, action: #selector(backAction(_:)), for: .touchUpInside)
        view.addSubview(backButton)
    }
    
    func backAction(_ button: UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return UIInterfaceOrientationMask.landscape
    }
    
    override var shouldAutorotate: Bool{
        return true
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeRight
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
}

// data set for slice and dice (to be moved into a seperate file)
class UserGameResults {
    // data by metric {metricName, [ANDataTableCell]}
    var metricDataSet = [String: [ANDataTableCell]]()
}

// ring data set
class GameResultDataTable {
    // risk model game name
    var riskModelName = String()
    // table metric column names used for metricKey {metrickey, metricName}.  The names are used in UserGameResults.metricDataSet
    var metricColumns = [String: String]()
    // {userName, UserGameResults}
    var userGameResultRows = [String: UserGameResults]()
    // {time, UserGameResults}
    var gameResultForMode_1 = [String: UserGameResults]()
    // {assessmentName, UserGameResults}
    var gameResultForMode_2 = [String: UserGameResults]()
    // {riskName, UserGameResults}
    var gameResultForMode_3 = [String: UserGameResults]()
    // {riskname, UserGameResults}
    var gameResultForMode_4 = [String: UserGameResults]()
    // {userName, UserGameResults}
    var gameResultForMode_5 = [String: UserGameResults]()
    // {userName, UserGameResults}
    var gameResultForMode_6 = [String: UserGameResults]()
    // {userName, UserGameResults}
    var gameResultForMode_7 = [String: UserGameResults]()
    
}
