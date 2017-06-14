//
//  TRDataTableFactory.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/11.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRDataTableFactory: NSObject {
    
    // two types of dataTable for test : input true or false
    func createLowVitDGameOfScoresTable(_ staticOrDynamic: Bool) -> TRMetricDataTable{
        var table: TRMetricDataTable
        if staticOrDynamic == true{
            table = TRMetricDataTable.init("-- Low Vitmin D Static Risk Factors -- ")
        }else{
            table = TRMetricDataTable.init("-- Controllable Risk Factors-- ")
        }
        
        // all columns in the table
        var columnKeys = [String]()
        columnKeys.append(AGE)
        columnKeys.append(SKIN)
        columnKeys.append(Environment)
        columnKeys.append(Latitude)
        columnKeys.append(Season)
        columnKeys.append(Pregnancy)
        columnKeys.append(DNA)
        columnKeys.append(Diseaases)
        columnKeys.append(Medications)
        
        // create the table columns
        table.createTableColumnKeys(columnKeys)
        
        // create and feed table ANDataTableCell objects
        
        
        // add row of metric measurements
        
        // John 
        var viewSize = 16
        var oneRow = CreateDataDic(viewSize)
        table.addRow("John", cells: oneRow)
        
        // susan
        viewSize = 16
        oneRow = CreateDataDic(viewSize)
        table.addRow("Susan", cells: oneRow)
        
        // david
        viewSize = 16
        oneRow = CreateDataDic(viewSize)
        table.addRow("David", cells: oneRow)
        
        // jennifer
        viewSize = 16
        oneRow = CreateDataDic(viewSize)
        table.addRow("Jennifer", cells: oneRow)
        
        // linda
        viewSize = 16
        oneRow = CreateDataDic(viewSize)
        table.addRow("Linda", cells: oneRow)
        
        // mark
        viewSize = 16
        oneRow = CreateDataDic(viewSize)
        table.addRow("Mark", cells: oneRow)
        
        // linda
        viewSize = 16
        oneRow = CreateDataDic(viewSize)
        table.addRow("Susan", cells: oneRow)
        
        // jacson
        viewSize = 16
        oneRow = CreateDataDic(viewSize)
        table.addRow("Jacson", cells: oneRow)
        
        return table
    }
    
    func CreateDataDic(_ viewSize: Int) -> [String: ANDataTableCell]{
        var oneRow = [String: ANDataTableCell]()
        oneRow[AGE] = ANDataTableCell.create(AGE, symbol: "", value: 0, image: UIImage.init(named: "face1"), viewSize: viewSize, tip: "Young")
        oneRow[SKIN] = ANDataTableCell.create(SKIN, symbol: "", value: 0, image: UIImage.init(named: "face1"), viewSize: viewSize, tip: "Dark")
        oneRow[Environment] = ANDataTableCell.create(Environment, symbol: "", value: 0, image: UIImage.init(named: "face3"), viewSize: viewSize, tip: "Mixture")
        oneRow[Latitude] = ANDataTableCell.create(Latitude, symbol: "", value: 0, image: UIImage.init(named: "face5"), viewSize: viewSize, tip: "Pollution")
        oneRow[Season] = ANDataTableCell.create(Season, symbol: "", value: 0, image: UIImage.init(named: "face1"), viewSize: viewSize, tip: "Summer")
        oneRow[Pregnancy] = ANDataTableCell.create(Pregnancy, symbol: "", value: 0, image: UIImage.init(named: "face2"), viewSize: viewSize, tip: "Pregnant")
        oneRow[DNA] = ANDataTableCell.create(DNA, symbol: "", value: 0, image: UIImage.init(named: "face3"), viewSize: viewSize, tip: "DNA")
        oneRow[Diseaases] = ANDataTableCell.create(Diseaases, symbol: "", value: 0, image: UIImage.init(named: "face1"), viewSize: viewSize, tip: "None")
        oneRow[Medications] = ANDataTableCell.create(Medications, symbol: "", value: 0, image: UIImage.init(named: "face1"), viewSize: viewSize, tip: "None")
        return oneRow
    }
}
