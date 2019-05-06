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
        let criteria = DisplayOptions.shared.selectedCriteria
        let rest1ComparisonValue = r1.getSortingValueFromCriteria(criteria: criteria)
        let rest2ComparisonValue = r2.getSortingValueFromCriteria(criteria: criteria)
        if rest1ComparisonValue > rest2ComparisonValue { //assuming the bigger number is better for all criteria.
            return ComparisonResult.orderedAscending
        }
        else if rest2ComparisonValue < rest1ComparisonValue {
            return ComparisonResult.orderedDescending
        }
        else {
            return ComparisonResult.orderedSame
        }
    }
}
