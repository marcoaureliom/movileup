//
//  Show.swift
//  movile-up-ios
//
//  Created by Marcelo Fabri on 17/04/15.
//  Copyright (c) 2015 Movile. All rights reserved.
//

public enum ShowStatus: String {
    case Returning = "returning series"
    case InProduction = "in production"
    case Canceled = "canceled"
    case Ended = "ended"
}

extension ShowStatus: JSONDecodable {
    public static func decode(j: AnyObject) -> ShowStatus? {
        if let json = j as? String {
            return ShowStatus(rawValue: json)
        }
        
        return nil
    }
}

public struct Show {
    public let title: String
    public let year: Int
    public let identifiers: Identifiers
    public let overview: String?
    public let firstAired: NSDate?
    public let runtime: Int?
    public let network: String?
    public let country: String?
    public let trailerURL: NSURL?
    public let homepageURL: NSURL?
    public let status: ShowStatus?
    public let rating: Float?
    public let votes: Int?
    public let genres: [String]?
    public let airedEpisodes: Int?
    public let fanart: ImagesURLs?
    public let poster: ImagesURLs?
    public let logoImageURL: NSURL?
    public let clearArtImageURL: NSURL?
    public let bannerImageURL: NSURL?
    public let thumbImageURL: NSURL?
}

extension Show: JSONDecodable {
    
    private static func fullImageURL(j: AnyObject?) -> NSURL? {
        if let json = j as? NSDictionary {
            return flatMap(json["full"] as? String) { JSONParseUtils.parseURL($0) }
        }
        
        return nil
    }
    
    public static func decode(j: AnyObject) -> Show? {
        if let json = j as? NSDictionary,
            title = json["title"] as? String,
            year = json["year"] as? Int,
            ids = flatMap(json["ids"], { Identifiers.decode($0) }) {
                let overview = json["overview"] as? String
                let firstAired = JSONParseUtils.parseDate(json["first_aired"] as? String)
                let runtime = json["runtime"] as? Int
                let network = json["network"] as? String
                let country = json["country"] as? String
                let trailerURL = JSONParseUtils.parseURL(json["trailer"] as? String)
                let homepageURL = JSONParseUtils.parseURL(json["homepage"] as? String)
                let status = flatMap(json["status"]) { ShowStatus.decode($0) }
                let rating = json["rating"] as? Float
                let votes = json["votes"] as? Int
                let genres = json["genres"] as? [String]
                let airedEpisodes = json["aired_episodes"] as? Int
                
                let images = json["images"] as? NSDictionary
                let fanart = flatMap(images?["fanart"]) { ImagesURLs.decode($0) }
                let poster = flatMap(images?["poster"]) { ImagesURLs.decode($0) }
                let logoImageURL = fullImageURL(images?["logo"])
                let clearArtImageURL = fullImageURL(images?["clearart"])
                let bannerImageURL = fullImageURL(images?["banner"])
                let thumbImageURL = fullImageURL(images?["thumb"])
                
                return Show(title: title, year: year, identifiers: ids, overview: overview, firstAired: firstAired, runtime: runtime, network: network, country: country, trailerURL: trailerURL, homepageURL: homepageURL, status: status, rating: rating, votes: votes, genres: genres, airedEpisodes: airedEpisodes, fanart: fanart, poster: poster, logoImageURL: logoImageURL, clearArtImageURL: clearArtImageURL, bannerImageURL: bannerImageURL, thumbImageURL: thumbImageURL)
        }
        
        return nil
    }
}

