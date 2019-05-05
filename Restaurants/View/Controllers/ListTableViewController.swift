//
//  MasterViewController.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/3/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {

    let vm = RestaurantsVM()
    var searchResults = [Restaurant]()
    var detailViewController: RestaurantDetailsViewController? = nil
    var searchController: RestaurantsSearchController!
    var searchActive: Bool {
        guard let searchText = searchController.searchBar.text else {
            return false
        }
        return searchText.count > 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.vm.parseRestaurants()
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? RestaurantDetailsViewController
        }
        self.navigationController
        setup()
        searchController.searchResultsUpdater = self
        searchController.delegate = self
    }
    @objc
    func insertNewObject(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .default)
        let saveAction = UIAlertAction(title: "Save", style: .default)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc
    func makeFavourite(_ sender: UIButton) {
        print("\(sender.tag)")
    }
    
    
    func setup() {
        setupTableView()
    }
    
    func setupTableView() {
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: "Restaurant")
    }




    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//              //  let object = objects[indexPath.row] as! NSDate
//                let controller = (segue.destination as! UINavigationController).topViewController as! RestaurantDetailsViewController
//              //  controller.detailItem = object
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
//                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? searchResults.count : vm.restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Restaurant", for: indexPath) as! RestaurantCell
        cell.makeFavourite.tag = indexPath.row
        print("cell tag is: \(cell.tag)")
        cell.makeFavourite.addTarget(self, action: #selector(makeFavourite(_:)), for: .touchUpInside)
        let restaurant = searchActive ? searchResults[indexPath.row] : vm.restaurants[indexPath.row]
  
        cell.textLabel!.text = restaurant.name
        return cell
    }
    

}



extension ListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
    func filterContent(for searchString: String) {
        if !searchActive {
            searchResults = vm.restaurants
        }
        else {
            searchResults = vm.restaurants.filter({ (restaurant) -> Bool in
                let match = restaurant.name.range(of: searchString, options: .caseInsensitive)
                return match != nil
            })
        }
    }
}

extension ListTableViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        print("dismissed")
    }
}



