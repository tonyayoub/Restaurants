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
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
    }
    
    func setupSearchController() {
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
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

