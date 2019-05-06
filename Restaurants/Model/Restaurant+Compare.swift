//
//  Restaurant+Compare.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/6/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
extension Restaurant {
    static func favCompare(r1: Restaurant, r2: Restaurant) -> ComparisonResult {
        let fav = DisplayOptions.shared.favouriteList
        if fav.contains(r1.name) && !fav.contains(r2.name) {
            return ComparisonResult.orderedAscending
        }
        else if fav.contains(r2.name) && !fav.contains(r1.name) {
            return ComparisonResult.orderedDescending
        }
        else {
            return ComparisonResult.orderedSame
        }
    }
    
    static func statusCompare(r1: Restaurant, r2: Restaurant) -> ComparisonResult {
        let statusValues = ["open", "order ahead", "closed"]
        
        guard let rest1StatusIndex = statusValues.firstIndex(of: r1.status),
            let rest2StatusIndex = statusValues.firstIndex(of: r2.status) else {
            return ComparisonResult.orderedSame
        }
        
        if rest1StatusIndex < rest2StatusIndex {
            return ComparisonResult.orderedAscending
        }
        else if rest2StatusIndex < rest1StatusIndex {
            return ComparisonResult.orderedDescending
        }
        else {
            return ComparisonResult.orderedSame
        }

        
        
    }
    
    static func criteriaCompare(r1: Restaurant, r2: Restaurant) -> ComparisonResult {
        var rest1Value: Float = 0.0
        var rest2Value: Float = 0.0
        let criteria = SortingCriteria.bestMatch
        switch criteria {
        case .averageProductPrice:
            rest1Value = Float(r1.sortingValues.averageProductPrice)
            rest2Value = Float(r2.sortingValues.averageProductPrice)
        case .bestMatch:
            rest1Value = Float(r1.sortingValues.bestMatch)
            rest2Value = Float(r2.sortingValues.bestMatch)
        case .deliveryCosts:
            rest1Value = Float(r1.sortingValues.deliveryCosts)
            rest2Value = Float(r2.sortingValues.deliveryCosts)
        case .distance:
            rest1Value = Float(r1.sortingValues.distance)
            rest2Value = Float(r2.sortingValues.distance)
        case .minCost:
            rest1Value = Float(r1.sortingValues.minCost)
            rest2Value = Float(r2.sortingValues.minCost)
        case .newest:
            rest1Value = Float(r1.sortingValues.newest)
            rest2Value = Float(r2.sortingValues.newest)
        case .popularity:
            rest1Value = Float(r1.sortingValues.popularity)
            rest2Value = Float(r2.sortingValues.popularity)
        case .ratingAverage:
            rest1Value = Float(r1.sortingValues.ratingAverage)
            rest2Value = Float(r2.sortingValues.ratingAverage)

        }
        if rest1Value > rest2Value { //assuming the bigger number is better for all criteria.
            return ComparisonResult.orderedAscending
        }
        else if rest2Value < rest1Value {
            return ComparisonResult.orderedDescending
        }
        else {
            return ComparisonResult.orderedSame
        }
    }
}
