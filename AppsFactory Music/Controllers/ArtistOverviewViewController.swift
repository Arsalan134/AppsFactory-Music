//
//  AlbumOverviewViewController.swift
//  AppsFactory Music
//
//  Created by Arsalan Iravani on 26/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import UIKit

class ArtistOverviewViewController: UIViewController {
    
    var artist: Artist?
    
    private var albums: [Album] = []
    
    @IBOutlet weak var artistImageView: UIImageView!
    @IBOutlet weak var albumsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupDetails()
        artistImageView.fadeView(style: .bottom, percentage: 0.5)
    }
    
    func setupDetails() {
        if let imageURL = artist?.pictureBig {
            if let url = URL(string: imageURL) {
                artistImageView.af.setImage(withURL: url)
                artistImageView.image.color
            }
        }
        
        if let artistID = artist?.id {
            API.downloadAlbums(withID: artistID) { [unowned self] albums in
                self.albums = albums
                self.albumsTableView.reloadData()
            }
        }
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ArtistOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumCell", for: indexPath) as! AlbumTableViewCell
        
        cell.setValues(with: albums[indexPath.row], imageSize: .small, index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}
