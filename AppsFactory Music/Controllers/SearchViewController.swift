//
//  SearchViewController.swift
//  AppsFactory Music
//
//  Created by Arsalan Iravani on 26/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var artistsTableView: UITableView!
    
    private var artistSearchResult: [Artist] = []
    
    private var selectedArtistIndex: Int?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupSearchBar()
    }
    
    func setupSearchBar() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.obscuresBackgroundDuringPresentation = false
        //        searchController.dimsBackgroundDuringPresentation = true
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.delegate = self
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.autocapitalizationType = .words
        //        searchController.searchBar.tintColor = .green
        searchController.searchBar.barTintColor = .red
        //        searchController.searchBar.setValue("İmtina", forKey: "_cancelButtonText")
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        
        //        searchController.searchBar.scopeButtonTitles = ["All", "Some", "None"]
        //        let textFieldInsideSearchBar = searchController.searchBar.value(forKey: "_searchField") as? UITextField
        //        textFieldInsideSearchBar?.backgroundColor = UIColor(red: 0.01, green: 0.01, blue: 0.01, alpha: 0.09)
        
        navigationItem.searchController = searchController
        
        //        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "menuIcon"), style: .plain, target: self, action: #selector(SSASideMenu.presentLeftMenuViewController))
        
    }
    
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ArtistOverviewViewController {
            if let index = selectedArtistIndex {
                destination.artist = artistSearchResult[index]
            }
        }
    }
    
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artistSearchResult.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "artistSearchCell", for: indexPath) as! SearchArtistTableViewCell
        
        cell.setValues(with: artistSearchResult[indexPath.row], imageSize: .large)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArtistIndex = indexPath.row
        performSegue(withIdentifier: "artistDetailSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension SearchViewController: UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        //        view.bringSubviewToFront(suggestionsTableView)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        //        view.bringSubviewToFront(collectionView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.count ?? 0 > 0 {
            if let text = searchController.searchBar.text  {
                API.downloadArtists(withKeyword: text) { [unowned self] artists in
                    self.artistSearchResult = artists
                    self.artistsTableView.reloadData()
                }
            }
        }
    }
    
    
    
}
