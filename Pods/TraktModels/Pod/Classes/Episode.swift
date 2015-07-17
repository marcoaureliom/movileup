//
//  Episode.swift
//  movile-up-ios
//
//  Created by Marcelo Fabri on 16/04/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

import Foundation

public struct Identifiers {
    public let trakt: Int
    public let tvdb: Int?
    public let imdb: String?
    public let tmdb: Int?
    public let tvrage: Int?
    public let slug: String?
}

extension Identifiers: JSONDecodable {
    public static func decode(j: AnyObject) -> Identifiers? {
        if let json = j as? NSDictionary,
            trakt = json["trakt"] as? Int {
                
                let tvdb = json["tvdb"] as? Int
                let imdb = json["imdb"] as? String
                let tmdb = json["tmdb"] as? Int
                let tvrage = json["tvrage"] as? Int
                let slug = json["slug"] as? String
                
                return Identifiers(trakt: trakt, tvdb: tvdb, imdb: imdb, tmdb: tmdb, tvrage: tvrage, slug: slug)
        }
        
        return nil
    }
}

public struct ImagesURLs {
    public let fullImageURL: NSURL?
    public let mediumImageURL: NSURL?
    public let thumbImageURL: NSURL?
}

extension ImagesURLs: JSONDecodable {
    public static func decode(j: AnyObject) -> ImagesURLs? {
        if let json = j as? NSDictionary {
            let full = json["full"] as? String
            let medium = json["medium"] as? String
            let thumb = json["thumb"] as? String
            
            return ImagesURLs(fullImageURL: JSONParseUtils.parseURL(full),
                mediumImageURL: JSONParseUtils.parseURL(medium),
                thumbImageURL: JSONParseUtils.parseURL(thumb))
        }
        
        return nil
    }
}


public struct Episode {
    public let number: Int
    public let seasonNumber: Int
    public let title: String?
    public let identifiers: Identifiers?
    public let overview: String?
    public let firstAired: NSDate?
    public let rating: Float?
    public let votes: Int?
    public let screenshot: ImagesURLs?
}

extension Episode: JSONDecodable {
    public static func decode(j: AnyObject) -> Episode? {
        
        if let json = j as? NSDictionary,
            number = json["number"] as? Int,
            seasonNumber = json["season"] as? Int {
                let title = json["title"] as? String
                let ids = flatMap(json["ids"]) { Identifiers.decode($0) }
                let overview = json["overview"] as? String
                let firstAired = JSONParseUtils.parseDate(json["first_aired"] as? String)
                let rating = json["rating"] as? Float
                let votes = json["votes"] as? Int
                
                let screenshot = flatMap(json["images"]?["screenshot"]) { ImagesURLs.decode($0) }
                
                return Episode(number: number, seasonNumber: seasonNumber, title: title, identifiers: ids, overview: overview, firstAired: firstAired, rating: rating, votes: votes, screenshot: screenshot)
        }
        
        return nil
    }
}
