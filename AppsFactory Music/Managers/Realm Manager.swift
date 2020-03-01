//
//  Realm Manager.swift
//  LastFM Music
//
//  Created by Arsalan Iravani on 24/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static var shared = RealmManager()
    static var realm: Realm?
    
    private init() {
        do {
            var configuration = Realm.Configuration()
            configuration.deleteRealmIfMigrationNeeded = true
            RealmManager.realm = try Realm(configuration: configuration)
            RealmManager.realm?.autorefresh = true
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveAlbumToRealm(_ album: Album, tracks: [Track]) {
        do {
            try RealmManager.realm?.write {
                RealmManager.realm?.add(album, update: .all)
                
                RealmManager.realm?.add(tracks, update: .all)
                
                tracks.forEach { track in
                    let albumTrack = AlbumTrack()
                    albumTrack.albumID = album.id
                    albumTrack.trackID = track.id
                    RealmManager.realm?.add(albumTrack, update: .all)
                }
                
                try RealmManager.realm?.commitWrite()
                RealmManager.realm?.refresh()
            }
        } catch {
            print("Realm error @RealmSettings set", error.localizedDescription)
        }
    }
    
    func loadAlbumsFromRealm(completion: @escaping (_ albums: [Album]) -> Void) {
        
        guard let albumRealm = RealmManager.realm?.objects(Album.self) else {
            completion([])
            return
        }
        
        completion(Array(albumRealm))
    }
    
    func loadTracksFromRealm(withAlbumID id: Int, completion: @escaping (_ tracks: [Track]) -> Void) {
    
        guard let albumTrackResult = RealmManager.realm?.objects(AlbumTrack.self) else { return }
        guard let tracksResult = RealmManager.realm?.objects(Track.self) else { return }
        
        let trackIDs = Array(albumTrackResult).filter({$0.albumID == id}).compactMap({$0.trackID})
        let tracks = tracksResult.filter({trackIDs.contains($0.id)})
        
        completion(Array(tracks))
    }
    
    func deleteAlbumFromRealm(withID id: Int) {
        
        if let album = RealmManager.realm?.objects(Album.self).filter({$0.id == id}).first {
            do {
                try RealmManager.realm?.write {
                    RealmManager.realm?.delete(album)
                    try RealmManager.realm?.commitWrite()
                    RealmManager.realm?.refresh()
                }
            } catch {
                print(error.localizedDescription)
                print("there is error with delete Realm object ! : \(error)")
            }
        } else {
            print("Album with ID: \(id) is not found")
        }
    }
    
}
