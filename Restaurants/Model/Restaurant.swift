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
    func getSortingValueFromCriteria(criteria: SortingCriteria) -> Float {
        switch criteria {
        case .averageProductPrice:
            return Float(sortingValues.averageProductPrice)
        case .bestMatch:
            return Float(sortingValues.bestMatch)
        case .deliveryCosts:
            return Float(sortingValues.deliveryCosts)
        case .distance:
            return Float(sortingValues.distance)
        case .minCost:
            return Float(sortingValues.minCost)
        case .newest:
            return Float(sortingValues.newest)
        case .popularity:
            return Float(sortingValues.popularity)
        case .ratingAverage:
            return Float(sortingValues.ratingAverage)
        }
    }
    enum CodingKeys: String, CodingKey {
        case name
        case status
        case sortingValues
    }
    
    
}

struct RestaurantList: Codable {
    var restaurants: [Restaurant]
}

//to be used with Realm
class RestaurantName: Object {
    convenience init(name: String) {
        self.init()
        text = name
    }
    @objc dynamic var text = String()
}
