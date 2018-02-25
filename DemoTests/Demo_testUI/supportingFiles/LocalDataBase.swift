//
//  LocalDataBase.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/2/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
import FMDB

class LocalDatabase {
    static let sharedDatabase = LocalDatabase()
    
    fileprivate var database: FMDatabase!
//    fileprivate var databaseQueue: FMDatabaseQueue!
//    fileprivate let primaryKey = "flightCode"
    
    init() {
        let basePath = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!.appending("lacalDataBase.sqlite")
        database = FMDatabase(path: basePath)
//        databaseQueue = FMDatabaseQueue(path: basePath)
        
        createTables()
    }
    
    fileprivate func createTables() {
        guard database.open() else {
            print("unable to open database")
            return
        }
        createTableWithName("CardInfo", model: CardInfoObjModel())
        
        database.close()
    }
    
    func getModelNames(_ model: AnyObject) -> [String] {
        var propertyCount: UInt32 = 0
        var names = [String]()
        if let properties = class_copyPropertyList(model.classForCoder, &propertyCount) {
            for i in 0..<Int(propertyCount) {
                if let property = properties[i] {
                    if let nameString = String(validatingUTF8: property_getName(property)) {
                        names.append(nameString)
                    }
                }
            }
        }
        
        return names
    }
    
    
}

// operation of tables
extension LocalDatabase {
    // create
    func createTableWithName(_ tableName: String, model: AnyObject)  {
        if !database.tableExists(tableName) {
            do {
                let modelNames = getModelNames(model)
                var sqlString = "create table if not extists \(tableName) ("
                for name in modelNames {
                    sqlString.append("\(name) text,")
                }
                sqlString.removeLast()
                sqlString.append(")")
                
                try database.executeUpdate(sqlString, values: nil)
            } catch {
                print("failed: \(error.localizedDescription)")
            }
        }
    }
    
    
    // add or change
    func insertModelArray(_ modelArray: [AnyObject], toTable tableName: String) {
        guard database.open() && database.tableExists(tableName) else {
            print("unable to open database or table does not exit")
            return
        }
        
        var sqlString = "insert or replace into \(tableName) ("
        for model in modelArray {
            let names = getModelNames(model)
            for name in names {
                sqlString.append("'\(name)',")
            }
            sqlString.removeLast()
            sqlString.append(") values (")
            
            for name in names {
                if let value = model.value(forKey: name) {
                    sqlString.append("'\(value)',")
                }
            }
            
            sqlString.removeLast()
            sqlString.append(");")
        }
        
        sqlString.removeLast()
        database.executeStatements(sqlString)
        
        database.close()
    }
    
    // search
    func searchModel(_ model: AnyObject, withKey: String, value: String, inTable tableName: String) {
        
    }
    // delete
    func deleteModel(_ model: AnyObject, inTable tableName: String) {
        
    }
}
