//
//  PlistFileManager.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 02-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import Foundation

class PlistFileManager{
    
    class func loadPlistFile(named name:String) -> [String:Any]?{
        let plistFileLocation = Bundle.main.url(forResource: name, withExtension: "plist")
        guard let location = plistFileLocation else{
            return nil
        }
        let fileContent = FileManager.default.contents(atPath: location.path)
        guard let fileData = fileContent else{
            return nil
        }
        do{
            let fileDictionary = try PropertyListSerialization.propertyList(from: fileData, options: .mutableContainersAndLeaves, format: nil) as! [String:Any]
            return fileDictionary
        }catch{
            return nil
        }
    }
}
