//
//  PickerController.swift
//  Valute
//
//  Created by Drago on 5/3/18.
//  Copyright © 2018 nsiddevelopment. All rights reserved.
//

import UIKit

protocol PickerControllerDelegate: class {
    func pickerController(_ controller: PickerController, didSelectCurrency cc: String)
}

final class PickerController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCurrencies = [String]()
    
    var currencies: [String] = [] {
        didSet {
            //    TBD: nesto
        }
    }
    
    weak var delegate: PickerControllerDelegate?
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
}

private extension PickerController {
    
    func configureUI() {
        tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "globalbg"))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 54
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Currency"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension PickerController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredCurrencies.count
        }
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PickerCell.reuseIdentifier, for: indexPath) as! PickerCell
        if isFiltering() {
            cell.populate(with: filteredCurrencies[indexPath.row])
        } else {
            cell.populate(with: currencies[indexPath.row])
        }
        return cell
    }
}

extension PickerController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cc: String = ""
        if isFiltering() {
            cc = filteredCurrencies[indexPath.row]
        } else {
            cc = currencies[indexPath.row]
        }
        delegate?.pickerController(self, didSelectCurrency: cc)
    }
}

extension PickerController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
}

extension PickerController {
    // MARK: - Private instance methods
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredCurrencies = currencies.filter({( currency : String ) -> Bool in
            return currency.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
}








