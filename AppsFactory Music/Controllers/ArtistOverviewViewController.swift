//
//  AlbumOverviewViewController.swift
//  AppsFactory Music
//
//  Created by Arsalan Iravani on 26/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import UIKit
import UIImageColors
import JGProgressHUD
import RealmSwift

class ArtistOverviewViewController: UIViewController {
    
    var artist: Artist?
    private var albumResponse: AlbumResponse?
    private var colors: UIImageColors?
    
    private var locallyStoredAlbums: [Album] = []
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var albumsTableView: UITableView!
    
    @IBOutlet weak var albumsLabel: UILabel!
    
    private var selectedArtistIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetails()
        loadLocalAlbums()
        
        artistImageView.fadeView(style: .bottom, percentage: 0.5, bottomColor: .white)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.tintColor = colors?.detail
        loadLocalAlbums()
    }
    
    func loadLocalAlbums() {
        RealmManager.shared.loadAlbumsFromRealm { [weak self] albums in
            guard let self = self else { return }
            self.locallyStoredAlbums = albums
            self.albumsTableView.reloadData()
        }
    }
    
    func setupDetails() {
        if let imageURL = artist?.pictureXl {
            if let url = URL(string: imageURL) {
                artistImageView.af.setImage(withURL: url) { [weak self] image in
                    guard let self = self else { return }
                    self.artistImageView.image?.getColors(quality: .lowest, { colors in
                        self.colors = colors
                        self.navigationController?.navigationBar.tintColor = colors?.detail
                        
                        self.albumsTableView.reloadData()
                        self.albumsLabel.textColor = colors?.detail
                        
                        UIView.animate(withDuration: 0.5) {
                            self.view.backgroundColor = colors?.background ?? .red
                        }
                    })
                }
            }
        }
        
        if let artistID = artist?.id {
            API.downloadAlbums(withID: artistID) { [weak self] albumsData in
                guard let self = self else { return }
                self.albumResponse = albumsData

                // Sort albums by Release Date
                self.albumResponse?.data?.sort(by: { (a1, a2) -> Bool in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date1 = dateFormatter.date(from: a1.releaseDate ?? ""), let date2 = dateFormatter.date(from: a2.releaseDate ?? "") {
                        return date1 > date2
                    }
                    return false
                })
                self.albumsTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AlbumDetailsViewController {
            if let index = selectedArtistIndex {
                destination.album = albumResponse?.data?[index]
            }
        }
    }
    
}

extension ArtistOverviewViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumResponse?.data?.count ?? 0
    }
    
    //MARK:- Pagination
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        
        if let album = albumResponse?.data?[indexPath.row] {
            cell.setValues(with: album, index: indexPath.row, colors: colors)
            cell.iphoneImageView.isHidden = locallyStoredAlbums.filter({$0.id == album.id}).isEmpty
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArtistIndex = indexPath.row
        performSegue(withIdentifier: "albumDetailViewSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.max()?.row == (albumResponse?.data?.count ?? 0) - 1 {
            API.downloadAlbums(withURL: albumResponse?.next) { [weak self] albumResponse in
                guard let self = self else { return }
                self.albumResponse?.next = albumResponse.next
                self.albumResponse?.data?.append(contentsOf: albumResponse.data ?? [])
                
                // Sort albums by Release Date
                self.albumResponse?.data?.sort(by: { (a1, a2) -> Bool in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    if let date1 = dateFormatter.date(from: a1.releaseDate ?? ""), let date2 = dateFormatter.date(from: a2.releaseDate ?? "") {
                        return date1 > date2
                    }
                    return false
                })
                
                self.albumsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! AlbumTableViewCell
        
        cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1)
        UIView.animate(withDuration: 0.5, animations: {
            cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
        })
    }
}
