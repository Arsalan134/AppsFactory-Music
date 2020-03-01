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
    @IBOutlet weak var iphoneImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
    }
     
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        selectionStyle = .none
    }

    func setValues(with album: Album, index: Int, colors: UIImageColors?) {
        
        albumImageView.layer.cornerRadius = 10
        albumImageView.clipsToBounds = true
        
        // Colors
        indexLabel.textColor = colors?.detail
        albumNameLabel.textColor = colors?.primary
        albumDetailLabel.textColor = colors?.secondary
        iphoneImageView.tintColor = colors?.detail

        // Text
        indexLabel.text = "\(index + 1)"
        albumNameLabel.text = album.title
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"

        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"

        if let releaseDate = album.releaseDate, let date = dateFormatterGet.date(from: releaseDate) {
            albumDetailLabel.text = "Released: \(dateFormatterPrint.string(from: date))"
        } else {
           print("There was an error decoding the string")
        }
        
        // Image Downloading
        albumImageView.image = nil
        if let imageURL = album.coverMedium {
            if let url = URL(string: imageURL) {
                albumImageView.af.setImage(withURL: url)
            }
        }
    }
    
}
