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
        }) { (error) in
            print("error parsing file")
            print(parser.status)
            }.disposed(by: bag)
    }
    
    func loadFavouriteList() {
        
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

    
    
    
    func sortDisplayedResults(criteria: SortingCriteria) -> Observable<Bool> {
        let sortedResults = filteredResults.sorted { (rest1, rest2) -> Bool in
            return rest1.name < rest2.name
        }
        filteredResults = sortedResults
        
        let observable = Observable<Bool>.create { observer in
            print("sorting done")
            observer.onNext(true)
            return Disposables.create()
        }
        
        return observable
    }
    
    func addToFavourites(rest: Restaurant) {
//        if !favourites.list.contains(rest.name) {
//            favourites.list.append(rest.name)
//        }
//        else {
//            print("Warning: attempting to add an already-existing item to favourites")
//        }
        db.addItem(restName: rest.name)
    }
    
    func isFavourite(rest: Restaurant) -> Bool {
        //return favourites.list.contains(rest.name)
        return db.checkItemExists(restName: rest.name)
    }
    
    func removeFromFavourites(rest: Restaurant) {
//        if let index = favourites.list.firstIndex(of: rest.name) {
//            favourites.list.remove(at: index)
//        }
//        else {
//            print("Warning: attempting to remove a non-existing item from favourites")
//        }
        db.deleteItem(restName: rest.name)
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
        return db.toggleItemStatus(restName: rest.name)
    }
}
