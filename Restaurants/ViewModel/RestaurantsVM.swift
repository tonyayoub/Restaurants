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
    private var restaurants = [Restaurant]()
    private var filteredResults = [Restaurant]()
    var displayOptionsChanged: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    var searchString = ""
    var sortCriteria: SortingCriteria = .bestMatch
    var displayedResults2: [Restaurant] {
        let res = filteredResults.sorted(by: { (rest1, rest2) -> Bool in
            RestaurantSorter.compare(rest1, rest2, DisplayOptions.shared.favouriteList)
        })
        return res
    }
    var displayedResults: [Restaurant] {
        return filteredResults.sorted(by: Restaurant.favCompare,
                                         Restaurant.statusCompare,
                                         Restaurant.criteriaCompare)
    }
    
    
    func  parseRestaurants() {
        let parser = Parser()
        let event = parser.readJSONFromFile(fileName: "restaurants")
        event.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)).subscribe(onSuccess: { (result) in
            print("restaurants parsed successfulluy")
            print(parser.status)
            self.restaurants = result
            self.filteredResults = result
        }) { (error) in
            print("error parsing file")
            print(parser.status)
            }
            .disposed(by: bag)
    }
    
    
    
    
    func loadFavouriteList() {
        
        let event = db.loadFavouriteList()
        event.subscribe(onSuccess: { (result) in
            DisplayOptions.shared.favouriteList = result
            self.publishNewDisplayOptions()
        }) { (error) in
            print(error)
            }
            .disposed(by: bag)
        
        
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
        //        if !favourites.list.contains(rest.name) {
        //            favourites.list.append(rest.name)
        //        }
        //        else {
        //            print("Warning: attempting to add an already-existing item to favourites")
        //        }
        db.addToFavourites(restName: rest.name)
        loadFavouriteList()
    }
    
    func isFavourite(rest: Restaurant) -> Bool {
        //return favourites.list.contains(rest.name)
        return db.checkIfFavourite(restName: rest.name)
    }
    
    func removeFromFavourites(rest: Restaurant) {
        //        if let index = favourites.list.firstIndex(of: rest.name) {
        //            favourites.list.remove(at: index)
        //        }
        //        else {
        //            print("Warning: attempting to remove a non-existing item from favourites")
        //        }
        db.removeFromFavourites(restName: rest.name)
        loadFavouriteList()
    }
    
    // The returning value represents the final state of the item
    func toggleFavouriteValue(rest: Restaurant) -> Bool {
        //        if isFavourite(rest: rest) {
        //            removeFromFavourites(rest: rest)
        //            return false
        //        }
        //        else {
        //            addToFavourites(rest: rest)
        //            return true
        //        }
        let res = db.toggleBeingFavourite(restName: rest.name)
        loadFavouriteList()
        return res
    }
}
