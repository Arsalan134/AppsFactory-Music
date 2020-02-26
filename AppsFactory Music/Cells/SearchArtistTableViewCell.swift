//
//  SearchArtistTableViewCell.swift
//  AppsFactory Music
//
//  Created by Arsalan Iravani on 26/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import UIKit

class SearchArtistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var artistImageView: UIImageView!
    
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setValues(with artist: Artist, imageSize size: ImageSize) {
        artistNameLabel.text = artist.name
        
        artistImageView.image = nil
        
        if let imageURL = artist.pictureSmall {
            if let url = URL(string: imageURL) {
                artistImageView.af.setImage(withURL: url)
            }
        }
    }
    
}

