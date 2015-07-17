//
//  Season.swift
//  movile-up-ios
//
//  Created by Marcelo Fabri on 28/04/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation

public struct Season {
    public let number: Int
    public let identifiers: Identifiers?
    public let rating: Float?
    public let votes: Int?
    public let episodeCount: Int?
    public let airedEpisodes: Int?
    public let overview: String?
    public let poster: ImagesURLs?
    public let thumbImageURL: NSURL?
}

extension Season: JSONDecodable {    
    public static func decode(j: AnyObject) -> Season? {
        if let json = j as? NSDictionary,
            number = json["number"] as? Int {
                let ids = flatMap(json["ids"]) { Identifiers.decode($0) }
                let rating = json["rating"] as? Float
                let votes = json["votes"] as? Int
                let episodeCount = json["episode_count"] as? Int
                let airedEpisodes = json["aired_episodes"] as? Int
                let overview = json["overview"] as? String
                let images = json["images"] as? NSDictionary
                
                let poster = flatMap(images?["poster"]) { ImagesURLs.decode($0) }
                
                let full = (images?["thumb"] as? NSDictionary)?["full"] as? String
                let thumbImageURL = JSONParseUtils.parseURL(full)
                
                return Season(number: number, identifiers: ids, rating: rating, votes: votes, episodeCount: episodeCount, airedEpisodes: airedEpisodes, overview: overview, poster: poster, thumbImageURL: thumbImageURL)
        }
        
        return nil
    }
}