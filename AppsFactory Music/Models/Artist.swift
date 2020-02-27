//
//  Artist.swift
//  LastFM Music
//
//  Created by Arsalan Iravani on 25/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import Foundation
import RealmSwift

//struct ArtistDataResponse: Decodable {
//    var id: Int?
//    var title: String?
//    var titleShort: String?
//    var link: String?
//    var duration: Int?
//    var rank: Int?
//    var preview: String?
//    var artist: Artist?
//    var album: Album?
//}

//struct ArtistResponse: Decodable {
//    var data: [ArtistDataResponse]?
//    var next: String?
//    var total: Int?
//}

struct ArtistSearchResponse: Decodable {
    var data: [Artist]?
    var next: String?
    var total: Int?
}


class Artist: Object, Decodable {
    
    @objc dynamic var id: Int
    @objc dynamic var name: String?
    @objc dynamic var link: String?
    @objc dynamic var picture: String?
    @objc dynamic var pictureSmall: String?
    @objc dynamic var pictureMedium: String?
    @objc dynamic var pictureBig: String?
    @objc dynamic var pictureXl: String?
    @objc dynamic var tracklist: String?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
}
