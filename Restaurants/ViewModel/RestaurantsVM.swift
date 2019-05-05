//
//  RestaurantsVM.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/1/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import RxSwift


class RestaurantsVM {
    var bag = DisposeBag()
    
    private var restaurants = [Restaurant]()
    private var filteredResults = [Restaurant]()
    var searchString = ""
    var sortCriteria: SortingCriteria = .bestMatch
    var displayedResults: [Restaurant] {
        return filteredResults
    }
    func  parseRestaurants(){
        let parser = Parser()
        let event = parser.readJSONFromFile(fileName: "restaurants")
        event.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)).subscribe(onSuccess: { (result) in
            print("restaurants parsed successfulluy")
            print(parser.status)
            self.restaurants = result
            self.filteredResults = result
            self.sortDisplayedResults(criteria: .averageProductPrice)
        }) { (error) in
            print("error parsing file")
            print(parser.status)
            }.disposed(by: bag)
    }
    
    func changeIsFavourite(restaurant: inout Restaurant, makeIt isFavourite: Bool) {
        restaurant.favourite = isFavourite
    }
    
    
    func resetDisplayedResults() {
        filteredResults = restaurants
    }
    func updateDisplayedResultsWithSearchString(search: String) {
        filteredResults = restaurants.filter({ (restaurant) -> Bool in
            let match = restaurant.name.range(of: search, options: .caseInsensitive)
            return match != nil
        })
    }
    
    func sortDisplayedResults(criteria: SortingCriteria) {
        let sortedResults = filteredResults.sorted { (rest1, rest2) -> Bool in
            return rest1.name < rest2.name
        }
        filteredResults = sortedResults
    }
}
