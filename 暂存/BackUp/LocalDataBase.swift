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

class LocalDatabase {
    // singleton
    static let sharedDatabase = LocalDatabase()
    
    // readonly
    var database: FMDatabase! {
        return _database
    }
    fileprivate var _database: FMDatabase!
//    fileprivate var databaseQueue: FMDatabaseQueue!
    fileprivate let primaryKey = "key"
    fileprivate let foreignKeys = "PRAGMA foreign_keys"
    
    init() {
        // database saved in /Documents/...
        let basePath = Bundle.main.path(forResource: "AnnielyticxLocalDB.db", ofType: nil)
//            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/AnnielyticxLocalDB.db")
    
//        let basePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/localDatabase.sqlite")
        _database = FMDatabase(path: basePath)
//        databaseQueue = FMDatabaseQueue(path: basePath)
        
        // foreign keys
//        if _database.open() {
//            if enableForeignKeys() == 0 {
//                do {
//                    try _database.executeUpdate("\(foreignKeys) = ON;", values: nil)
//                    let _ = enableForeignKeys()
//                }catch {
//                    print(error.localizedDescription)
//                }
//            }
//            _database.close()
//        }else {
//            print("failed to open data base")
//        }
//
        print(basePath)
    }
   
    fileprivate func enableForeignKeys() -> Int32 {
        var enabled: Int32 = 0
        do {
            let resultSet = try _database.executeQuery(foreignKeys, values: nil)
            if resultSet.next() {
                enabled = resultSet.int(forColumnIndex: 0)
            }
            resultSet.close()
        }catch {
            print(error.localizedDescription)
        }
        
        return enabled
    }
}

// operation of tables
extension LocalDatabase {
    // create
    func createTableWithName(_ tableName: String, model: AnyObject) {
//        if !database.tableExists(tableName) {
//            do {
//                let modelNames = getPropertyNames(model)
//                var sqlString = "create table if not exists \(tableName) (\(primaryKey) text primary key,"
//                for name in modelNames {
//                    let value = model.value(forKey: name)
//
//                    if stringConvertable(value) && name != primaryKey {
//                        sqlString.append("\(name) text,")
//                    }
//                }
//                sqlString.removeLast()
//                sqlString.append(")")
//
//                try database.executeUpdate(sqlString, values: nil)
//
//            } catch {
//                print("---failed: \(error.localizedDescription)")
//            }
//        }else {
//            print("already created")
//        }
    }
    
