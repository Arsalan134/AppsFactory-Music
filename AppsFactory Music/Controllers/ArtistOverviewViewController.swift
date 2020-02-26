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
    
    private var albums: [Album] = []
    
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
                
                artistImageView.af.setImage(withURL: url) { [unowned self] image in
                    if let data = image.data {
                        if let image = UIImage(data: data) {
                            image.getColors(quality: .lowest, { colors in
                                self.colors = colors
                                self.view.backgroundColor = colors?.background ?? .red
                                self.albumsTableView.reloadData()
                            })
                        }
                    }
                }
            }
        }
        
        if let artistID = artist?.id {
            API.downloadAlbums(withID: artistID) { [unowned self] albums in
                self.albums = albums
                self.albumsTableView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AlbumDetailsViewController {
            if let index = selectedArtistIndex {
                destination.album = albums[index]
            }
        }
    }
    
}

extension ArtistOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        
        cell.setValues(with: albums[indexPath.row], imageSize: .small, index: indexPath.row, colors: colors)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedArtistIndex = indexPath.row
        performSegue(withIdentifier: "albumDetailViewSegue", sender: nil)
    }
    
}
