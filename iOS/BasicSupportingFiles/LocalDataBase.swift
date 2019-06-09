//
//  LocalDataBase.swift
//  AnnieLyticx
//
//  Created by iMac on 2018/2/25.
//  Copyright © 2018年 AnnieLyticx. All rights reserved.
//

import Foundation
import FMDB
//import CommonCryptor

func convertArrayToEncodedString(_ array: [Any]) -> String {
    if array.isEmpty {
        return ""
    }
    
    var result = ""
    do {
        let data = try JSONSerialization.data(withJSONObject: array, options: .prettyPrinted)
        result = data.base64EncodedString()
    }catch {
        print("can not convert")
    }

    return result
}

func getArrayFromEncodedString(_ encoded: String) -> [Any] {
    var array = [Any]()
    if let data = Data(base64Encoded: encoded) {
        do {
            array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [Any]
        }catch {
            
        }
    }
    
    return array
}

class LocalDatabase {
    // singleton
    static let sharedDatabase = LocalDatabase()
    
    // readonly
    var database: FMDatabase! {
        return _database
    }
    fileprivate var _database: FMDatabase!
    fileprivate let primaryKey = "Key"
    
    init() {
        let fileName = "AnnielyticxLocalDB.db"
        let localPath  = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/\(fileName)")
        print(localPath)
        
        _database = FMDatabase(path: localPath)
        
        // create
        // application
        if _database.open() {
            
            // homepage
            createTableWithName(ApplicationObjModel.tableName, columns: ApplicationObjModel.localColumns)
            
            createTableWithName(RiskTypeObjModel.tableName, columns: RiskTypeObjModel.localColumns)
            createTableWithName(MetricGroupObjModel.tableName, columns: MetricGroupObjModel.localColumns)
            createTableWithName(MetricObjModel.tableName, columns: MetricObjModel.localColumns)
            createTableWithName(RiskObjModel.tableName, columns: RiskObjModel.localColumns)
            
            // login
            createTableWithName(UserObjModel.tableName, columns: UserObjModel.localColumns)
            createTableWithName(PseudoUserObjModel.tableName, columns: PseudoUserObjModel.localColumns)
            createTableWithName(UserGroupObjModel.tableName, columns: UserGroupObjModel.localColumns)
            
            // get card
            createTableWithName(CardInfoObjModel.tableName, columns: CardInfoObjModel.localColumns)
            createTableWithName(RiskFactorObjModel.tableName, columns: RiskFactorObjModel.localColumns)
            createTableWithName(CardOptionObjModel.tableName, columns: CardOptionObjModel.localColumns)
            createTableWithName(MatchObjModel.tableName, columns: MatchObjModel.localColumns)
            createTableWithName(ClassifierObjModel.tableName, columns: ClassifierObjModel.localColumns)
            createTableWithName(ClassificationObjModel.tableName, columns: ClassificationObjModel.localColumns)
            createTableWithName(RangeGroupObjModel.tableName, columns: RangeGroupObjModel.localColumns)
            createTableWithName(RangeObjModel.tableName, columns: RangeObjModel.localColumns)
            
            // measurement
            createTableWithName(MeasurementObjModel.tableName, columns: MeasurementObjModel.localColumns)
            
            // fulfillment
            createTableWithName(FulfilledActionMatchObjModel.tableName, columns: FulfilledActionMatchObjModel.localColumns)
            
            _database.close()
        }
    }
}


