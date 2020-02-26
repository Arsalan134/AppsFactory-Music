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
    
    private var selectedArtistIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupDetails()
        artistImageView.fadeView(style: .bottom, percentage: 0.5, bottomColor: .white)
        //        albumsTableView.fadeView(style: .top, percentage: 0.5)
    }
    
    func setupDetails() {
        if let imageURL = artist?.pictureBig {
            if let url = URL(string: imageURL) {
                
                artistImageView.af.setImage(withURL: url) { [weak self] image in
                    if let data = image.data {
                        if let image = UIImage(data: data) {
                            image.getColors(quality: .lowest, { colors in
                                self?.colors = colors
                                self?.view.backgroundColor = colors?.background ?? .red
                                self?.albumsTableView.reloadData()
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
            cell.setValues(with: album, imageSize: .small, index: indexPath.row, colors: colors)
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
                self?.albumResponse?.next = albumResponse.next
                self?.albumResponse?.data?.append(contentsOf: albumResponse.data ?? [])
                self?.albumsTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! AlbumTableViewCell
        cell.albumNameLabel.fadeView(style: .right, percentage: 0.5, bottomColor: .red)
    }
    
}
