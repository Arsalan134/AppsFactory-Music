//
//  AlbumTableViewCell.swift
//  AppsFactory Music
//
//  Created by Arsalan Iravani on 26/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import UIKit
import UIImageColors

class AlbumTableViewCell: UITableViewCell {

    @IBOutlet weak var indexLabel: UILabel!
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameLabel: UILabel!
    @IBOutlet weak var albumDetailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setValues(with album: Album, imageSize size: ImageSize, index: Int, colors: UIImageColors?) {
        
        albumImageView.layer.cornerRadius = 10
        albumImageView.clipsToBounds = true
        
        indexLabel.text = "\(index + 1)"
        
        indexLabel.textColor = colors?.secondary
        albumNameLabel.textColor = colors?.primary
        albumDetailLabel.textColor = colors?.detail

        albumNameLabel.text = album.title
        albumDetailLabel.text = album.releaseDate
        
        if let imageURL = album.coverMedium {
            if let url = URL(string: imageURL) {
                albumImageView.af.setImage(withURL: url)
            }
        }

    }
    
}
