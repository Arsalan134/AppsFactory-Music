//
//  AlbumCollectionViewCell.swift
//  LastFM Music
//
//  Created by Arsalan Iravani on 24/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import UIKit
import AlamofireImage
import MarqueeLabel

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: MarqueeLabel!
    @IBOutlet weak var albumArtistLabel: MarqueeLabel!
    
    override func awakeFromNib() {
        
        albumImageView.layer.cornerRadius = 6
        albumImageView.clipsToBounds = true
    }
    
    func setValues(with album: Album) {
        
        albumNameLabel.text = album.title
        albumArtistLabel.text = album.releaseDate
        
        albumImageView.image = nil
        
        // Download an Album Image
        if let imageURL = album.coverMedium {
            if let url = URL(string: imageURL) {
                albumImageView.af.setImage(withURL: url)
            }
        }
        
    }
    
}
