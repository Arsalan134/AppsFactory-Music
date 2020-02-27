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
    
    static func downloadAlbums(withID id: Int? = nil, withURL url: String? = nil, completion: @escaping (_ albumResponse: AlbumResponse) -> Void) {
        
        var requestURL = ""
        if let id = id {
            requestURL = completeUrl("/artist/\(id)/albums")
        } else if let url = url {
            requestURL = url
        }
        
        AF.request(requestURL).responseJSON { response in
            
            guard let data = response.data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let albumsResponse = try decoder.decode(AlbumResponse.self, from: data)
                completion(albumsResponse)
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    static func downloadTracks(withID id: Int? = nil, withURL url: String? = nil, completion: @escaping (_ trackResponse: TrackResponse) -> Void) {
        
        var requestURL = ""
        if let id = id {
            requestURL = completeUrl("/album/\(id)/tracks")
        } else if let url = url {
            requestURL = url
        }
        
        AF.request(requestURL).responseJSON { response in
            
            guard let data = response.data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let tracksResponse = try decoder.decode(TrackResponse.self, from: data)
                
                if let id = id {
                    tracksResponse.data?.forEach({$0.albumID = id})
                } else { // In pagination we pass absulute link to next elements but not id. That's why id may become nil
                    tracksResponse.data?.forEach({$0.albumID = tracksResponse.data?.first?.id})
                }
                
                completion(tracksResponse)
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
}
