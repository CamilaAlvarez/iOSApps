//
//  clothingClassifierTests.swift
//  clothingClassifierTests
//
//  Created by Camila Alvarez on 16-08-16.
//  Copyright © 2016 Camila Alvarez. All rights reserved.
//

import XCTest
@testable import clothingClassifier


class clothingClassifierTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCannotInstantiateAbstractClass() {
        let abstractQuery = QuerySet()
        XCTAssertNil(abstractQuery, "QuerySet initialization must fail")
    }
    
    func testTableName(){
        XCTAssertEqual(Categories()?.tableName, "Categories")
        XCTAssertEqual(Images()?.tableName, "Images")
        XCTAssertEqual(ImageCategories()?.tableName, "ImageCategories")
        XCTAssertEqual(Labels()?.tableName, "Labels")
    }
    
    func testGetTableCategories(){
        let table = Categories()!
        let getQuery = try? table.get(columns: ["cat_id", "cat_code"])
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        XCTAssertEqual(getQuery!.getQuery()!, "SELECT cat_id, cat_code FROM Categories")
    }
    
    func testGetAllTableCategories(){
        let table = Categories()!
        let getQuery = try? table.all()
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        XCTAssertEqual(getQuery!.getQuery()!, "SELECT * FROM Categories")
    }
    
    func testGetWhereTableCategories(){
        let table = Categories()!
        let getQuery = try? table.get(columns: ["cat_id", "cat_code"]).whereCond(conditions: ["cat_code": 2])
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        XCTAssertEqual(getQuery!.getQuery()!, "SELECT cat_id, cat_code FROM Categories WHERE cat_code=2")
    }
    
    func testGetAllWhereTableCategories(){
        let table = Categories()!
        let getQuery = try? table.all().whereCond(conditions: ["cat_code": 2])
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        XCTAssertEqual(getQuery!.getQuery()!, "SELECT * FROM Categories WHERE cat_code=2")
    }
    
    func testInvalidWhere1(){
        let table = Categories()!
        XCTAssertThrowsError(try table.whereCond(conditions: ["cat_code": 2]))
    }
    
    func testInvalidWhere2(){
        let table = Categories()!
        XCTAssertThrowsError(try table.insert(values: ["cat_code":"category 1"]).whereCond(conditions: ["cat_code": 2]))
    }
    
    func testCorrectJoinSelectAll(){
        let table = Categories()!
        let joinQuery = try? table.all().join(table: ImageCategories()!, onColumn: "ict_id_category", andColumn: "cat_id")
        XCTAssertNotNil(joinQuery)
        XCTAssertNotNil(joinQuery!.getQuery())
        XCTAssertEqual(joinQuery!.getQuery()!, "SELECT * FROM Categories JOIN ImageCategories ON ict_id_category=cat_id")
    }
    
    func testInvalidJoin1(){
        let table = Categories()!
        XCTAssertThrowsError(try table.join(table: ImageCategories()!, onColumn: "ict_id_category", andColumn: "cat_id"))
    }
    
    func testInvalidJoin2(){
        let table = Categories()!
        let getQuery = try? table.get(columns: ["cat_id", "cat_code"]).whereCond(conditions: ["cat_code": 2])
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        XCTAssertEqual(getQuery!.getQuery()!, "SELECT cat_id, cat_code FROM Categories WHERE cat_code=2")
        XCTAssertThrowsError(try getQuery!.join(table: ImageCategories()!, onColumn: "ict_id_category", andColumn: "cat_id"))
    }
    
    func testInvalidLimit(){
        let table = Categories()!
        let deleteQuery = try? table.delete().whereCond(conditions: ["cat_code": 2])
        XCTAssertNotNil(deleteQuery)
        XCTAssertNotNil(deleteQuery!.getQuery())
        XCTAssertEqual(deleteQuery!.getQuery()!, "DELETE FROM Categories WHERE cat_code=2")
        XCTAssertThrowsError(try deleteQuery!.limit(quantity: 1))
    }
    
    func testLimit(){
        let table = Categories()!
        let getQuery = try? table.get(columns: ["cat_id", "cat_code"]).whereCond(conditions: ["cat_code": 2])
        XCTAssertNotNil(getQuery)
        XCTAssertNotNil(getQuery!.getQuery())
        XCTAssertEqual(getQuery!.getQuery()!, "SELECT cat_id, cat_code FROM Categories WHERE cat_code=2")
        let limitQuery = try? getQuery!.limit(quantity: 1)
        XCTAssertNotNil(limitQuery)
        XCTAssertNotNil(limitQuery!.getQuery())
        XCTAssertEqual(limitQuery!.getQuery()!, "SELECT cat_id, cat_code FROM Categories WHERE cat_code=2 LIMIT 1")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
