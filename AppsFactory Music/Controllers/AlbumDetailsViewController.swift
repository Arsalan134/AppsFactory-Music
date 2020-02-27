//
//  DetailsViewController.swift
//  LastFM Music
//
//  Created by Arsalan Iravani on 24/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import UIKit
import MarqueeLabel

class AlbumDetailsViewController: UIViewController {
    
    var album: Album?
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameAndArtistLabel: MarqueeLabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        album name
        //        artist
        //        image or imageURL
        //        tracks
        
        setupDetails()
    }
    
    private func setupDetails() {
        
        guard let album = album else {
            return
        }
        
        albumNameAndArtistLabel.text = "\(album.title ?? "")"
        
        if let imageURL = album.coverBig {
            if let url = URL(string: imageURL) {
                albumImageView.af.setImage(withURL: url, placeholderImage: UIImage(contentsOfFile: "albumPlaceholder"))
            }
        }
        
    }
    
    
}
