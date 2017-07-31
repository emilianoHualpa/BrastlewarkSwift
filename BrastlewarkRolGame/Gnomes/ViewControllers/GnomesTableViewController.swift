//
//  GnomesTableTableViewController.swift
//  BrastlewarkRolGame
//
//  Created by Milo on 7/29/17.
//  Copyright © 2017 ar.com.milohualpa. All rights reserved.
//

import UIKit

class GnomesTableViewController: BaseGnomesTableViewController, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    
    //MARK: - Properties
    
    internal var gnomes: [Gnome] = []
    
    // Search controller to help us with filtering.
    var searchController: UISearchController!
    
    // Secondary search results table view.
    var gnomeResultTableController: GnomesResutlTableController!
    
    //MARK: - iOS Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gnomeResultTableController = GnomesResutlTableController()
        
        // We want ourselves to be the delegate for this filtered table so didSelectRowAtIndexPath(_:) is called for both tables.
        gnomeResultTableController.tableView.delegate = self
        
        searchController = UISearchController(searchResultsController: gnomeResultTableController)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        searchController.delegate = self
        searchController.dimsBackgroundDuringPresentation = false // default is YES
        searchController.searchBar.delegate = self    // so we can monitor text changes + others
        
        /*
         Search is now just presenting a view controller. As such, normal view controller
         presentation semantics apply. Namely that presentation will walk up the view controller
         hierarchy until it finds the root view controller or one that defines a presentation context.
         */
        definesPresentationContext = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.animateTable()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gnomes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath) as GnomeTableViewCell
        let gnome = gnomes[indexPath.row];
        configureCell(cell, gnome: gnome)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedGnome: Gnome
        
        // Check to see which table view cell was selected.
        if tableView === self.tableView {
            selectedGnome = gnomes[indexPath.row]
        }
        else {
            selectedGnome = gnomeResultTableController.filteredGnomes[indexPath.row]
        }
        
        // Set up the detail view controller to show.
        let gnomeDetailViewController = GnomesDetailViewController.detailViewControllerForGnome(selectedGnome)
        
        navigationController?.pushViewController(gnomeDetailViewController, animated: true)
        
    }

    func updateNoResultsView(){
    }
 
    
    // MARK: - UISearchController delegates
    
    func updateSearchResults(for searchController: UISearchController) {
        // Update the filtered array based on the search text.
        let searchResults = gnomes
        
        // Strip out all the leading and trailing spaces.
        let whitespaceCharacterSet = CharacterSet.whitespaces
        let strippedString = searchController.searchBar.text!.trimmingCharacters(in: whitespaceCharacterSet)
        let searchItems = strippedString.components(separatedBy: " ") as [String]
        
        // Build all the "AND" expressions for each value in the searchString.
        let andMatchPredicates: [NSPredicate] = searchItems.map { searchString in

            var searchItemsPredicate = [NSPredicate]()
            
            // Below we use NSExpression represent expressions in our predicates.
            // NSPredicate is made up of smaller, atomic parts: two NSExpressions (a left-hand value and a right-hand value).
            
            // Name field matching.
            let titleExpression = NSExpression(forKeyPath: "name")
            let searchStringExpression = NSExpression(forConstantValue: searchString)
            
            let titleSearchComparisonPredicate = NSComparisonPredicate(leftExpression: titleExpression, rightExpression: searchStringExpression, modifier: .direct, type: .contains, options: .caseInsensitive)
            
            searchItemsPredicate.append(titleSearchComparisonPredicate)
            
            // Add this OR predicate to our master AND predicate.
            let orMatchPredicate = NSCompoundPredicate(orPredicateWithSubpredicates:searchItemsPredicate)
            
            return orMatchPredicate
        }
        
        // Match up the fields of the Product object.
        let finalCompoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: andMatchPredicates)
        
        let filteredResults = searchResults.filter { finalCompoundPredicate.evaluate(with: $0) }
        
        // Hand over the filtered results to our search results table.
        let gnomeResultController = searchController.searchResultsController as! GnomesResutlTableController
        gnomeResultController.filteredGnomes = filteredResults
        gnomeResultController.tableView.reloadData()
    }

}
