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
        self.vm.loadFavouriteList()
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
        let rest = vm.displayedResults[sender.tag]
        UIView.animate(withDuration: 0.1, animations: {
            sender.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }) { (_) in
            sender.transform = CGAffineTransform.identity
            if self.vm.isFavourite(rest: rest) {
                self.vm.removeFromFavourites(rest: rest)
            }
            else {
                self.vm.addToFavourites(rest: rest)
            }
        }

    }
    
    func setup() {
        setupTableView()
        
        vm.restaurantsListReady.subscribe(onNext: { (listReady) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
        .disposed(by: bag)
        
        vm.displayOptionsChanged.subscribe(onNext: { (favListLoaded) in
            if favListLoaded {
                DispatchQueue.main.async {
                    //[_tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                    self.tableView.reloadSections(IndexSet(integer: 0), with: UITableView.RowAnimation.none)
                    //self.tableView.reloadData()
                }
            }
        })
        .disposed(by: bag)
        
        
    }
    
    func setupTableView() {
        tableView.register(RestaurantCell.self, forCellReuseIdentifier: "Restaurant")
        tableView.reloadData()
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
        let disp = vm.displayedResults
        let restaurant = disp[indexPath.row]
        cell.textLabel!.text = restaurant.name
        cell.openStateValue.text = restaurant.status
        cell.selectedSortLabel.text = DisplayOptions.shared.selectedCriteria.rawValue + ":"

        cell.selectedSortValue.text = String(restaurant.getSortingValueFromCriteria(criteria: DisplayOptions.shared.selectedCriteria))
        cell.makeFavourite.isSelected = vm.isFavourite(rest: restaurant)
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
        DisplayOptions.shared.selectedCriteria = selectedCriteria
        vm.publishNewDisplayOptions()
    }
}





