//
//  DBHandler.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 02-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import Foundation

class DBHandler{
    private var dbName:String = String()
    private var dbExtension:String = String()
    private var dbPath:String = String()
    private static let instance : DBHandler = DBHandler()
    private var loadedDB:Bool = false
    
    class func getInstance(forDatabaseWithName name:String, andExtension dbExt:String)-> DBHandler{
        instance.dbName = name
        instance.dbExtension = dbExt
        return instance
    }

    class func getInstance()->DBHandler{
        return instance
    }
    
    private init(){}
    
    func loadDB()->Bool{
        let defaultFileManager = FileManager.default
        let dbPathUrl = try! defaultFileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("\(dbName).\(dbExtension)")
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
        return true
    }
    
}