// SQL strings
extension LocalDatabase {
    func createTableWithName(_ tableName: String, columns: [String: String]) {
        if !database.tableExists(tableName) {
            var sqlString = "create table if not exists \(tableName) (\(primaryKey) text primary key,"
            for (key, value) in columns {
                if key == primaryKey {
                    continue
                }
                sqlString.append("\(key) \(value),")
            }
            sqlString.removeLast()
            sqlString.append(")")
            
            do {
                try database.executeUpdate(sqlString, values: nil)
                
            } catch {
                print("--- add failed: \(error.localizedDescription)")
            }
        }else {
           // column is changed?
            for (name, type) in columns {
                if !database.columnExists(name, inTableWithName: tableName) {
                    // added colum
                    let alterString = "alter table \(tableName) add \(name) \(type)"
                    do {
                        try database.executeUpdate(alterString, values: nil)
                    }catch {
                        print("alter failed: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    
    func insertModelDic(_ dic: [String: Any], tableName: String) {
        if dic.isEmpty {
            print("no data to add")
            return
        }
        
        guard database.tableExists(tableName) else {
            print("table does not exist")
            return
        }
       
        var keyString = ""
        var valueString = ""
        for (key, value) in dic {
            if database.columnExists(key, inTableWithName: tableName) {
                keyString.append("\(key),")
                
                if value is String {
                    var valueS = value as! String
                    if valueS.contains("'") {
                        let indexes = valueS.indexes(of: "'")
                        for index in indexes {
                           valueS.insert("'", at: index)
                        }
                    }
                    
                    valueString.append("'\(valueS)',")
                }else {
                    valueString.append("\(value),")
                }
            }
        }
        
        keyString.removeLast()
        valueString.removeLast()
        
        let sqlString = "insert or replace into \(tableName) (\(keyString)) values (\(valueString));"

        database.executeStatements(sqlString)
    }
    
    // search
    fileprivate func getResultFromResultSet(_ resultSet: FMResultSet, inTable tableName: String) -> [[String: Any]] {
        var resultArray = [[String: Any]]()
        while resultSet.next() {
            var resultDic = [String: Any]()
            let total = resultSet.columnCount
            for index in 0..<total {
                if let name = resultSet.columnName(for: index) {
                    if let value = resultSet.object(forColumn: name) {
                        resultDic[name] = value
                    }
                }
            }
            resultArray.append(resultDic)
        }
        
        return resultArray
    }
    
    func getAllModels(_ tableName: String) -> [[String: Any]] {
        guard database.tableExists(tableName) else {
            print("\(tableName) does not exist")
            return []
        }
        
        var resultArray = [[String: Any]]()
        let sqlString = "select * from \(tableName)"
        do {
            let fetch = try database.executeQuery(sqlString, values: nil)
            resultArray = getResultFromResultSet(fetch, inTable: tableName)
        }catch {
            print(error.localizedDescription)
        }
        
        return resultArray
    }
    
    
    // key
    func getModelDicWithPrimaryKey(_ key: String, inTable tableName: String) -> [String: Any] {
        return getModelDicsWithColumnName(primaryKey, value: key, inTable: tableName).first ?? [:]
    }
    
    func getModelDicsWithColumnName(_ name: String, value: Any, inTable tableName: String) -> [[String: Any]] {
        guard database.tableExists(tableName) && database.columnExists(name, inTableWithName: tableName) else {
            print("table does not exist")
            return []
        }
        
        var resultArray = [[String: Any]]()
        var sqlString = ""
        if value is String {
            sqlString  = "select * from \(tableName) where \(name)='\(value)'"
        }else {
            sqlString  = "select * from \(tableName) where \(name)=\(value)"
        }
        
        do {
            let fetch = try database.executeQuery(sqlString, values: nil)
            resultArray = getResultFromResultSet(fetch, inTable: tableName)
        }catch {
            print(error.localizedDescription)
        }
    
        return resultArray
    }
    
    
    func getModelDicsWithCondition(_ condition: [String : Any], inTable tableName: String) -> [[String: Any]] {
        guard database.tableExists(tableName) else {
            print("table does not exist")
            return []
        }
        
        var resultArray = [[String: Any]]()
        var sqlString = "select * from \(tableName) where "
        for (name, value) in condition {
            if value is String {
                sqlString.append("\(name)='\(value)' and ")
            }else {
                sqlString.append("\(name)=\(value) and ")
            }
        }
        sqlString.removeLast(5)

        do {
            let fetch = try database.executeQuery(sqlString, values: nil)
            resultArray = getResultFromResultSet(fetch, inTable: tableName)
        }catch {
            print(error.localizedDescription)
        }
        
        return resultArray
    }

    
    // delete
    func deleteByKey(_ key: String, inTable tableName: String) {
        let sqlString = "delete from \(tableName) where \(primaryKey)='\(key)'"
        database.executeStatements(sqlString)
    }
    
    func deleteByColumn(_ columnName: String, value: String, inTable tableName: String) {
        let sqlString = "delete from \(tableName) where \(columnName)='\(value)'"
        database.executeStatements(sqlString)
    }
}
