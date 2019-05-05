//
//  RestaurantSortingHandler.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/5/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
protocol RestaurantListSorting {
    func handleSortingCriteriaChanged(selectedCriteria: SortingCriteria)
}
