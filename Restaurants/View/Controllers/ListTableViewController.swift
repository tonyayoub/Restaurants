//
//  MasterViewController.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/3/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit
import RxSwift

class ListTableViewController: UITableViewController {

    let vm = RestaurantsVM()
    var sortCriteriaSubject = BehaviorSubject(value: SortingCriteria.bestMatch)
    let bag = DisposeBag()
    
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
        setup()
        searchController.searchResultsUpdater = self
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
        let restName = vm.displayedResults[sender.tag].name
        if vm.favourites.contains(restName) {
            if let index = vm.favourites.firstIndex(of: restName) {
                vm.favourites.remove(at: index)
            }
        }
        else {
            vm.favourites.append(restName)
        }
        tableView.reloadData()
    }
    
    
    func setup() {
        setupTableView()

        
    }
    
    
    func setupTableView() {
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: "Restaurant")
        tableView.reloadData()
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
        return vm.displayedResults.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Restaurant", for: indexPath) as! RestaurantCell
        cell.makeFavourite.tag = indexPath.row
        cell.makeFavourite.addTarget(self, action: #selector(makeFavourite(_:)), for: .touchUpInside)
        
        let restaurant = vm.displayedResults[indexPath.row]
        cell.textLabel!.text = restaurant.name
        cell.makeFavourite.isSelected = vm.favourites.contains(restaurant.name)
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
            vm.resetDisplayedResults()
        }
        else {
            vm.updateDisplayedResultsWithSearchString(search: searchString)
        }
    }
}

extension ListTableViewController: RestaurantListSorting {
    func handleSortingCriteriaChanged(selectedCriteria: SortingCriteria) {
        vm.sortDisplayedResults(criteria: selectedCriteria)
            .subscribe(onNext: { (isSorted) in
                self.tableView.reloadData()
            }).disposed(by: bag)
    }
    
    
}





