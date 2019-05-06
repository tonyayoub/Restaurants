//
//  DBTests.swift
//  RestaurantsTests
//
//  Created by Tony Ayoub on 5/6/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import XCTest
@testable import Restaurants

class DBTests: XCTestCase {
    var sut: RestaurantsVM!

    override func setUp() {
        super.setUp()
        sut = RestaurantsVM()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testAddToFavourites() {
        let restaurant = Restaurant()
        restaurant.name = "Test"
        sut.removeFromFavourites(rest: restaurant) //in case it exists
        sut.addToFavourites(rest: restaurant)
        let res = sut.isFavourite(rest: restaurant)
        XCTAssertTrue(res)
        
    }
    
    func testToggleFavStatus() {
        let restaurant = Restaurant()
        restaurant.name = "Test"
        sut.removeFromFavourites(rest: restaurant) //in case it exists
        let _ = sut.toggleFavouriteValue(rest: restaurant)
        let res1 = sut.isFavourite(rest: restaurant)
        XCTAssertTrue(res1)
        
        let _ = sut.toggleFavouriteValue(rest: restaurant)
        let res2 = sut.isFavourite(rest: restaurant)
        XCTAssertFalse(res2)
    }

}
