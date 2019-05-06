//
//  DisplayOptions.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/6/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
class DisplayOptions {
    //Singleton
    static let shared = DisplayOptions()
    private init() {
        
    }
    var favouriteList = [String]()
    var selectedCriteria = SortingCriteria.bestMatch
}
