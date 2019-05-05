//
//  RestaurantsTests.swift
//  RestaurantsTests
//
//  Created by Tony Ayoub on 5/3/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import XCTest
import RxBlocking

@testable import Restaurants

class ParserTests: XCTestCase {
    var sut: Parser!
    override func setUp() {
        super.setUp()
        sut = Parser()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testParserInititalState() {
        XCTAssertEqual(sut.status, ParsingStatus.NotStarted)
    }
    
    func testValidFileParsing() {
        let event = sut.readJSONFromFile(fileName: "all")
        let _ = try! event.toBlocking().first()
        XCTAssertEqual(sut.status, ParsingStatus.Success)
    }
    
    func testFileNotFound() {
        print(sut.status)
        let event = sut.readJSONFromFile(fileName: "notFound")
        let _ = try? event.toBlocking().first()
        XCTAssertEqual(sut.status, ParsingStatus.FileNotFound)
    }
    
    func testInvalidFile() {
        print(sut.status)
        let event = sut.readJSONFromFile(fileName: "notValid")
        let _ = try? event.toBlocking().first()
        XCTAssertEqual(sut.status, ParsingStatus.InvalidFile)
    }
}
