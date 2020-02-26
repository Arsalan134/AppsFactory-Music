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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        albumNameAndArtistLabel.type = .leftRight
        albumNameAndArtistLabel.speed = .rate(40)
        
    }
    
    private func setupDetails() {
        
        guard let album = album else {
            return
        }
        
//        albumNameAndArtistLabel.text = "\(album.title ?? "") - \(album.artist ?? "")"
        
//        if let imageURL = album.image.filter({$0.size == "extralarge"}).first?.text {
//            if let url = URL(string: imageURL) {
//                albumImageView.af.setImage(withURL: url, placeholderImage: UIImage(contentsOfFile: "albumPlaceholder"))
//            }
//        }
        
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
