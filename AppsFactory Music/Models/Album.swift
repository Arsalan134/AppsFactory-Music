//
//  Album.swift
//  LastFM Music
//
//  Created by Arsalan Iravani on 24/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import Foundation
import RealmSwift

enum ImageSize: String {
    case small, medium, large, extralarge, mega
}

struct AlbumResponse: Decodable {
    var data: [Album]?
    var next: String?
    var total: Int?
}


class Album: Object, Decodable {
    
    @objc dynamic var id: Int
    @objc dynamic var title: String?
    @objc dynamic var cover: String?
    @objc dynamic var coverSmall: String?
    @objc dynamic var coverMedium: String?
    @objc dynamic var coverBig: String?
    @objc dynamic var coverXl: String?
    @objc dynamic var tracklist: String?
    
    //    var image = List<Image>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    //    private enum CodingKeys: String, CodingKey {
    //        case name, artist, url, id = "mbid", image
    //    }
}
