//
//  API.swift
//  LastFM Music
//
//  Created by Arsalan Iravani on 24/02/2020.
//  Copyright © 2020 Arsalan Iravani. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class API {
    
    private static let baseURL = "https://api.deezer.com"
    
    private init() {
        
    }
    
    private static func completeUrl(_ relativeURL: String) -> String {
        return baseURL + relativeURL
    }
    
    static func downloadArtists(withKeyword keyword: String, completion: @escaping (_ artists: [Artist]) -> Void) {
        
        let url = completeUrl("/search/artist?q=\(keyword)")
        
        AF.request(url).responseJSON { response in
            
            guard let data = response.data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let artistsResponse = try decoder.decode(ArtistSearchResponse.self, from: data)
                completion(artistsResponse.data ?? [])
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    static func downloadAlbums(withID id: Int, completion: @escaping (_ albums: [Album]) -> Void) {
        
        let url = completeUrl("/artist/\(id)/albums")
        
        AF.request(url).responseJSON { response in
            
            guard let data = response.data else {
                return
            }

            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let albumsResponse = try decoder.decode(AlbumResponse.self, from: data)
                completion(albumsResponse.data ?? [])
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}
