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
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    lazy var reachibility = try? Reachability()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSearchBar()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        setupReachibilityNotifier()
    }
    
    func setupReachibilityNotifier() {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged), name: .reachabilityChanged, object: reachibility)
        
        do {
            try reachibility?.startNotifier()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        guard let reachibility = note.object as? Reachability else {
            return
        }
        
        switch reachibility.connection {
            
        case .wifi, .cellular:
            updateSearchResults(for: searchController)
            
        case .unavailable:
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection and try again", preferredStyle: .alert)
            alert.addAction(okAction)
            
            present(alert, animated: true)
            
        default: return
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.tintColor = .label
        } else {
            self.navigationController?.navigationBar.tintColor = .white
        }
        
        searchController.delegate = self
        searchController.searchResultsUpdater = self
    }
    
    //    override func viewDidAppear(_ animated: Bool) {
    //        super.viewDidAppear(animated)
    //
    ////        DispatchQueue.main.async {
    //////            guard let self = self else { return }
    ////            self.searchController.searchBar.searchTextField.becomeFirstResponder()
    ////        }
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
        searchController.searchBar.searchTextField.resignFirstResponder()
        searchController.delegate = nil
    }
    
    deinit {
        print("Deinitted ...")
    }
    
    func setupSearchBar() {
        
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false
        
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.placeholder = "Artist"
        searchController.searchBar.autocapitalizationType = .words
        searchController.searchBar.barTintColor = .red
        //        searchController.searchBar.setValue("Cancel 2", forKey: "_cancelButtonText")
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .done
        
        navigationItem.searchController = searchController
    }
    
    
    
    // MARK: - Navigation
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
        
        cell.setValues(with: artistSearchResult[indexPath.row])
        
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

extension SearchViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchController.searchBar.searchTextField.resignFirstResponder()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text?.count ?? 0 > 0 {
            if let text = searchController.searchBar.text  {
                API.downloadArtists(withKeyword: text) { [weak self] artists in
                    guard let self = self else { return }
                    self.artistSearchResult = artists
                    self.artistsTableView.reloadData()
                }
            }
        } else {
            artistSearchResult = []
            artistsTableView.reloadData()
        }
    }
    
    
    
}
