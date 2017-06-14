//
//  TRMetricDataTable.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/11.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

// object that holds the table of measured metric values and information

class TRMetricDataTable: NSObject {
    
    // data set model:
    // first element ==> [string]: columnkeys
    // next to last  ==> [Any]:    first element is user name, next to last is ANDataTableCell
    
    var metricValues: [Any]?
    var columnKey2Index = [String : NSNumber]()
    var title: String?
    
    init(_ title: String) {
        super.init()
        self.title = title
        metricValues = [Any]()
    }
    
    // compose metricValues[i] after metricValues[0]
    func addRow(_ rowID: String, cells: [String: ANDataTableCell]){
        let columnKeys = metricValues![0] as! [String]
        // first element ==> row ID
        // next to last  ==> ANDataTableCell
        var newRow = [Any]()
        newRow.append(rowID)
        for i in 0..<columnKeys.count{
            newRow.append(cells[columnKeys[i]]!)
        }
        metricValues?.append(newRow)
    }
    
    // get the first element of row data: rowID
    func rowIDString(_ row: Int) -> String{
        let rowIndex = row + 1
        return (metricValues![rowIndex] as! [Any])[0] as! String
    }
    
    // get all real ANDataTableCells rows
    func numberOfRows() -> Int{
        if metricValues!.count <= 1{
            return 0
        }
        return metricValues!.count - 1
    }
    
    func cellAt(_ columnKey: String, rowIndex: Int) -> ANDataTableCell?{
        let columnIndex: Int
        if columnKey2Index[columnKey] == nil {
            columnIndex = -1
        }else{
            columnIndex = columnKey2Index[columnKey]!.intValue + 1
        }
        let row = rowIndex + 1
        if columnIndex < 0 {
            return nil
        }else{
            return (metricValues![row] as! [Any])[columnIndex] as? ANDataTableCell
        }
        
    }
    
    
    // set metricValues[0] and set columnKey2Index(columnKey - index)
    func createTableColumnKeys(_ columnKeys: [String]){
        metricValues?.append(columnKeys)
        for i in 0..<columnKeys.count{
            columnKey2Index[columnKeys[i]] = NSNumber.init(value: i)
        
        }
    }
  
}
