//
//  ViewController.swift
//  LastFM Music
//
//  Created by Arsalan Iravani on 24/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    private var localAlbums: [Album] = []
    
    @IBOutlet weak var noAlbumLabel: UILabel!
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    private var selectedCategory: String?
    
    private var selectedAlbumIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve local albums
        RealmManager.shared.loadAlbumsFromRealm { [weak self] albums in
            guard let self = self else { return }
            self.localAlbums = albums
            self.noAlbumLabel.isHidden = !albums.isEmpty
            self.albumsCollectionView.reloadData()
        }
        
        if #available(iOS 13.0, *) {
            self.navigationController?.navigationBar.tintColor = .label
        } else {
            self.navigationController?.navigationBar.tintColor = .white
        }
    }
    
    @objc func search() {
        performSegue(withIdentifier: "searchViewSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? AlbumDetailsViewController {
            if let index = selectedAlbumIndex {
                destination.album = localAlbums[index]
            }
        }
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        localAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! AlbumCollectionViewCell
        
        cell.setValues(with: localAlbums[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        selectedAlbumIndex = indexPath.row
        performSegue(withIdentifier: "albumDetailViewSegue", sender: nil)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width * 0.45, height: 250)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let numberOfCellsInRow: CGFloat = 2.0
        let cellWidth = collectionView.frame.width * 0.45
        
        let totalCellWidth = cellWidth * numberOfCellsInRow
        
        let inset = (collectionView.frame.width - CGFloat(totalCellWidth)) / (numberOfCellsInRow + 1)
        
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    
    
}