    func stringConvertable(_ value: Any?) -> Bool {
//        print(CFCopyTypeIDDescription(CFGetTypeID(value as CFTypeRef))) // CFXXXX, not fine with optional type
//        if (value is [String]) {
//            print("[string]")
//        }else if (value is [String : String].Type) {
//            print("dictionary")
//        }else if (value is [URL]) {
//            print("url array")
//        }else if (value is String) {
//            print("string")
//        }else if(value is URL) {
//            print("url")
//        }
        
        // all take as String....
//        else if (value is String?) {
//            print("optional string")
//        }else if (value is URL?) {
//            print("url")
//        }
//
        
        
        if (value is [String]) || (value is [String : String]) || (value is [URL])
            || (value is String) || (value is URL) || (value is String?) || (value is URL?) {
            
            
//              || (value is Int) || (value is NSNumber) || (value is Float) || (value is Int?) || (value is NSNumber?) || (value is Float?)
            return true
        }
        
        return false
    }
    
    
    // add or change
    func insertModelArray(_ modelArray: [AnyObject], toTable tableName: String) {
        guard database.tableExists(tableName) else {
            print("table does not exit")
            return
        }
        
        // insert or replace one by one
        for model in modelArray {
            var sqlString = "insert or replace into \(tableName) ("
            var valueString = ""
            for name in getPropertyNames(model) {
                // not nil
                if let value = model.value(forKey: name) {
                    if stringConvertable(value) {
                        sqlString.append("\(name),")
                        
                        // value saved as string
                        var valueS = ""
                        if JSONSerialization.isValidJSONObject(value) {
                            // [String] || [String: [String]]
                            do {
                                let jsonData = try JSONSerialization.data(withJSONObject: value, options: [.prettyPrinted])
                                valueS = String(data: jsonData, encoding: .utf8)!
                            }catch {
                                print("---error: \(error.localizedDescription)")
                            }
                        }else {
                            valueS = String(describing: value)
                        }
                        
                        // in case there is a "'" in this vauleS
                        valueString.append("'\(convertToBase64(valueS))',")
                    }
                }
            }
            
            sqlString.removeLast()
            valueString.removeLast()
            
            sqlString.append(") values (\(valueString));")

            database.executeStatements(sqlString)
        }
    }
    
    
    func addColumn(_ columnName: String, inTable tableName: String) {
        if database.tableExists(tableName) && !database.columnExists(columnName, inTableWithName: tableName) {
            let sql = "alter table \(tableName) add \(columnName) text"
            do {
                try database.executeUpdate(sql, values: nil)
            }catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func addValue(_ value: String, forColumn columnName: String, key: String, inTable tableName: String) {
        if database.tableExists(tableName) {
        let sqlString = "insert or replace into \(tableName) (\(primaryKey), \(columnName)) values(\(convertToBase64(key)), \(convertToBase64(value)));"
        database.executeStatements(sqlString)
        }
    }
    
    // search
    // key
    func getModelsWithKey(_ key: String, value: String, model: AnyObject, inTable tableName: String) -> [[String: String]] {
        var resultArray = [[String: String]]()
        guard database.tableExists(tableName) else {
            print("table does not exit")
            return resultArray
        }
        
        let sqlString = "select * from \(tableName) where \(key)='\(convertToBase64(value))'"
        do {
            let resultSet = try database.executeQuery(sqlString, values: nil)
            resultArray = getResultFromResultSet(resultSet, model: model)
        }catch {
            print("---failed: \(error.localizedDescription)")
        }
        
        return resultArray
    }
    
    func getModelsWithDic(_ dic: [String: String], model: AnyObject, inTable tableName: String) -> [[String: String]] {
        var resultArray = [[String: String]]()
        guard database.tableExists(tableName) else {
            print("table does not exit")
            return resultArray
        }
        
        var sqlString = "select * from \(tableName) where "
        for (key, value) in dic {
            sqlString.append("\(key)='\(convertToBase64(value))' and ")
        }
        
        let startIndex = sqlString.index(sqlString.endIndex, offsetBy: -5)
        sqlString.removeSubrange(startIndex..<sqlString.endIndex)
        
        do {
            let resultSet = try database.executeQuery(sqlString, values: nil)
            resultArray = getResultFromResultSet(resultSet, model: model)
        }catch {
            print("---failed: \(error.localizedDescription)")
        }
        
        return resultArray
    }
    
    
    func getAllModels(_ model: AnyObject, tableName: String) -> [[String: String]] {
        var resultArray = [[String: String]]()
        guard database.tableExists(tableName) else {
            print("\(tableName) does not exist")
            return resultArray
        }
        
        let sqlString = "select * from \(tableName)"
        do {
            let fetch = try database.executeQuery(sqlString, values: nil)
            resultArray = getResultFromResultSet(fetch, model: model)
        }catch {
            print(error.localizedDescription)
        }
    
        return resultArray
    }
    
    
    func setupModel(_ model: AnyObject, resultDic: [String: String]) {
        for (key, value) in resultDic {
            let modelValue = model.value(forKey: key)
            // JSON
            if JSONSerialization.isValidJSONObject(modelValue) {
                do {
                    let jsonData = value.data(using: .utf8)!
                    let json = try JSONSerialization.jsonObject(with: jsonData, options: [.allowFragments])
                    model.setValue(json, forKey: key)
                }catch {
                    print(error.localizedDescription)
                }
            }else if value.hasPrefix("http") {
                    model.setValue(URL(string: value), forKey: key)
            }else {
                model.setValue(value, forKey: key)
            }
        }
    }
    
//    func convertInfoDic(_ infoString: String) -> [String : Any] {
//
//    }
    
    fileprivate func getResultFromResultSet(_ resultSet: FMResultSet, model: AnyObject) -> [[String: String]] {
        var resultArray = [[String: String]]()
        while resultSet.next() {
            var resultDic = [String: String]()
            for name in getPropertyNames(model) {
                if let value = resultSet.object(forColumn: name) {
                    if value is String {
                        let valueS = convertBase64String(value as! String)
                        resultDic[name] = valueS
                    }
                }
            }
            
            if resultDic.count != 0 && resultDic[primaryKey] != nil && resultDic[primaryKey] != "" {
                resultArray.append(resultDic)
            }
        }
        
        return resultArray
    }
    
    // delete
    func dropModel(_ model: AnyObject, inTable tableName: String) {
        // "delete from \(tableName) where"
    }
    
    func dropTable(_ tableName: String) {
        // "drop table \(tableName)"
    }
    
    func deleteDataInTable(_ tableName: String) {
        // "delete from \(tableName)"
    }
    
    
    fileprivate func convertToBase64(_ string: String) -> String {
        return string.data(using: .utf8)?.base64EncodedString() ?? "" // base64 string
    }
    
    fileprivate func convertBase64String(_ base64: String) -> String {
        if let tData = Data(base64Encoded: base64) {
            return String(data: tData, encoding: .utf8) ?? "" // string
        }else {
            return ""
        }
        
    }
}
