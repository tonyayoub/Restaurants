//
//  sortingValues.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/1/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
struct SortingValues: Codable {
    var bestMatch: Float = 0.0
    var newest: Float = 0.0
    var ratingAverage: Float = 0.0
    var distance: Int = 0
    var popularity: Float = 0.0
    var averageProductPrice: Int = 0
    var deliveryCosts: Int = 0
    var minCost: Int = 0
}

enum SortingCriteria {
    case bestMatch
    case newest
    case ratingAverage
    case distance
    case popularity
    case averageProductPrice
    case deliveryCosts
    case minCost
}
