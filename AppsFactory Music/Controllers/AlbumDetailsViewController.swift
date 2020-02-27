//
//  DetailsViewController.swift
//  LastFM Music
//
//  Created by Arsalan Iravani on 24/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import UIKit
import MarqueeLabel
import UIImageColors
import JGProgressHUD

class AlbumDetailsViewController: UIViewController {
    
    var album: Album?
    
    private var tracks: [Track] = []
    private var trackResponse: TrackResponse?
    private var colors: UIImageColors?
    
    @IBOutlet weak var albumImageView: UIImageView!
    @IBOutlet weak var albumNameAndArtistLabel: MarqueeLabel!
    
    @IBOutlet weak var tracksTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        album name
        //        artist
        //        image or imageURL
        //        tracks
        
        setupDetails()
        setupLayout()
    }
    
    
    @IBAction func moreButtonPressed() {
        guard let album = album else {
            return
        }
        
        let optionMenu = UIAlertController(title: "Chose an option", message: "Choose an option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] action in
            guard let self = self else { return }
            RealmManager.shared.deleteAlbumFromRealm(withID: album.id)
            self.presentHUD(with: "Deleted")
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self] action in
            guard let self = self else { return }
            RealmManager.shared.saveAlbumToRealm(album)
            self.presentHUD(with: "Saved")
        }
        
        RealmManager.shared.loadAlbumsFromRealm { albums in
            
            if albums.filter({$0.id == album.id}).isEmpty {
                deleteAction.isEnabled = false
            } else {
                saveAction.isEnabled = false
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            optionMenu.addAction(deleteAction)
            optionMenu.addAction(saveAction)
            optionMenu.addAction(cancelAction)
            
            self.present(optionMenu, animated: true)
        }
    }
    
    private func presentHUD(with message: String) {
        let hud = JGProgressHUD(style: .dark)
        hud.indicatorView = JGProgressHUDSuccessIndicatorView()
        hud.vibrancyEnabled = true
        hud.interactionType = .blockNoTouches
        hud.isUserInteractionEnabled = false
        hud.textLabel.text = message
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 1.0)
    }
    
    private func setupDetails() {
        
        guard let album = album else {
            return
        }
        
        albumNameAndArtistLabel.text = "\(album.title ?? "")"
        
        if let imageURL = album.coverBig {
            if let url = URL(string: imageURL) {
                albumImageView.af.setImage(withURL: url) { [weak self] _ in
                    guard let self = self else { return }
                    self.albumImageView.image?.getColors(quality: .lowest, { colors in
                        self.colors = colors
                        
                        self.albumNameAndArtistLabel.textColor = colors?.detail
                        self.albumImageView.fadeView(style: .bottom, percentage: 0.5, bottomColor: colors?.background ?? .black)
                        self.tracksTableView.reloadData()
                        
                        UIView.animate(withDuration: 0.5) {
                            self.view.backgroundColor = colors?.background ?? .red
                        }
                    })
                }
            }
        }
        
        API.downloadTracks(withID: album.id) { [weak self] trackResponse in
            guard let self = self else { return }
            self.tracks = trackResponse.data ?? []
            self.tracksTableView.reloadData()
        }
        
    }
    
    private func setupLayout() {
        
        let leadingSpace: CGFloat = 20
        
        albumNameAndArtistLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            albumNameAndArtistLabel.bottomAnchor.constraint(equalTo: tracksTableView.topAnchor, constant: -10),
            albumNameAndArtistLabel.heightAnchor.constraint(equalToConstant: 50),
            albumNameAndArtistLabel.leadingAnchor.constraint(equalTo: tracksTableView.leadingAnchor, constant: leadingSpace),
            albumNameAndArtistLabel.trailingAnchor.constraint(equalTo: tracksTableView.trailingAnchor, constant: -leadingSpace)
        ])
        
    }
    
}

extension AlbumDetailsViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath) as! TrackTableViewCell
        cell.setValues(with: tracks[indexPath.row], index: indexPath.row, colors: colors)
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.max()?.row == (trackResponse?.data?.count ?? 0) - 1 {
            API.downloadTracks(withURL: trackResponse?.next) { [weak self] trackResponse in
                guard let self = self else { return }
                self.trackResponse?.next = trackResponse.next
                self.trackResponse?.data?.append(contentsOf: trackResponse.data ?? [])
                self.tracksTableView.reloadData()
            }
        }
    }
    
}
