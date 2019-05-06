//
//  DBAdaptor.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/6/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift

enum DBStatus {
    case OK
    case Error
}

class DBAdaptor {
    var realm: Realm?
    var status: DBStatus = .OK
    init() {
        realm = try? Realm()
    }
    
    func loadFavouriteList() -> Single<[String]> {
        return Single<[String]>.create { single in
            if let realm = try? Realm() {
                var res = [String]()
                for result in realm.objects(RestaurantName.self) {
                    res.append(result.text)
                }
                self.status = .OK
                single(.success(res))
            }
            else {
                print("Failed to create a Realm object")
                self.status = .Error
                single(.error(DBError.favouritesLoadingError))
            }
            return Disposables.create()
        }
    }

    
    
    func loadFavouriteList2() -> [String] {
        var res = [String]()
        
        guard let realm = try? Realm() else {
            print("Failed to create a Realm object")
            return res
        }

        for result in realm.objects(RestaurantName.self) {
            res.append(result.text)
        }
        return res
    }
    
    func addToFavourites(restName: String) {
        let restName = RestaurantName(name: restName)
        guard let realm = try? Realm() else {
            print("Failed to create a Realm object")
            return
        }
        do {
            try realm.write {
                realm.add(restName)
            }
        } catch {
            print("Failed to write an object in Realm")
        }
    }
    
    func removeFromFavourites(restName: String) {
        guard let realm = self.realm else {
            return
        }
        let toBeDeletedItem = realm.objects(RestaurantName.self).filter("text = %@", restName)
        do {
            try realm.write {
                realm.delete(toBeDeletedItem)
            }
        } catch {
            print("Failed to delete an object from Realm")
        }
    }
    
    func checkIfFavourite(restName: String) -> Bool {
        guard let realm = self.realm else {
            return false
        }
        let checkedItem = realm.objects(RestaurantName.self).filter("text = %@", restName)
        return checkedItem.count > 0
    }
    
    func toggleBeingFavourite(restName: String) -> Bool {
        guard let realm = self.realm else {
            return false
        }
        let checkedItem = realm.objects(RestaurantName.self).filter("text = %@", restName)
        if checkedItem.count > 0 {
            removeFromFavourites(restName: restName)
            return false
        }
        else {
            addToFavourites(restName: restName)
            return true
        }
    }
}
