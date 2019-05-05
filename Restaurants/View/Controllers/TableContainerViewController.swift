//
//  TableContainerViewController.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/4/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit

class TableContainerViewController: UIViewController {

    // MARK: - Search
    let searchController = RestaurantsSearchController(searchResultsController: nil)
    var lastSearchedText = ""
  
    @IBOutlet weak var sortingCriteriaSegment: UISegmentedControl!
    
    @IBAction func sortingCriteriaSelected(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    func setupSearchController() {
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ListTableViewController {
            vc.searchController = searchController
        }
    }
    
    @IBAction func ShowSortOptions(_ sender: Any) {
        print("sorting options")
    }

}

extension TableContainerViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("end editing")
        searchController.searchBar.text = lastSearchedText
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("started editing")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("canceled")
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        lastSearchedText = searchText
    }
    
}


