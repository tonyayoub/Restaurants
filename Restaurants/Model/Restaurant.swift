//
//  Restaurant.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/1/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
struct Restaurant: Codable {
    var name: String = ""
    var status: String = ""
    var sortingValues: SortingValues = SortingValues()
    var favourite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case name
        case status
        case sortingValues
    }
}

struct RestaurantList: Codable {
    var restaurants: [Restaurant]
}
