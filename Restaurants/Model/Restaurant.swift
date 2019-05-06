//
//  Restaurant.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/1/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import RealmSwift

class Restaurant: Codable {
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

class RestaurantName: Object {
    convenience init(name: String) {
        self.init()
        text = name
    }
    @objc dynamic var text = String()
}
