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
    
    static let shared = RealmManager()
    
    private static var realm: Realm?
    
    private init() {
        do {
            var configuration = Realm.Configuration()
            configuration.deleteRealmIfMigrationNeeded = true
            //            configuration.schemaVersion = 999
            RealmManager.realm = try Realm(configuration: configuration)
            //            print(RealmManager.realm?.configuration.fileURL ?? "")
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    func saveAlbumToRealm(_ album: Album) {
        do {
            try RealmManager.realm?.write {
                RealmManager.realm?.add(album, update: .modified)
                print("Saved album to realm", album)
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
    
    func deleteAlbumFromRealm(withID id: Int) {
        loadAlbumsFromRealm { albums in
            if let album = albums.filter({$0.id == id}).first {
                do {
                    try RealmManager.realm?.write {
                        RealmManager.realm?.delete(album)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
}
