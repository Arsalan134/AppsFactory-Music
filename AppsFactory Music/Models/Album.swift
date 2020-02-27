//
//  Album.swift
//  LastFM Music
//
//  Created by Arsalan Iravani on 24/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import Foundation
import RealmSwift

struct AlbumResponse: Decodable {
    var data: [Album]?
    var prex: String?
    var next: String?
    var total: Int?
}

class Album: Object, Decodable {
    
    @objc dynamic var id: Int
    @objc dynamic var title: String?
    @objc dynamic var cover: String?
    @objc dynamic var coverSmall: String?
    @objc dynamic var releaseDate: String?
    @objc dynamic var coverMedium: String?
    @objc dynamic var coverBig: String?
    @objc dynamic var coverXl: String?
    @objc dynamic var tracklist: String?
    
    @objc dynamic var tracks = List<Track>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    static func ==(lhs: Album, rhs: Album) -> Bool {
//        return lhs.title == rhs.title
//    }
    
}
