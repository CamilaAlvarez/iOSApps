//
//  DatabaseTests.swift
//  clothingClassifier
//
//  Created by Camila Alvarez on 30-10-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import XCTest
@testable import clothingClassifier

class DatabaseTests: XCTestCase {
    var expectation:XCTestExpectation!
    
    var handler:DBHandler{
        let auxHandler = DBHandler.getInstance(forDatabaseWithName: "db", andExtension: "sqlite")
        return auxHandler
    }
    override func setUp() {
        super.setUp()
        guard handler.loadDB(withName: "dbTest", andExtension:"sqlite") else{
            fatalError("Couldn't load database")
        }
    }
    override func tearDown() {
        guard handler.removeDB(WithName:"dbTest", andExtension:"sqlite") else {
            fatalError("Couldn't remove database")
        }
        super.tearDown()
    }
    
    func testInsert() {
        expectation = expectation(description: "Insert in database")
        let table = Images()!
        let insertQuery = try? table.insert(values: ["img_url":"image_url"])
        XCTAssertNotNil(insertQuery)
        XCTAssertNotNil(insertQuery!.getQuery())
        insertQuery!.execUpdate(){success in
            XCTAssertTrue(success)
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("insert fail")
            }
        }
    }
    
    func testEmptySelect(){
        expectation = expectation(description: "Empty select from database")
        let table = Images()!
        let getQuery = try? table.all()
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        getQuery?.exec(){results in
            XCTAssertEqual(results.count, 0)
            self.expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
        
    }
    
    func testSelectAll(){
        testInsert()
        expectation = expectation(description: "select all from database")
        let table = Images()!
        let getQuery = try? table.all()
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        getQuery?.exec(){results in
            let resultArray:[[String:Any]] = results as [[String:Any]]
            var expectedResult:[String:Any] = ["img_id":1, "img_url":"image_url", "img_checked":0, "img_sent":0]
            XCTAssertEqual(results.count, 1)
            let resultDict = resultArray[0]
            XCTAssertEqual(expectedResult["img_id"] as! Int, resultDict["img_id"] as! Int)
            XCTAssertEqual(expectedResult["img_url"] as! String, resultDict["img_url"] as! String)
            XCTAssertEqual(expectedResult["img_checked"] as! Int, resultDict["img_checked"] as! Int)
            XCTAssertEqual(expectedResult["img_sent"] as! Int, resultDict["img_sent"] as! Int)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
    }
    
    func testSelectColumn(){
        testInsert()
        expectation = expectation(description: "Select certain column from database")
        let table = Images()!
        let getQuery = try? table.all()
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        getQuery?.exec(){results in
            let resultArray:[[String:Any]] = results as [[String:Any]]
            var expectedResult:[String:Any] = ["img_id":1, "img_url":"image_url", "img_checked":0, "img_sent":0]
            XCTAssertEqual(results.count, 1)
            let resultDict = resultArray[0]
            XCTAssertEqual(expectedResult["img_id"] as! Int, resultDict["img_id"] as! Int)
            XCTAssertEqual(expectedResult["img_url"] as! String, resultDict["img_url"] as! String)
            XCTAssertEqual(expectedResult["img_checked"] as! Int, resultDict["img_checked"] as! Int)
            XCTAssertEqual(expectedResult["img_sent"] as! Int, resultDict["img_sent"] as! Int)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
    }
    
    
    func testUpdateWhere(){
        testSelectAll()
        expectation = expectation(description: "update row in database")
        let table = Images()!
        let update = try? table.update(values: ["img_url":"new_url"]).whereCond(conditions: ["img_id":1])
        XCTAssertNotNil(update)
        XCTAssertNotNil(update!.getQuery())
        update!.execUpdate(){success in
            XCTAssertTrue(success)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("update fail")
            }
        }
        expectation = expectation(description: "select from database")
        let getQuery = try? table.all()
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        getQuery?.exec(){results in
            let resultArray:[[String:Any]] = results as [[String:Any]]
            var expectedResult:[String:Any] = ["img_id":1, "img_url":"new_url", "img_checked":0, "img_sent":0]
            XCTAssertEqual(results.count, 1)
            let resultDict = resultArray[0]
            XCTAssertEqual(expectedResult["img_id"] as! Int, resultDict["img_id"] as! Int)
            XCTAssertEqual(expectedResult["img_url"] as! String, resultDict["img_url"] as! String)
            XCTAssertEqual(expectedResult["img_checked"] as! Int, resultDict["img_checked"] as! Int)
            XCTAssertEqual(expectedResult["img_sent"] as! Int, resultDict["img_sent"] as! Int)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
    }
    
    func testUpdateWhere2(){
        testSelectAll()
        testInsert()
        expectation = expectation(description: "update row with condition in database")
        let table = Images()!
        let update = try? table.update(values: ["img_url":"new_url"]).whereCond(conditions: ["img_id":1])
        XCTAssertNotNil(update)
        XCTAssertNotNil(update!.getQuery())
        update!.execUpdate(){success in
            XCTAssertTrue(success)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("update fail")
            }
        }
        expectation = expectation(description: "select from database")
        let getQuery = try? table.all()
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        getQuery?.exec(){results in
            let resultArray:[[String:Any]] = results as [[String:Any]]
            var expectedResult:[String:Any] = ["img_id":1, "img_url":"new_url", "img_checked":0, "img_sent":0]
            XCTAssertEqual(results.count, 2)
            let resultDict = resultArray[0]
            let resultDict2 = resultArray[1]
            XCTAssertEqual(expectedResult["img_id"] as! Int, resultDict["img_id"] as! Int)
            XCTAssertEqual(expectedResult["img_url"] as! String, resultDict["img_url"] as! String)
            XCTAssertEqual(expectedResult["img_checked"] as! Int, resultDict["img_checked"] as! Int)
            XCTAssertEqual(expectedResult["img_sent"] as! Int, resultDict["img_sent"] as! Int)
            XCTAssertEqual(2, resultDict2["img_id"] as! Int)
            XCTAssertEqual("image_url", resultDict2["img_url"] as! String)
            XCTAssertEqual(expectedResult["img_checked"] as! Int, resultDict2["img_checked"] as! Int)
            XCTAssertEqual(expectedResult["img_sent"] as! Int, resultDict2["img_sent"] as! Int)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
    }
    
    
    func testUpdate(){
        testInsert()
        testInsert()
        expectation = expectation(description: "update row in database")
        let table = Images()!
        let update = try? table.update(values: ["img_url":"new_url"])
        XCTAssertNotNil(update)
        XCTAssertNotNil(update!.getQuery())
        update!.execUpdate(){success in
            XCTAssertTrue(success)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("update fail")
            }
        }
        expectation = expectation(description: "select from database")
        let getQuery = try? table.all()
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        getQuery?.exec(){results in
            let resultArray:[[String:Any]] = results as [[String:Any]]
            var expectedResult:[String:Any] = ["img_id":1, "img_url":"new_url", "img_checked":0, "img_sent":0]
            XCTAssertEqual(results.count, 2)
            let firstResult = resultArray[0]
            let secondResult = resultArray[1]
            XCTAssertEqual(1, firstResult["img_id"] as! Int)
            XCTAssertEqual(expectedResult["img_url"] as! String, firstResult["img_url"] as! String)
            XCTAssertEqual(expectedResult["img_checked"] as! Int, firstResult["img_checked"] as! Int)
            XCTAssertEqual(expectedResult["img_sent"] as! Int, firstResult["img_sent"] as! Int)
            XCTAssertEqual(2, secondResult["img_id"] as! Int)
            XCTAssertEqual(expectedResult["img_url"] as! String, secondResult["img_url"] as! String)
            XCTAssertEqual(expectedResult["img_checked"] as! Int, secondResult["img_checked"] as! Int)
            XCTAssertEqual(expectedResult["img_sent"] as! Int, secondResult["img_sent"] as! Int)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
    }
    
    func testSelectWhere(){
        testInsert()
        expectation = expectation(description: "select with condition from database")
        let table = Images()!
        let getQuery = try? table.get(columns: ["img_id", "img_checked"])
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        getQuery?.exec(){results in
            let resultArray:[[String:Any]] = results as [[String:Any]]
            var expectedResult:[String:Any] = ["img_id":1, "img_checked":0]
            XCTAssertEqual(results.count, 1)
            let resultDict = resultArray[0]
            XCTAssertEqual(expectedResult["img_id"] as! Int, resultDict["img_id"] as! Int)
            XCTAssertEqual(expectedResult["img_checked"] as! Int, resultDict["img_checked"] as! Int)
            XCTAssertNil(resultDict["img_sent"])
            XCTAssertNil(resultDict["img_url"])
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
    }
    
    func testSelectWhereEmpty(){
        testInsert()
        expectation = expectation(description: "Empty select from database")
        let table = Images()!
        let selectWhere = try? table.all().whereCond(conditions: ["img_url": "url"])
        XCTAssertNotNil(selectWhere)
        XCTAssertNotNil(selectWhere!.getQuery())
        selectWhere!.exec(){results in
            XCTAssertEqual(results.count, 0)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
    }
    
    func testSelectJoin(){
        testInsert()
        expectation = expectation(description: "Insert in database")
        let table = ImageCategories()!
        let insertQuery = try? table.insert(values: ["ict_id_image":1, "ict_id_category":1])
        XCTAssertNotNil(insertQuery)
        XCTAssertNotNil(insertQuery!.getQuery())
        insertQuery!.execUpdate(){success in
            XCTAssertTrue(success)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("insert fail")
            }
        }
        expectation = expectation(description: "Select with join from database")
        let joinQuery = try? table.all().join(table: Images()!, onColumn: "ict_id_image", andColumn: "img_id")
        XCTAssertNotNil(joinQuery)
        XCTAssertNotNil(joinQuery!.getQuery())
        joinQuery!.exec(){results in
            let resultArray:[[String:Any]] = results as [[String:Any]]
            var expectedResult:[String:Any] = ["img_id":1, "img_url":"image_url", "img_checked":0, "img_sent":0,
                                               "ict_id_image": 1, "ict_id_category":1]
            XCTAssertEqual(results.count, 1)
            let resultDict = resultArray[0]
            XCTAssertEqual(expectedResult["img_id"] as! Int, resultDict["img_id"] as! Int)
            XCTAssertEqual(expectedResult["img_url"] as! String, resultDict["img_url"] as! String)
            XCTAssertEqual(expectedResult["img_checked"] as! Int, resultDict["img_checked"] as! Int)
            XCTAssertEqual(expectedResult["img_sent"] as! Int, resultDict["img_sent"] as! Int)
            XCTAssertEqual(expectedResult["ict_id_image"] as! Int, resultDict["ict_id_image"] as! Int)
            XCTAssertEqual(expectedResult["ict_id_category"] as! Int, resultDict["ict_id_category"] as! Int)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select with join fail")
            }
        }
    }
    
    func testSelectEmptyJoin(){
        testInsert()
        expectation = expectation(description: "Empty select with join from database")
        let table = ImageCategories()!
        let joinQuery = try? table.all().join(table: Images()!, onColumn: "ict_id_image", andColumn: "img_id")
        XCTAssertNotNil(joinQuery)
        XCTAssertNotNil(joinQuery!.getQuery())
        joinQuery!.exec(){results in
            XCTAssertEqual(results.count, 0)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
    }
    
    func testDeleteWhere(){
        testInsert()
        expectation = expectation(description: "delete with condition from database")
        let table = Images()!
        let deleteQuery = try? table.delete().whereCond(conditions: ["img_id":1])
        XCTAssertNotNil(deleteQuery)
        XCTAssertNotNil(deleteQuery!.getQuery())
        deleteQuery!.execUpdate(){success in
            XCTAssertTrue(success)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("delete fail")
            }
        }
        expectation = expectation(description: "select from database")
        let selectWhere = try? table.all()
        XCTAssertNotNil(selectWhere)
        XCTAssertNotNil(selectWhere!.getQuery())
        selectWhere!.exec(){results in
            XCTAssertEqual(results.count, 0)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
    }
    
    func testLimit(){
        testInsert()
        testInsert()
        expectation = expectation(description: "select with limit from database")
        let table = Images()!
        let limitQuery = try? table.all().limit(quantity: 1)
        XCTAssertNotNil(limitQuery)
        XCTAssertNotNil(limitQuery!.getQuery())
        limitQuery!.exec(){results in
            XCTAssertEqual(results.count, 1)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select with limit fail")
            }
        }
        expectation = expectation(description: "select from database")
        let allQuery = try? table.all()
        XCTAssertNotNil(allQuery)
        XCTAssertNotNil(allQuery!.getQuery())
        allQuery!.exec(){results in
            XCTAssertEqual(results.count, 2)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("select fail")
            }
        }
        
    }
    
    func testDelete(){
        testInsert()
        testInsert()
        expectation = expectation(description: "delete from database")
        let table = Images()!
        let deleteQuery = try? table.delete()
        XCTAssertNotNil(deleteQuery)
        XCTAssertNotNil(deleteQuery!.getQuery())
        deleteQuery!.execUpdate(){success in
            XCTAssertTrue(success)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("delete fail")
            }
        }
        expectation = expectation(description: "select from database")
        let selectWhere = try? table.all()
        XCTAssertNotNil(selectWhere)
        XCTAssertNotNil(selectWhere!.getQuery())
        selectWhere!.exec(){results in
            XCTAssertEqual(results.count, 0)
            self.expectation.fulfill()
        }
        waitForExpectations(timeout: 2){ error in
            if error != nil{
                XCTFail("delete all fail")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
