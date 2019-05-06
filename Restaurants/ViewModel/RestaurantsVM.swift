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
    var db = DBAdaptor()
    //all restaurants parsed from file
    private var restaurants = [Restaurant]()
    //filtered results as per the search text
    private var filteredResults = [Restaurant]()
    //displayed results after sorting
    var displayedResults: [Restaurant] {
        return filteredResults.sorted(by: Restaurant.favCompare,
                                      Restaurant.statusCompare,
                                      Restaurant.criteriaCompare)
    }
    //Observable raises a new event when display options (favourite list, search or sorting criteria) changes
    var displayOptionsChanged: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    var restaurantsListReady: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    var searchString = ""
    var sortCriteria: SortingCriteria = .bestMatch

    func  parseRestaurants() {
        let parser = Parser()
        let event = parser.readJSONFromFile(fileName: "restaurants")
        event.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)).subscribe(onSuccess: { [unowned self] (result) in
            self.publishListReady()
            self.restaurants = result
            self.filteredResults = result
        })
            .disposed(by: bag)
    }
    
    func loadFavouriteList() {
        let event = db.loadFavouriteList()
        event.subscribe(onSuccess: { [unowned self] (result) in
            DisplayOptions.shared.favouriteList = result
            self.publishNewDisplayOptions()
        }) 
            .disposed(by: bag)
    }
    
    func publishListReady()  {
        self.restaurantsListReady.onNext(true)
    }
    func publishNewDisplayOptions() {
        self.displayOptionsChanged.onNext(true)
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
    
    func addToFavourites(rest: Restaurant) {
        db.addToFavourites(restName: rest.name)
        loadFavouriteList()
    }
    
    func isFavourite(rest: Restaurant) -> Bool {
        return db.checkIfFavourite(restName: rest.name)
    }
    
    func removeFromFavourites(rest: Restaurant) {
        db.removeFromFavourites(restName: rest.name)
        loadFavouriteList()
    }
    
    // The returning value represents the final state of the item
    func toggleFavouriteValue(rest: Restaurant) -> Bool {
        let res = db.toggleBeingFavourite(restName: rest.name)
        loadFavouriteList()
        return res
    }
}
