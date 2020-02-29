//
//  AlbumTrack.swift
//  AppsFactory Music
//
//  Created by Arsalan Iravani on 29/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import Foundation
import RealmSwift

class AlbumTrack: Object {

    @objc dynamic var trackID: Int = 0
    @objc dynamic var albumID: Int = 0
    
    override static func primaryKey() -> String? {
        return "trackID"
    }
}
