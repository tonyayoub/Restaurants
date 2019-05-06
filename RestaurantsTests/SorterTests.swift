//
//  SorterTests.swift
//  RestaurantsTests
//
//  Created by Tony Ayoub on 5/6/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import XCTest
import RxBlocking
@testable import Restaurants


class SorterTests: XCTestCase {
    var parser: Parser!

    override func setUp() {
        super.setUp()
        parser = Parser()
    }

    override func tearDown() {
        parser = nil
        super.tearDown()
    }

    func testSortingStatus() {
        let event = parser.readJSONFromFile(fileName: "sample1")
        DisplayOptions.shared.favouriteList = []
        if let result = try! event.toBlocking().first() {
        let sorted = result.sorted(by: Restaurant.favCompare,
                                                   Restaurant.statusCompare,
                                                   Restaurant.criteriaCompare)
            XCTAssertEqual(sorted.first?.status, "open")

        }
    }
    
    func testSortingFavourite() {
        let event = parser.readJSONFromFile(fileName: "sample1")
        DisplayOptions.shared.favouriteList = ["Royal Thai"]
        if let result = try! event.toBlocking().first() {
            let sorted = result.sorted(by: Restaurant.favCompare,
                                       Restaurant.statusCompare,
                                       Restaurant.criteriaCompare)
            XCTAssertEqual(sorted[0].name, "Royal Thai")
            
        }
    }
    
    func testSortingAverageProductPrice() {
        let event = parser.readJSONFromFile(fileName: "sample2")
        DisplayOptions.shared.selectedCriteria = .averageProductPrice
        DisplayOptions.shared.favouriteList = []
        if let result = try! event.toBlocking().first() {
            let sorted = result.sorted(by: Restaurant.favCompare,
                                       Restaurant.statusCompare,
                                       Restaurant.criteriaCompare)
            let highestProductPriceCriteria = sorted.first?.sortingValues.averageProductPrice
            var firstItemHasTheHighestValue = true
            for rest in sorted {
                if rest.sortingValues.averageProductPrice > highestProductPriceCriteria! {
                    firstItemHasTheHighestValue = false
                    break
                }
            }
            XCTAssertEqual(firstItemHasTheHighestValue, true)
            
        }
    }
    
    func testSortingCriteria() {
        let event = parser.readJSONFromFile(fileName: "sample2")
        for criteria in SortingCriteria.allCases {
            DisplayOptions.shared.selectedCriteria = criteria
            DisplayOptions.shared.favouriteList = []
            
            if let result = try! event.toBlocking().first() {
                //omitting the sorting based on status
                let sorted = result.sorted(by: Restaurant.favCompare,
                                           Restaurant.criteriaCompare)
                let highestCriteria = sorted.first?.getSortingValueFromCriteria(criteria: criteria)
                var firstItemHasTheHighestValue = true
                for rest in sorted {
                    let comparedValue = rest.getSortingValueFromCriteria(criteria: criteria)
                    if comparedValue > highestCriteria! {
                        firstItemHasTheHighestValue = false
                        break
                    }
                }
                print(firstItemHasTheHighestValue)
                XCTAssertTrue(firstItemHasTheHighestValue)
                
            }
        }

    }


}
