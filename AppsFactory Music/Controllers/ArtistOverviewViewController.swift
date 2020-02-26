//
//  AlbumOverviewViewController.swift
//  AppsFactory Music
//
//  Created by Arsalan Iravani on 26/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import UIKit
import UIImageColors

class ArtistOverviewViewController: UIViewController {
    
    var artist: Artist?
    
    private var albumResponse: AlbumResponse?
    private var colors: UIImageColors?
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var albumsTableView: UITableView!
    
    @IBOutlet weak var albumsLabel: UILabel!
    
    private var selectedArtistIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDetails()
        artistImageView.fadeView(style: .bottom, percentage: 0.5, bottomColor: .white)
    }
    
    func setupDetails() {
        if let imageURL = artist?.pictureXl {
            if let url = URL(string: imageURL) {
                
                artistImageView.af.setImage(withURL: url) { [weak self] image in
                    if let data = image.data {
                        if let image = UIImage(data: data) {
                            image.getColors(quality: .lowest, { colors in
                                self?.colors = colors
                                self?.albumsTableView.reloadData()
                                self?.albumsLabel.textColor = colors?.detail
                                
                                UIView.animate(withDuration: 0.5) {
                                    self?.view.backgroundColor = colors?.background ?? .red
                                }
                            })
                        }
                    }
                }
            }
        }
        
        if let artistID = artist?.id {
            API.downloadAlbums(withID: artistID) { [weak self] albumsData in
                self?.albumResponse = albumsData
                self?.albumsTableView.reloadData()
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
        }
        
        cell.moreButton.tag = indexPath.row
        cell.moreDelegate = self
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
                self?.albumResponse?.next = albumResponse.next
                self?.albumResponse?.data?.append(contentsOf: albumResponse.data ?? [])
                self?.albumsTableView.reloadData()
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

extension ArtistOverviewViewController: MorePressedDelegate {
    func morePressed(withAlbumIndex index: Int) {
        
        guard let album = self.albumResponse?.data?[index] else {
            return
        }
        
        let optionMenu = UIAlertController(title: "Chose an option", message: "Choose an option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { action in
            RealmManager.shared.deleteAlbumFromRealm(withID: album.id)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            RealmManager.shared.saveAlbumToRealm(album)
        }
        
        RealmManager.shared.loadAlbumsFromRealm { albums in
            if albums.filter({$0.id == album.id}).isEmpty {
                deleteAction.isEnabled = false
            } else {
                saveAction.isEnabled = false
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            optionMenu.addAction(deleteAction)
            optionMenu.addAction(saveAction)
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true)
        }
        
        
    }
    
    
}
