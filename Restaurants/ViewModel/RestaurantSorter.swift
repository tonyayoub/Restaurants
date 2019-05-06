//
//  RestaurantSorter.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/6/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
class RestaurantSorter {
    
    class func compare(_ rest1: Restaurant, _ rest2: Restaurant, _ favList: [String]) -> Bool {
        let rest1IsFav = favList.contains(rest1.name)
        let rest2IsFav = favList.contains(rest2.name)
        let favSame = rest1IsFav == rest2IsFav
        
        if !favSame { //one is fav. and one is not
            return rest1IsFav
        }
        else { //they are both fav. or not
            return compareStatus(rest1, rest2)
        }

    }
    
 
    
    class func compareStatus(_ rest1: Restaurant, _ rest2: Restaurant) -> Bool{
        let statusValues = ["open", "order ahead", "closed"]
        if let rest1StatusIndex = statusValues.firstIndex(of: rest1.status),
            let rest2StatusIndex = statusValues.firstIndex(of: rest2.status) {
            return rest1StatusIndex < rest2StatusIndex
        }
        else {
            return false
        }
    }
}


extension Sequence {
    typealias ClosureCompare = (Iterator.Element, Iterator.Element) -> ComparisonResult
    
    func sorted(by comparisons: ClosureCompare...) -> [Iterator.Element] {
        return self.sorted { e1, e2 in
            for comparison in comparisons {
                let comparisonResult = comparison(e1, e2)
                guard comparisonResult == .orderedSame
                    else { return comparisonResult == .orderedAscending }
            }
            return false
        }
    }
}
