//
//  TRDataTableSliceView.swift
//  TreeRingMap_Swift
//
//  Created by dingf on 17/3/16.
//  Copyright © 2017年 MH.dingf. All rights reserved.
//

import UIKit

class TRDataTableSliceView: NSObject {
    var rowTexts: [String]?
    var columns: [Any]?
    override init() {
        super.init()
        rowTexts = [String]()
        columns = [Any]()
    }
    
    func cellOfRowAndCol(_ row: Int, col: Int) -> TRCell{
        return (columns![col] as! [Any])[row + 1] as! TRCell
    }
    
    func numberOfRows() -> Int{
        if rowTexts == nil {
            return 0
        }else{
            return rowTexts!.count
        }
    }
    
    func numberOfColumns() -> Int{
        if columns == nil {
            return 0
        }else{
            return columns!.count
        }
    }
    
    func colTickLabels() -> [String]{
        var colTexts = [String]()
        for i in 0..<columns!.count{
            let text = (columns![i] as! [Any])[0] as! String
            colTexts.append(text)
        }
        return colTexts
    }
    
    
    // convert instence of TRMetricDataTable to TRDataTableSliceView
    func loadMetricDataTable(_ dataTable: TRMetricDataTable){
        let numberOfRows = dataTable.numberOfRows()
        var rowLabels = [String]()
        for row in 0..<numberOfRows{
            rowLabels.append(dataTable.rowIDString(row))
        }
        
        // set row texts
        rowTexts = rowLabels
       
        // create collection of one column objects
        if columns != nil {
            columns!.removeAll()
        }
        //
        let columnKeys = dataTable.metricValues![0] as! [String]
        
        // first element of each row is rowID
        for i in 0..<columnKeys.count{
            var oneColumn = [Any]()
            let index = columnKeys.count - 1 - i
            
            let columnKey = columnKeys[index]
            oneColumn.append(columnKey)
            for row in 0..<numberOfRows{
                // ANDataTableCell
                let cell = dataTable.cellAt(columnKey, rowIndex: row)
                if cell == nil {continue}
                // TRCell
                let oneCell = TRCell.init()
                oneCell.name = cell?.unit_name
                oneCell.unit = cell?.unit_symbol
                oneCell.text = cell?.tip
                oneCell.displaySize = cell?.viewSize
                oneCell.value = cell?.value
                oneCell.image = cell?.image
                oneColumn.append(oneCell)
                
            }
            columns?.append(oneColumn)
        }
    }
   
}
