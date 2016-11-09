//
//  QuerySet.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 18-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import Foundation

enum queryErrors:Error{
    case badQuery
    case invalidJoin
    case invalidCondition
}

class QuerySet{
    var tableName:String!{ return nil }
    private var query:String! = nil
    
    init?(){
        guard tableName != nil else{
            return nil
        }
    }
    
    private init(withQuery q:String) {
        query = q
    }
    
    func getQuery()->String!{
        guard let safeQuery = query else{
            return nil
        }
        return safeQuery.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func all()throws -> QuerySet{
        guard query == nil else{
            throw queryErrors.badQuery
        }
        
        return QuerySet(withQuery: "SELECT * FROM \(tableName!) ")
    }
    
    func get(columns:[String])throws ->QuerySet {
        guard query == nil else{
            throw queryErrors.badQuery
        }
        
        var select:String = ""
        for c in columns{
            select += (c + ", ")
        }
        select = select.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        select.remove(at: select.index(before: select.endIndex))
        
        return QuerySet(withQuery: "SELECT \(select) FROM \(tableName!) ")
    }
    
    private func transform(value:Any)->String{
        if let insertInteger = value as? Int {
            return "\(insertInteger)"
        }
        else if let insertReal = value as? CGFloat{
            return "\(insertReal)"
            
        }
        else if let insertString = value as? String{
            return "\"\(insertString)\""
        }
        return ""
    }
    
    func whereCond(conditions:[String:Any]) throws -> QuerySet{
        guard query != nil && !query.contains(" WHERE ") && (query.contains("DELETE") ||
            query.contains("SELECT") || query.contains("UPDATE")) else{
            throw queryErrors.invalidCondition
        }
        var whereStatement = "WHERE "
        for (key, value) in conditions{
            whereStatement += "\(key)=\(transform(value: value)) AND "
        }
        
        whereStatement = whereStatement.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let endIndex = whereStatement.range(of: "AND", options: .backwards)
        whereStatement = whereStatement.substring(to: endIndex!.lowerBound)
        
        return QuerySet(withQuery: query + whereStatement)
    }
    
    func join(table:QuerySet, onColumn thisTableColumn: String, andColumn thatTableColumn:String) throws ->QuerySet{
        guard query != nil && query.contains("SELECT") && !query.contains(" WHERE ") else{
            throw queryErrors.invalidJoin
        }
        
        let joinStatement = "JOIN \(table.tableName!) ON \(thisTableColumn)=\(thatTableColumn) "
        return QuerySet(withQuery: query + joinStatement)
    }
    
    func update(values:[String:Any]) throws ->QuerySet{
        guard query==nil else{
            throw queryErrors.badQuery
        }
        var updateStatement = "UPDATE \(tableName!) SET "
        for (key, value) in values{
            updateStatement += ("\(key)=\(transform(value: value)), ")
        }
        updateStatement = updateStatement.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        updateStatement = updateStatement.substring(to:
            updateStatement.index(before: updateStatement.endIndex))
        
        return QuerySet(withQuery: updateStatement)
    }
    
    func insert(values:[String:Any]) throws ->QuerySet{
        guard query==nil else{
            throw queryErrors.badQuery
        }
        let keys = values.keys
        let insertValues = values.values
        var insert = "INSERT INTO \(tableName!) ("
        
        for key in keys{
            insert += "\(key),"
        }
        insert = insert.substring(to: insert.index(before: insert.endIndex))
        insert += ") VALUES ("
        
        for value in insertValues{
            insert += "\(transform(value: value)), "
        }
        insert = insert.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        insert = insert.substring(to: insert.index(before: insert.endIndex))
        insert += ")"
        
        return QuerySet(withQuery: insert)
    }
    
    func delete() throws -> QuerySet{
        guard query==nil else{
            throw queryErrors.badQuery
        }
        let delete = "DELETE FROM \(tableName!) "
        return QuerySet(withQuery: delete)
    }
    
    func exec(completion:@escaping ([[String:Any]]!)->Void){
        let handler = DBHandler.getInstance()
        handler.execute(Query: query!, completion: completion)
    }
    
    func execUpdate(completion: @escaping (Bool)->Void){
        let handler = DBHandler.getInstance()
        handler.executeUpdate(Query: query!, completion: completion)
    }

}
