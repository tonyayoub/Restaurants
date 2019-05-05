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
    
    var restaurants = [Restaurant]()
    func  parseRestaurants(){
        let parser = Parser()
        let event = parser.readJSONFromFile(fileName: "restaurants")
        event.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .default)).subscribe(onSuccess: { (result) in
            print("restaurants parsed successfulluy")
            print(parser.status)
            self.restaurants = result
        }) { (error) in
            print("error parsing file")
            print(parser.status)
            }.disposed(by: bag)
    }
    
    func changeIsFavourite(restaurant: inout Restaurant, makeIt isFavourite: Bool) {
        restaurant.favourite = isFavourite
    }
}
