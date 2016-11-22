//
//  DBHandler.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 02-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import Foundation
import FMDB



class DBHandler{
    private var dbName:String = String()
    private var dbExtension:String = String()
    private var dbPath:String = String()
    private static let sharedInstance : DBHandler = DBHandler()
    private var loadedDB:Bool = false
    private var database:FMDatabase! = nil
    
    
    class func getInstance(forDatabaseWithName name:String, andExtension dbExt:String)-> DBHandler{
        sharedInstance.dbName = name
        sharedInstance.dbExtension = dbExt
        return sharedInstance
    }

    class func getInstance()->DBHandler{
        return sharedInstance
    }
    
    private init(){}
    
    func loadDB(withName name: String, andExtension ext:String)->Bool{
        let defaultFileManager = FileManager.default
        let dbPathUrl = try! defaultFileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(name).\(ext)")
        dbPath = dbPathUrl.path
        if !defaultFileManager.fileExists(atPath: dbPath){
            let dbPathBackup = Bundle.main.url(forResource: dbName, withExtension: dbExtension)
            guard let backupUrl = dbPathBackup else {
                return false
            }
            do{
                try defaultFileManager.copyItem(at: backupUrl, to: dbPathUrl)
            }
            catch{
                return false
            }
        }
        guard let db = FMDatabase(path: dbPath) else{
            return false
        }
        database = db
        return true
    }
    
    func loadDB()->Bool{
        return loadDB(withName: dbName, andExtension: dbExtension)
    }
    
    func removeDB(WithName name: String, andExtension ext:String)->Bool{
        let defaultFileManager = FileManager.default
        let dbPathUrl = try! defaultFileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(name).\(ext)")
        dbPath = dbPathUrl.path
        if !defaultFileManager.fileExists(atPath: dbPath){
            return true
        }
        
        do{
            try defaultFileManager.removeItem(at: dbPathUrl)
        }
        catch{
            return false
        }
        
        database = nil
        return true
    }
    
    func removeDB()->Bool{
        return removeDB(WithName: dbName, andExtension: dbExtension)
    }
    
    private func openDatabase()->Bool{
        guard database != nil else{
            return false
        }
        return database.open() //COncurrencia
    }
    
    private func closeDatabase()->Bool{
        guard database != nil else {
            return false
        }
        return database.close()
    }
    
    
    //Cambiar esto porque genera problemas, por el open database y ble
    func execute(Query query:String, completion:@escaping ([[String:Any]]!)->Void ){
        DispatchQueue.global().async {
            if self.openDatabase() {
                do{
                    var result = [[String:Any]]()
                    let queryResult = try self.database.executeQuery(query, values: nil)
                    guard let tableColumns =  queryResult.columnNameToIndexMap as NSDictionary as? [String:Int] else {
                        return
                    }
                    
                    while queryResult.next(){
                        var rowDictionary:[String: Any] = [String: Any]()
                        for (column, _) in tableColumns{
                            rowDictionary[column] = queryResult.object(forColumnName: column)
                        }
                        result.append(rowDictionary)
                    }
                    if self.closeDatabase() {
                        completion(result)
                    }
                    
                    
                }
                catch{
                    if self.closeDatabase(){
                        completion(nil)
                    }
                }
            }

        }
    }
    
    func executeUpdate(Query query:String, completion: @escaping (Bool)->Void){
        DispatchQueue.global().async {
            if self.openDatabase() {
                let success = self.database.executeUpdate(query, withArgumentsIn: nil)
                if self.closeDatabase() {
                    completion(success)
                    return
                }
                completion(false)
            }
        }
    }
    
    //func executeTransaction()
    //Funcion de transaccion-> execute transaction
    //Tal vez objeto query que permita generar cadena de ejecucion de consultas -> Django tiene QuerySets
}
