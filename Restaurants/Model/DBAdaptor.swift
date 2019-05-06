//
//  DBAdaptor.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/6/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import Foundation
import RealmSwift

class DBAdaptor {
    var realm: Realm?
    init() {
        realm = try? Realm()
    }
    func loadSavedData() -> [RestaurantName] {
        var res = [RestaurantName]()
        
        guard let realm = try? Realm() else {
            print("Failed to create a Realm object")
            return res
        }

        for result in realm.objects(RestaurantName.self) {
            res.append(result)
        }
        return res
    }
    
    func addItem(restName: String) {
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
    
    func deleteItem(restName: String) {
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
    
    func checkItemExists(restName: String) -> Bool {
        guard let realm = self.realm else {
            return false
        }
        let checkedItem = realm.objects(RestaurantName.self).filter("text = %@", restName)
        return checkedItem.count > 0
    }
    
    func toggleItemStatus(restName: String) -> Bool {
        guard let realm = self.realm else {
            return false
        }
        let checkedItem = realm.objects(RestaurantName.self).filter("text = %@", restName)
        if checkedItem.count > 0 {
            deleteItem(restName: restName)
            return false
        }
        else {
            addItem(restName: restName)
            return true
        }
    }
}
