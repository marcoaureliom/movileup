//
//  TraktHTTPClient.swift
//  movileup
//
//  Created by iOS on 7/22/15.
//  Copyright (c) 2015 movile. All rights reserved.
//

import Alamofire
import UIKit
import Result
import TraktModels

private enum Router : URLRequestConvertible {
    
    static let baseURLString = "https://api-v2launch.trakt.tv/"
    
    case PopularShows(Int)
    case Show(String)
    case Seasons(String)
    case Season(String, Int)
    case Episodes(String, Int)
    case Episode(String, Int, Int)
    
    var URLRequest: NSURLRequest {
        let (path: String, parameters: [String: AnyObject]?, method: Alamofire.Method) = {
            switch self {
                
            case .PopularShows(let page):
                return ("shows/popular", ["extended": "images", "limit" : "20", "page" : String(page)], .GET)
                
            case .Show(let id):
                return ("shows/\(id)", ["extended": "images,full"], .GET)
                
            case .Seasons(let showID):
                return ("shows/\(showID)/seasons", ["extended": "images,full"], .GET)
                
            case .Season(let showID, let season):
                return ("shows/\(showID)/seasons/\(season)", nil, .GET)
                
            case .Episodes(let showID, let season):
                return ("shows/\(showID)/seasons/\(season)/episodes", ["extended" : "images,full"], .GET)
                
            case .Episode(let showID, let season, let episode):
                return ("shows/\(showID)/seasons/\(season)/episodes/\(episode)", ["extended" : "full,images"], .GET)
                
            }
            }()
        
        let URL = NSURL(string: Router.baseURLString)!
        let URLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        URLRequest.HTTPMethod = method.rawValue
        
        let encoding = Alamofire.ParameterEncoding.URL
        
        return encoding.encode(URLRequest, parameters: parameters).0
    }
}

class TraktHTTPClient {
    
    private lazy var manager: Alamofire.Manager = {
        
        let configuration: NSURLSessionConfiguration = {
            
            var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            
            var headers = Alamofire.Manager.defaultHTTPHeaders
            headers["Accept-Encoding"] = "gzip"
            headers["content-type"] = "application/json"
            headers["trakt-api-key"] = "4f5d3c5abda93cf0bc2697e8fe8cbc23257112a5f8130b47fa8c651c3d51beed"
            headers["trakt-api-version"] = "2"
            
            configuration.HTTPAdditionalHeaders = headers
            
            return configuration
            }()
        
        return Manager(configuration: configuration)
        }()
    
    private func getJSONElement<T: JSONDecodable>(router: Router, completion: ((Result<T, NSError?>) ->Void)?) {
        
        manager.request(router).validate().responseJSON {
            
            (_, _, data, error) in
            
            if let json = data as? NSDictionary {
                
                if let value = T.decode(json) {
                    completion?(Result.success(value))
                }
                else {
                    completion?(Result.failure(nil))
                }
            }
            else {
                completion?(Result.failure(error))
            }
        }
    }
    
    
    private func getJSONElements<T: JSONDecodable>(router: Router, completion: ((Result<[T], NSError?>) -> Void)?) {
        
        manager.request(router).validate().responseJSON {
            
            (_, _, data, error) in
            
            var values : [T] = []
            
            if let dataArray = data as? [NSDictionary] {
                
                values = dataArray.map { T.decode($0) }.filter { $0 != nil }.map { $0! }
                
                completion?(Result.success(values))
            }
            else {
                completion?(Result.failure(error))
            }
        }
    }
    
    
    
    func getPopularShows(page: Int, completion: ((Result<[Show], NSError?>) -> Void)?) {
        
        getJSONElements(Router.PopularShows(page), completion: completion)
    }
    
    func getShow(id: String, completion: ((Result<Show, NSError?>) -> Void)?) {
        
        getJSONElement(Router.Show(id), completion: completion)
    }
    
    func getSeasons(showID: String, completion: ((Result<[Season], NSError?>) -> Void)?) {
        
        getJSONElements(Router.Seasons(showID), completion: completion)
    }
    
    func getEpisodes(showID: String, season: Int, completion: ((Result<[Episode], NSError?>) -> Void)?) {
        
        getJSONElements(Router.Episodes(showID, season), completion: completion)
    }
    
    func getEpisode(showID: String, season: Int, episodeNumber: Int, completion: ((Result<Episode, NSError?>) -> Void)?) {
        
        getJSONElement(Router.Episode(showID, season, episodeNumber), completion: completion)
    }
    
}

