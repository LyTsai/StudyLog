//
//  TreeRingMapDataTable.swift
//  AnnielyticX
//
//  Created by iMac on 2019/3/4.
//  Copyright © 2019年 AnnielyticX. All rights reserved.
//

import Foundation

class TreeRingMapDataTable {
    // title of the treeRingMap, display as arc string
    var title = ""
    
    // MARK: -------- set
    // readOnly
    // columns, around the fan's arc
    fileprivate var columnModels = [TreeRingMapAxisDataModel]()
    // rows, bottom of the fan
    fileprivate var rowModels = [TreeRingMapAxisDataModel]()
    // [rowKey: [columnKey: cell]]
    fileprivate var rowColumnValue = [String: [String: ANDataTableCell]]()
    
    // set columns
    func createTableColumns(_ columns: [TreeRingMapAxisDataModel]) {
        columnModels = columns
    }
    
    // set rows, cells
    func addRow(_ rowModel: TreeRingMapAxisDataModel, cells: [String: ANDataTableCell]) {
        rowColumnValue[rowModel.key] = cells
        rowModels.append(rowModel)
    }
    
    // MARK: -------- get
    // get row
    func rowModel(_ rowIndex: Int) -> TreeRingMapAxisDataModel? {
        if (rowIndex < 0 || rowIndex >= rowModels.count){
            return nil
        }
        
        return rowModels[rowIndex]
    }
    
    // get all real ANDataTableCells rows
    func numberOfRows() -> Int {
        return rowColumnValue.count
    }
    
    // get columns
    func columnModel(_ columnIndex: Int) -> TreeRingMapAxisDataModel? {
        if (columnIndex < 0 || columnIndex >= columnModels.count) {
            return nil
        }
        return columnModels[columnIndex]
    }
    
    func numberOfColumns() -> Int {
        return columnModels.count
    }
    
    // access the table cell by column index and row index
    func cellAt(_ columnIndex: Int, rowIndex: Int) -> ANDataTableCell? {
        if (columnIndex < 0 || columnIndex >= columnModels.count) || (rowIndex < 0 || rowIndex >= rowModels.count) {
            return nil
        }
        
        let row = rowModels[rowIndex]
        let column = columnModels[columnIndex]
        
        return rowColumnValue[row.key]?[column.key]
    }
}
