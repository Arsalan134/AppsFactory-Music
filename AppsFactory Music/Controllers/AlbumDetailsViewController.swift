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
    
    func previewActions() -> [UIPreviewActionItem] {
        let previewAction1 = UIPreviewAction.init(title: "Preview Action 1", style: .default) { (action, vcRefrence) in
            print("Tapped")
        }
        
        let previewAction2 = UIPreviewAction.init(title: "Preview Action 2", style: .default) { (action, vcRefrence) in
            print("Tapped")
        }
        return [previewAction1, previewAction2]
    }
    
}
