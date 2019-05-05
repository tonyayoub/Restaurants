//
//  TableContainerViewController.swift
//  Restaurants
//
//  Created by Tony Ayoub on 5/4/19.
//  Copyright © 2019 Tony Ayoub. All rights reserved.
//

import UIKit
import RxSwift

class ContainerViewController: UIViewController {

    // MARK: - Search
    let searchController = RestaurantsSearchController(searchResultsController: nil)
    var lastSearchedText = ""
    var sortCriteriaSubject = BehaviorSubject(value: SortingCriteria.bestMatch)
    let bag = DisposeBag()
    
    @IBOutlet weak var sortingCriteriaSegment: UISegmentedControl!
    
    @IBAction func sortingCriteriaSelected(_ sender: UISegmentedControl) {
        let cases = SortingCriteria.allCases
        let selectedIndex = sender.selectedSegmentIndex
        sortCriteriaSubject.onNext(cases[selectedIndex])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchController()
        setupSortingCriteria()
    }
    
    func setupSearchController() {
        self.navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    func setupSortingCriteria() {
        sortingCriteriaSegment.removeAllSegments()
        var index = 0
        for criteria in SortingCriteria.allCases {
            sortingCriteriaSegment.insertSegment(withTitle: criteria.rawValue, at: index, animated: false)
            index += 1
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? ListTableViewController {
            vc.searchController = searchController
            sortCriteriaSubject.subscribe(onNext: { (next) in
                vc.handleSortingCriteriaChanged(newCriteria: next)
            }).disposed(by: bag)
        }
    }
    
    @IBAction func ShowSortOptions(_ sender: Any) {
        print("sorting options")
    }

}

extension ContainerViewController: UISearchBarDelegate {
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


